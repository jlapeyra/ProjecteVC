clear
indexs_imatges = 21:30;
numbins = 7;
rgb_hsv_hs = 3; %hs
plot_ = 0;

parfor k = 1:5
    accuracies(k) = main(k, numbins, rgb_hsv_hs, indexs_imatges, plot_);
    disp(k);
end

figure
plot(accuracies);
ylabel("maximum accuracy");
xlabel("k");