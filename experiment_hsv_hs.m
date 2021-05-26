clear
validacio_pos = 16:27;
validacio_neg = 1:18;
plot_ = 1;

k = 9;
numbins = 7;

disp("HSV:");
%main(k, numbins, 2, validacio_pos, validacio_neg, plot_);

disp("HS:");
%main(k, numbins, 3, validacio_pos, validacio_neg, plot_);

disp("RGB:");
main(k, numbins, 1, validacio_pos, validacio_neg, plot_);

