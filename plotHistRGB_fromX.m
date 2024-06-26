function plotHistRGB_fromX(X, numbins, filename)
    figure
    plot(X(1, 1:numbins), 'r');
    hold on
    plot(X(1, numbins+1 : numbins*2), 'g');
    hold on
    plot(X(1, numbins*2 +1 : numbins*3), 'b');
    title(['histograma RGB de la imatge ', filename]);
    legend('R', 'G', 'B');
end