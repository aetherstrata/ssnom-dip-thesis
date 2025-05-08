function filtered = hpf2d(image, std)
    
    imageSize = size(image);
    
    % Apply replicate padding
    padded = padarray(image, imageSize/2, "replicate");

    % Create and apply high pass filter to padded image
    gaussianFilter = 1 - gaussian2d(2*imageSize, std);
    imageTransform = fftshift(fft2(padded));
    imageTransform = imageTransform .* gaussianFilter;
    
    filtered = real(ifft2(ifftshift(imageTransform)));
    
    % Crop and rescale output image
    region = centerCropWindow2d(size(filtered),imageSize);
    filtered = imcrop(filtered,region);
    filtered = rescale(filtered);
end