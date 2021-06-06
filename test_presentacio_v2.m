clear;
k = 5;
numbins = 19;
rgb_hsv_hs = 3;
metode_tria_finestra = 2;

equips = ["acmilan", "barcelona", "chelsea", "juventus", "liverpool", "madrid", "psv"];
num_equips = 7;
train;

imgPath = 'Imatges_presentacio/'; 
files = dir([imgPath '*.jpg']);
for d = 1:length(files) 
    filename = [imgPath files(d).name]; 
    predir_equip;
    disp([files(d).name ': ' convertStringsToChars(equip)]);
end