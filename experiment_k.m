clear
validacio_pos = 16:27;
validacio_neg = 1:18;
numbins = 10;
rgb_hsv_hs = 3;
plot_ = 0;

parfor k = 1:15
    b_accuracies(k) = main(k, numbins, rgb_hsv_hs, validacio_pos, validacio_neg, plot_);
end

figure
plot(b_accuracies);
ylabel("balanced accuracy");
xlabel("k");