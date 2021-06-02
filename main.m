% k = nombre de veïns a tenir en compte

% numbins = sombre de bins de l'hisotgrama

% rgb_hsv_hs == 1 : histograma en RGB
% rgb_hsv_hs == 2 : histograma en HSV
% rgb_hsv_hs == 3 : histograma en HS
% rgb_hsv_hs == 4 : histograma en H
% rgb_hsv_hs == 5 : histograma en RGB normalitzat per il-luminació

% indexs_imatges = conjunt d'índexs d'imatges de test/validació 

% plot == 0 : no facis plots
% plot == 1 : fes plots de la matriu de confusió, etc


function accuracy = main(k, numbins, rgb_hsv_hs, indexs_imatges, plot_)
    %%%%%% TRAIN %%%%%%
    num_train = 20;
    train_set = 1:num_train;
    equips = ["acmilan", "barcelona", "chelsea", "juventus", "liverpool", "madrid", "psv"];
    num_equips = 7;
    
    aux = 1;
    finestresBD;
    for j = 1 : num_equips
        for i = 1 : num_train
            num_img = train_set(i);
            I = imread(getFilename(equips(j), num_img));
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
    
    
    %%%%%% GENEREM POSSIBLES FINESTRES PER VALIDACIÓ/TRAIN %%%%%
    
    f = 1;
    for equip_f = 1 : num_equips
        for i_f = 1 : num_train  % recorrem les finestres de train
            finestra = finestresNEW(i_f, :, equip_f) ./ dimensions(i_f, :, equip_f);
            assert(max(finestra) <= 1);
            assert(min(finestra) > 0);
            finestres(f, :) = finestra(:);
            f = f + 1;
        end
    end
%     for i=1:100
%         a1 = rand(); a2 = rand();
%         b1 = rand(); b2 = rand();
%         finestra = [min(a1,a2), min(b1,b2), max(a1,a2), max(b1,b2)];
%         assert(max(finestra) <= 1);
%         assert(min(finestra) > 0);
%         finestres(f, :) = finestra(:);
%         f = f + 1;
%     end
    
    
    
    
    

    %%%%%% VALIDACIÓ / TEST %%%%%%

    aux = 1;
    %loop_time = 0;
    for j = 1 : num_equips
        equip = equips(j);
        class = j;
        
        for i = indexs_imatges % recorrem les imatges de l'equip
            fn = getFilename(equip, i);
            I = imread(fn);
            if rgb_hsv_hs > 1
                I = rgb2hsv(I);
            end
            %tic;
            
            sz = size(I);
            Idimensions = [sz(2), sz(1), sz(2), sz(1)];
            [num_finestres, quatre] = size(finestres);
            for f = 1:num_finestres
                finestra = finestres(f,:) .* Idimensions;
                finestra = ceil(finestra);

                assert(finestra(1) <= finestra(3));
                assert(finestra(2) <= finestra(4));
                assert(min(finestra <= Idimensions) == 1);
                assert(max(1 <= finestra) == 1);

                R = getFinestra(I, finestra);
                assert(not( isempty(R)));
                X = getX_Hist(R, numbins, rgb_hsv_hs);
                [predictions(f), distancia] = predict(X_train, Y_train, X, k);
                
                sz = size(R);
                heuristiques(f) = distancia; %/(sz(1)+sz(2));
                  
            end
            [m,f] = min(heuristiques);
            
            Y_predicted(aux) = predictions(f);
            Y_true(aux) = class; 
            
            
            %%%%mostra la finestra de cada imatge de cada equip
%             finestra = finestres(f,:) .* Idimensions;
%             finestra = ceil(finestra);
%             R = getFinestra(hsv2rgb(I), finestra);
%             figure
%             montage({hsv2rgb(I),R});
            
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
    
    X(1:numbins) = histcounts(R(:,:,1), listedges);
    
    if rgb_hsv_hs < 4 % RGB, HSV, HS
        X(numbins+1 : numbins*2) = histcounts(R(:,:,2), listedges);
    end

    if rgb_hsv_hs < 3 % RGB, HSV
        X(numbins*2+1 : numbins*3) = histcounts(R(:,:,3), listedges);
    end
    
    X(:) = X(:)/max(X(:));
end

function [prediccio, diatancia] = predict(X_train, Y_train, X, k)

    

    [idx,d] = knnsearch(X_train, X, 'K', k);
    equips_propers = Y_train(idx);
    prediccio = mode(equips_propers);
    diatancia = mean(d(equips_propers == prediccio));
        
    
%         [idx,d] = knnsearch(X_train, X, 'K', k);
%         equips_propers = Y_train(idx);
%         puntuacio_equip = zeros(7,1);
%         for i=1:k
%             puntuacio_equip(equips_propers(k)) = puntuacio_equip(equips_propers(k)) + 1.0/(d(k)+0.000001);
%         end
%         [m, prediccio] = max(puntuacio_equip);
%         heuristica = -m;
      
    
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