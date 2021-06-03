clear
indexs_imatges = 27:36;
numbins = 7;
%metode_tria_finestra = 2;
rgb_hsv_hs = 2; %hsv
plot_ = 0;

for metode = 1:2
    disp("METODE:");
    disp(metode);
    parfor k = 1:15
        accuracies(metode,k) = main(k, numbins, rgb_hsv_hs, metode, indexs_imatges, plot_);
        disp("k:");
        disp(k);
        disp("accuracy:");
        disp(accuracies(metode,k));
    end
    disp("")
end


figure
plot(accuracies(1,:));
hold on
plot(accuracies(2,:));
legend('Mètode 1', 'Mètode 2');
ylabel("accuracy");
xlabel("k");