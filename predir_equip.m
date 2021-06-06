
I = imread(filename);
if rgb_hsv_hs > 1
    I = rgb2hsv(I);
end
sz = size(I);
Idimensions = [sz(2), sz(1), sz(2), sz(1)];
f = 1;
for f_num = train_set % recorrem les finestres de train
    for f_equip = 1:num_equips
        finestra = finestresNEW(f_num,:,f_equip) ./ dimensions(f_num,:,f_equip) .* Idimensions;
        R = getFinestra(I, ceil(finestra));
        X = getX_Hist(R, numbins, rgb_hsv_hs);
        [predictions(f), dist(f), diff(f)] = predict(X_train, Y_train, X, k);
        f = f + 1;
    end
end

if metode_tria_finestra == 1
    [m,f] = min(dist);
else
    isnan_diff = isnan(diff);
    if sum(isnan_diff) > 0 % en algun cas knn s'ha trobat amb un sol equip
        predictions = predictions(isnan_diff);
        dist = dist(isnan_diff);
        [m,f] = min(dist);
    else % en tots els casos knn s'ha trobat amb mes d'un equip
        [m,f] = max(diff);
    end
end

idx_equip = predictions(f);
equip = equips(idx_equip);



function [prediccio, dist1, diff] = predict(X_train, Y_train, X, k)

    [idx,d] = knnsearch(X_train, X, 'K', k);
    Y_train = Y_train';
    equips_propers = Y_train(idx);
    prediccio = mode(equips_propers);
    dist1 = mean(d(equips_propers == prediccio));
    
    ep2 = equips_propers(equips_propers ~= prediccio);
    d2 = d(equips_propers ~= prediccio);
    if (isempty(ep2))  % equips_propers esta format per un unic equip
        diff = NaN;
    else % equips_propers esta format per mes d'un equip
        prediccio2 = mode(ep2);
        dist2 = mean(d2(ep2 == prediccio2));
        diff = dist2 - dist1;
    end
end