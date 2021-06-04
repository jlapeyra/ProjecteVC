%clear
indexs_imatges = 27:41;
metode = 2;
k = 5;
plot_ = 0;

for hsv_hs = 2:3
    disp("ESPAI:");
    disp(hsv_hs);
    parfor numbins = 1:25
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

figure
plot(accuracies(2,:));
hold on
plot(accuracies(3,:));
legend('HSV', 'HS');
ylabel("accuracy");
xlabel("numbins");
ylim([0.0 1.0]); 

figure
plot(time(2,:));
hold on
plot(time(3,:));
legend('HSV', 'HS');
ylabel("time (seconds)");
xlabel("numbins");
ylim([0 0.6]); 


% accuracies'
% 
%          0    0.1429    0.1429
%          0    0.4762    0.3524
%          0    0.5714    0.4952
%          0    0.5619    0.5143
%          0    0.6095    0.5905
%          0    0.6571    0.5714
%          0    0.6667    0.6000
%          0    0.6571    0.5524
%          0    0.6381    0.6190
%          0    0.6286    0.6381
%          0    0.6476    0.5810
%          0    0.6571    0.6476
%          0    0.6476    0.6190
%          0    0.6762    0.6381
%          0    0.6476    0.6667
%          0    0.6571    0.6476
%          0    0.6952    0.6762
%          0    0.6190    0.6381
%          0    0.6857    0.6952
%          0    0.6476    0.6476
%          0    0.6476    0.6571
%          0    0.6476    0.6762
%          0    0.6571    0.6667
%          0    0.6571    0.6762
%          0    0.6762    0.6857


% time'
% 
%          0    0.4781    0.4223
%          0    0.4877    0.4352
%          0    0.5045    0.4383
%          0    0.4956    0.4392
%          0    0.4955    0.4430
%          0    0.4954    0.4320
%          0    0.4967    0.4263
%          0    0.4966    0.4252
%          0    0.5000    0.4267
%          0    0.5153    0.4319
%          0    0.5044    0.4353
%          0    0.5048    0.4330
%          0    0.5036    0.4296
%          0    0.5075    0.4303
%          0    0.5110    0.4345
%          0    0.5087    0.4317
%          0    0.5116    0.4325
%          0    0.5039    0.4313
%          0    0.5065    0.4300
%          0    0.5160    0.4304
%          0    0.5129    0.4296
%          0    0.5064    0.4308
%          0    0.5046    0.4358
%          0    0.5056    0.4323
%          0    0.5121    0.4330

