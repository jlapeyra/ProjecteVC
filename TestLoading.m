imgPath = 'Imatges/barcelona/'; 
dCell = dir([imgPath '*.jpg']); % NOTE: CHANGE FILETYPE AS APPROPRIATE FOR EACH SEQUENCE (.png, *.bmp, or *.jpg)

for d = 1:length(dCell) Seq{d} = imread([imgPath dCell(d).name]); end