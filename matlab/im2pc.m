function pc = im2pc(image, realSize, realHeigth)
    imSize = size(image);

    if ~exist('realSize','var')
        % size is not specified, defaulting to 10 x 10
        realSize = [10 10];
    end

    if ~exist('realHeigth','var')
        % size is not specified, defaulting to 10 x 10
        realHeigth = 1;
    end

    [rowIdx, colIdx] = ndgrid(1:imSize(1), 1:imSize(2));  % Get indices
    result = [rowIdx(:)*realSize(1)/imSize(1), colIdx(:)*realSize(2)/imSize(2), image(:)*realHeigth];  % Flatten everything into Mx3

    pc = pointCloud(result);
end