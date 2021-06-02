clear
indexs_imatges = 16:36;
numbins = 7;
rgb_hsv_hs = 2; %hsv
plot_ = 0;

parfor k = 1:30
    accuracies(k) = main(k, numbins, rgb_hsv_hs, indexs_imatges, plot_)
end

figure
plot(accuracies);
ylabel("maximum balanced accuracy");
xlabel("k");