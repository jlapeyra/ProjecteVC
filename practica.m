
clear

rgb= 1; %boolean que indica si la classificacio es fa amb RGB o HSV
prompt = "Desitja realitzar la classificacio fent servir RGB o HSV? Premi 1 per a RGB. Premi 0 per a HSV.";
rgb = input(prompt);
main(11, 7, rgb);

function r = main(k, numbins, rgb)
    %%%%%% TRAIN %%%%%%
    num_train = 15;
    train = [1:num_train];

    finestresBD;
    num_img = size(train);
    for i = 1 : num_img(2)
        num_img = train(i);
        I = imread(getFilename('barcelona', num_img));
        if rgb == 0
            I = rgb2hsv(I);
        end

        R = getFinestra(I, finestres(num_img,:));

       % figure
       % imshow(R);

        X_train(i,:) = getX_Hist(R, numbins, rgb);
        %if rgb == 1 plotHistRGB_fromX(X_train(i,:), numbins, num2str(num_img));
        %else plotHistHSV_fromX(X_train(i,:), numbins, num2str(num_img));
        %end

    end


    %%%%%% TEST %%%%%%

    equips = ["acmilan", "barcelona", "chelsea", "juventus", "madrid", "psv"];

    j = 1;
    for equip = equips
        if equip == "barcelona"
            class = "b";
            i0 = num_train+1;
        else
            class = "nb";
            i0 = 1;
        end

        for i = i0:36 % recorrem les imatges de l'qeuip
            fn = getFilename(convertStringsToChars(equip), i);
            I = imread(fn);
            if rgb == 0
                I = rgb2hsv(I);
            end
            sz = size(I);
            Idimensions = [sz(2), sz(1), sz(2), sz(1)];
            for f = 1:num_train % recorrem les finestres de train
                finestra = finestres(f,:) ./ dimensions(f,:) .* Idimensions;
                R = getFinestra(I, ceil(finestra));
                X = getX_Hist(R, numbins, rgb);
                heuristic(f) = getHeuristic(X_train, X, k);
            end
            [m,f] = min(heuristic);
            finestra = finestres(f,:) ./ dimensions(f,:) .* Idimensions;
            R = getFinestra(I, ceil(finestra));

            %%%%mostra la finestra de la Ãºltima imatge de cada equip
            %if i == 36
                %figure
                %imshow(R);
            %end

            %%%%mostra la finestra de cada imatge de cada equip
            %figure
            %imshow(R);

            scores(j) = - min(heuristic);     
            labels(j) = class;
            j=j+1;
        end
    end

    [FPR, TPR, threshold, area] = perfcurve(labels, scores, 'b');
    area
    figure
    plot(FPR, TPR)
    ylabel("True Positive Rate");
    xlabel("False Positive Rate");
    title("Corba ROC");

    TNR = 1 - FPR;
    balanced_accuracy = (TNR + TPR)/2;
    figure
    plot(threshold, balanced_accuracy)
    ylabel("Balanced accuracy");
    xlabel("Threshold");
    title("Balanced accuracy");

    [maxim, idx] = max(balanced_accuracy);
    t = threshold(idx);
    prediccio = scores > t;
    real = labels == "b";
    
    aux = ["noBarça", "Barça"];
    prediccio = aux(1+prediccio);
    real = aux(1+real);
    figure
    M = confusionchart(real, prediccio);
    title("Matriu de confusió");
    r = maxim;
end

 
 
%%%%%%%%%-------FUNCIONS-------%%%%%%%%%

function X = getX_Hist(R, numbins, rgb)
    if rgb == 1
        X = getX_HistRGB(R, numbins);
    else
        X = getX_HistHSV(R, numbins);
    end
end

function X = getX_HistRGB(R, numbins)
    listedges = linspace(0, 255, numbins+1);
    X(1:numbins) =               histcounts(R(:,:,1), listedges);
    X(numbins+1 : numbins*2) =   histcounts(R(:,:,2), listedges);
    X(numbins*2+1 : numbins*3) = histcounts(R(:,:,3), listedges);
    X(:) = X(:)/max(X(:));
end

function X = getX_HistHSV(R, numbins)
    listedges = linspace(0, 1, numbins+1);
    X(1:numbins) =               histcounts(R(:,:,1), listedges);
    X(numbins+1 : numbins*2) =   histcounts(R(:,:,2), listedges);
    X(:) = X(:)/max(X(:));
end

function h = getHeuristic(X_train, X, k)

    [idx,d] = knnsearch(X_train, X, 'K', k);
    h = mean(d);
    
end

