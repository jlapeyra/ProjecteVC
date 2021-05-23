function plotHistHSV_fromX(X, numbins, filename)
    figure
    plot(X(1, 1:numbins), 'r');
    hold on
    plot(X(1, numbins+1 : numbins*2), 'g');
    hold on
    title(['histograma HSV de la imatge ', filename]);
    legend('H', 'S');
end