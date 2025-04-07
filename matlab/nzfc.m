function filtered = nzfc(image)
% NZFC Set the DC component of an image to 0
%   filtered = NZFC(image) remove the center pixel of the Fourier transform of this image

    mid = ceil(1 + size(image,1)/2);

    filter = ones(size(image));
    filter(mid,mid) = 0;

    imageTransform = fftshift(fft2(image));
    imageTransform = imageTransform .* filter;

    filtered = real(ifft2(ifftshift(imageTransform)));
end