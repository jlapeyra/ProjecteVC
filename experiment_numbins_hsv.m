%clear
indexs_imatges = 27:41;
metode = 2;
k = 5;
plot_ = 0;

for hsv_hs = 2:3
    disp("ESPAI:");
    disp(hsv_hs);
    parfor numbins = 18:25
        [accuracies(hsv_hs,numbins), time(hsv_hs,numbins)] = main(k, numbins, hsv_hs, metode, indexs_imatges, plot_);
        disp("numbins:");
        disp(numbins);
        disp("accuracy:");
        disp(accuracies(hsv_hs,numbins));
        disp("time:");
        disp(time(hsv_hs,numbins));
        disp("")
    end
    disp("")
end

%nb_min = 2;
%nb_max = 20;

figure
plot(accuracies(2,:));
hold on
plot(accuracies(3,:));
legend('HSV', 'HS');
ylabel("accuracy");
xlabel("numbins");
%xlim([nb_min nb_max]); 

figure
plot(time(2,:));
hold on
plot(time(3,:));
legend('HSV', 'HS');
ylabel("time (seconds)");
xlabel("numbins");
%xlim([nb_min nb_max]);