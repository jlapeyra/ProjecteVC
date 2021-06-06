clear;
k = 5;
metode_tria_finestra = 2;
numbins = 19;
rgb_hsv_hs = 3;

equips = ["acmilan", "barcelona", "chelsea", "juventus", "liverpool", "madrid", "psv"];
num_equips = 7;
train;

while 1
    in = input("Numero d'imatge de test (test__.jpg): ", 's');
    filename = ['Imatges_presentacio/test' convertStringsToChars(in) '.jpg'];
    disp(filename);
    predir_equip;
    disp('Prediccio: ');
    disp(['     ' convertStringsToChars(equip)]);
    fprintf('\n')
end
