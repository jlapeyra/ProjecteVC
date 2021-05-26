clear
validacio_pos = 16:27;
validacio_neg = 1:18;
rgb_hsv_hs = 3;
plot_ = 0;
llindar = 1; %indefinit

k = 9;

parfor numbins = 1:20
    b_accuracies(numbins) = main(k, numbins, rgb_hsv_hs, llindar, validacio_pos, validacio_neg, plot_);
end

figure
plot(b_accuracies);
ylabel("balanced accuracy");
xlabel("numbins");