function trimmed = noborder(image, borderSize)
% NOBORDER Remove the border of an image
%   trimmed = NOBORDER(image) removes the border of the image

    if ~exist('borderSize','var')
        % size is not specified, default to 1
        borderSize = 1;
    end

    imSize = size(image);
    trimmed = image(1+borderSize:imSize(1)-borderSize, 1+borderSize:imSize(2)-borderSize);
end
