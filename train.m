finestresBD;

num_train = 26;
train_set = 1:num_train;

it = 1;
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

        X_train(it,:) = getX_Hist(R, numbins, rgb_hsv_hs);
        Y_train(it,:) = j; %equips(j);

        it = it + 1;
    end
end