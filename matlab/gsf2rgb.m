function RGB = gsf2rgb(r, g, b)
    if (size(r) ~= size(g) || size(r) ~= size(b))
        error("All data matrices must have the same size")
    end
    RGB(:,:,1) = rescale(r);
    RGB(:,:,2) = rescale(g);
    RGB(:,:,3) = rescale(b);
end