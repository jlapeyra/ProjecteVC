% k = nombre de veïns a tenir en compte

% numbins = sombre de bins de l'hisotgrama

% rgb_hsv_hs == 1 : histograma en RGB
% rgb_hsv_hs == 2 : histograma en HSV
% rgb_hsv_hs == 3 : histograma en HS
% rgb_hsv_hs == 4 : histograma en H

% si llindar <= 0, l'algoritme el selecciona com a llindar
% altrament, slecciona el llindar que maximitza la balanced accuracy

% imatges_pos = conjunt d'índexs d'imatges de test/validació 
%               del Barça (classe positiva)
% imatges_neg = conjunt d'índexs d'imatges de test/validació 
%               de cada equip diferent al Barça (classe negativa)

% plot == 0 : no facis plots
% plot == 1 : fes plots de la corba ROC, etc


% max_ba = balanced accuarcy màxima del classificador
% area = àrea sota la corba ROC del calssificador

function max_ba = main(k, numbins, rgb_hsv_hs, llindar, imatges_pos, imatges_neg, plot_)
    %%%%%% TRAIN %%%%%%
    num_train = 15;
    train_set = 1:num_train;
    equips = {'acmilan', 'barcelona', 'chelsea', 'juventus', 'liverpool', 'madrid', 'psv'};
    
    aux = 0;
    finestresBD;
    for j = 1 : 7
        for i = 1 : num_train
            num_img = train_set(i);
            I = imread(getFilename(equips(j), num_img));
            if rgb_hsv_hs > 1
                I = rgb2hsv(I);
            end

            R = getFinestra(I, finestres(j,num_img,:));

           % figure
           % imshow(R);
            aux = aux + 1;
            X_train(aux,:) = getX_Hist(R, numbins, rgb_hsv_hs);
            Y_train(aux,:) = equips(j);
        end
    end
    

    %%%%%% VALIDACIÓ / TEST %%%%%%

    j = 1;
    loop_time = 0;
    for equip = equips
        class = equip;
        idx_imgs = imatges_pos;
        
        for i = idx_imgs % recorrem les imatges de l'equip
            fn = getFilename(convertStringsToChars(equip), i);
            I = imread(fn);
            if rgb_hsv_hs > 1
                I = rgb2hsv(I);
            end
            %tic;
            sz = size(I);
            Idimensions = [sz(2), sz(1), sz(2), sz(1)];
            for f = train_set % recorrem les finestres de train
                finestra = finestres(f,:) ./ dimensions(f,:) .* Idimensions;
                R = getFinestra(I, ceil(finestra));
                X = getX_Hist(R, numbins, rgb_hsv_hs);
                heuristic(f) = predict(X_train, Y_train, X, k);
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
            %loop_time = loop_time + toc;
        end
    end

    %loop_time % Mostra el temps utilitzat per a pendre decisions
    [FPR, TPR, threshold, area] = perfcurve(labels, scores, 'b');
    if plot_ == 1
        %area
        figure
        plot(FPR, TPR)
        ylabel("True Positive Rate");
        xlabel("False Positive Rate");
        title("Corba ROC");
        disp(strcat("Area sota la corba = ", num2str(area)));
    end

    if llindar > 0
        TNR = 1 - FPR;
        balanced_accuracy = (TNR + TPR)/2;
        if plot_ == 1
            figure
            plot(threshold, balanced_accuracy)
            ylabel("Balanced accuracy");
            xlabel("Threshold");
            title("Balanced accuracy");
        end

        [max_ba, idx] = max(balanced_accuracy);
        llindar = threshold(idx);
    end
    prediccio = scores > llindar;
    
    %real = labels == "b";
    
    aux = equips;
    prediccio = aux(1+prediccio);
    real = aux(1+real);
    
    if plot_ == 1
        figure
        M = confusionchart(real, prediccio);
        title("Matriu de confusi�");
    end
end


%%%%%%%%%-------FUNCIONS-------%%%%%%%%%

function X = getX_Hist(R, numbins, rgb_hsv_hs)
    
    if rgb_hsv_hs == 1 % RGB
        listedges = linspace(0, 255, numbins+1);
    else % HSV, HS
        listedges = linspace(0, 1, numbins+1);
    end
    
    X(1:numbins) =               histcounts(R(:,:,1), listedges);
    
    if rgb_hsv_hs < 4 % RGB, HSV, HS
        X(numbins+1 : numbins*2) =   histcounts(R(:,:,2), listedges);
    end

    if rgb_hsv_hs < 3 % RGB, HSV
        X(numbins*2+1 : numbins*3) = histcounts(R(:,:,3), listedges);
    end
    
    X(:) = X(:)/max(X(:));
end

function h = getHeuristic(X_train, X, k)

    [idx,d] = knnsearch(X_train, X, 'K', k);
    h = mean(d);
    
end

function h = predict(X_train, Y_trian, X, k)

    [idx,d] = knnsearch(X_train, X, 'K', k);
    aux = Y_train(idx);
    h = mode(aux);
    
end
