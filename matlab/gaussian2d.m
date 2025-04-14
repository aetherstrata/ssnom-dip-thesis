function win2d = gaussian2d(imageSize, realSize, filterSize)
    win2d = gausswin(imageSize(1),realSize(1)/filterSize(1)) * ...
            gausswin(imageSize(2),realSize(2)/filterSize(2))';
end