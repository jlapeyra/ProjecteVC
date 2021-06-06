function X = getX_Hist(R, numbins, rgb_hsv_hs)
    
    if rgb_hsv_hs == 1 % RGB
        listedges = linspace(0, 255, numbins+1);
    else % HSV, HS
        listedges = linspace(0, 1, numbins+1);
    end
    
    X(1:numbins) = histcounts(R(:,:,1), listedges);
    
    if rgb_hsv_hs < 4 % RGB, HSV, HS
        X(numbins+1 : numbins*2) =   histcounts(R(:,:,2), listedges);
    end

    if rgb_hsv_hs < 3 % RGB, HSV
        X(numbins*2+1 : numbins*3) = histcounts(R(:,:,3), listedges);
    end
    
    X(:) = X(:)/max(X(:));
end