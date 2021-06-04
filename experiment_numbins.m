clear
indexs_imatges = 27:36;
rgb_hsv_hs = 2;
plot_ = 0;

k = 5;
metode = 2;

for numbins = 1:20
    accuracies(numbins) = main(k, numbins, rgb_hsv_hs, metode, indexs_imatges, plot_);
    disp("numbins:");
    disp(numbins);
    disp("accuracy:");
    disp(accuracies(numbins));
end

figure
plot(accuracies);
ylabel("accuracy");
xlabel("numbins");