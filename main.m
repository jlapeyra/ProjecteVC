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

function accuracy = main(k, numbins, rgb_hsv_hs, indexs_imatges, plot_)
    %%%%%% TRAIN %%%%%%
    num_train = 15;
    train_set = 1:num_train;
    equips = ["acmilan", "barcelona", "chelsea", "juventus", "liverpool", "madrid", "psv"];
    num_equips = 7;
    
    aux = 1;
    finestresBD;
    for j = 1 : num_equips
        for i = 1 : num_train
            num_img = train_set(i);
            I = imread(getFilename(convertStringsToChars(equips(j)), num_img));
            if rgb_hsv_hs > 1
                I = rgb2hsv(I);
            end

            R = getFinestra(I, finestresNEW(num_img,:,j));

           % figure
           % imshow(R);
            
            X_train(aux,:) = getX_Hist(R, numbins, rgb_hsv_hs);
            Y_train(aux,:) = j; %equips(j);
            
            aux = aux + 1;
        end
    end
    

    %%%%%% VALIDACIÓ / TEST %%%%%%

    aux = 1;
    %loop_time = 0;
    for j = 1 : num_equips
        equip = equips(j);
        class = j;
        
        for i = indexs_imatges % recorrem les imatges de l'equip
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
                [predictions(f), distances(f)] = predict(X_train, Y_train, X, k);
            end
            [m,f] = min(distances);
            
            Y_predicted(aux) = predictions(f);
            Y_true(aux) = class; 
            
            
            %%%%mostra la finestra de cada imatge de cada equip
            %finestra = finestres(f,:) ./ dimensions(f,:) .* Idimensions;
            %R = getFinestra(I, ceil(finestra));
            %figure
            %imshow(R);

            %scores(j) = - min(heuristic);     
            %labels(j) = class;
            
            aux=aux+1;
            %loop_time = loop_time + toc;
        end
    end

    
    %real = labels == "b";
    
%     aux = equips;
%     prediccio = aux(1+prediccio);
%     real = aux(1+real);

    encert = (Y_true == Y_predicted);
    accuracy = mean(encert);
    
    
    if plot_ == 1
        accuracy
        figure
        M = confusionchart(Y_true, Y_predicted);
        title("Matriu de confusió");
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

function [prediccio, distancia] = predict(X_train, Y_train, X, k)

    [idx,d] = knnsearch(X_train, X, 'K', k);
    equips_propers = Y_train(idx);
    prediccio = mode(equips_propers);
    distancia = mean(d(equips_propers == prediccio));
    
end




    %loop_time % Mostra el temps utilitzat per a pendre decisions
%     [FPR, TPR, threshold, area] = perfcurve(labels, scores, 'b');
%     if plot_ == 1
%         %area
%         figure
%         plot(FPR, TPR)
%         ylabel("True Positive Rate");
%         xlabel("False Positive Rate");
%         title("Corba ROC");
%         disp(strcat("Area sota la corba = ", num2str(area)));
%     end
% 
%     if llindar > 0
%         TNR = 1 - FPR;
%         balanced_accuracy = (TNR + TPR)/2;
%         if plot_ == 1
%             figure
%             plot(threshold, balanced_accuracy)
%             ylabel("Balanced accuracy");
%             xlabel("Threshold");
%             title("Balanced accuracy");
%         end
% 
%         [max_ba, idx] = max(balanced_accuracy);
%         llindar = threshold(idx);
%     end
%     prediccio = scores > llindar;