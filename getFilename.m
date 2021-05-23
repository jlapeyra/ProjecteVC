function filename = getFilename(team, num_img)
    n_str = num2str(num_img);
    if num_img < 10
        n_str = ['0', n_str];
    end
    filename = ['Imatges/', team, '/', n_str, '.jpg'];
end