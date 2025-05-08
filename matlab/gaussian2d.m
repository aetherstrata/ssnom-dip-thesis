function win2d = gaussian2d(imageSize, std)
    win2d = gausswin(imageSize(1),std(1)) * ...
            gausswin(imageSize(2),std(2))';
end