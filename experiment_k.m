clear
indexs_imatges = 31:36;
numbins = 7;
rgb_hsv_hs = 2; %hsv
plot_ = 0;

parfor k = 1:15
    accuracies(k) = main(k, numbins, rgb_hsv_hs, indexs_imatges, plot_);
    disp("k:");
    disp(k);
    disp("accuracy:");
    disp(accuracies(k));
end

% function printK(k)
%     disp(k);
% end

figure
plot(accuracies);
ylabel("accuracy");
xlabel("k");