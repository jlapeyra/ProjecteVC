function R = getFinestra(I, finestra)
    R = I(finestra(2):finestra(4), finestra(1):finestra(3), :);
end