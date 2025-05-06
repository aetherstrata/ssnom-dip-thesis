function filtered = nzfc(image)
% NODC Set the DC component of an image to 0
%   filtered = NODC(image) remove the center pixel of the Fourier transform of this image

    imageTransform = fft2(image);
    
    imageTransform(1,1) = 0;

    filtered = real(ifft2(imageTransform));
end