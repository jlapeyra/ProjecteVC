function plotHistRGB(R, listedges, filename)
    h(:,1) = histcounts(R(:,:,1), listedges);
    figure
    plot(h(:,1), 'r');
    hold on
    h(:,2) = histcounts(R(:,:,2), listedges);
    plot(h(:,2), 'g');
    hold on
    h(:,3) = histcounts(R(:,:,3), listedges);
    plot(h(:,3), 'b');
    title(['histograma RGB de', filename]);
    legend('R', 'G', 'B');
end