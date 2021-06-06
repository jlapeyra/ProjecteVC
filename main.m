% k = nombre de veins que knn te en compte

% numbins = sombre de bins de l'hisotgrama

% rgb_hsv_hs == 1 : histograma en RGB
% rgb_hsv_hs == 2 : histograma en HSV
% rgb_hsv_hs == 3 : histograma en HS
% rgb_hsv_hs == 4 : histograma en H

% metode_tria_finestra indica el metode amb que l'algoritme tria la
%                       finestra optima a test/validacio
% metode_tria_finestra == 1 : metode 1
% metode_tria_finestra == 2 : metode 2

% indexs_imatges = conjunt d'indexs d'imatges de test/validacio 

% plot == 0 : no facis plots
% plot == 1 : fes plot de la matriu de confusio, i mostra accuracy

function [accuracy, time] = main(k, numbins, rgb_hsv_hs, metode_tria_finestra, indexs_imatges, plot_)


    %%%%%% ENTRENAMENT %%%%%%
    
    equips = ["acmilan", "barcelona", "chelsea", "juventus", "liverpool", "madrid", "psv"];
    num_equips = 7;
    
    train;
    
    %%%%%% VALIDACIO / TEST %%%%%%

    it = 1;
    loop_time = 0;
    for j = 1 : num_equips        
        
        for i = indexs_imatges % recorrem les imatges de l'equip
            filename = getFilename(equips(j), i);
            tic;
            
            predir_equip;
            
            Y_predicted(it) = idx_equip;
            Y_true(it) = j; 
            
            it=it+1;
            loop_time = loop_time + toc;
        end
    end
    time = loop_time / (it-1);

    encert = (Y_true == Y_predicted);
    accuracy = mean(encert);
    
    if plot_ == 1
        accuracy
        figure
        confusionchart(equips(Y_true), equips(Y_predicted));
        title("Matriu de confusió");
    end
end

