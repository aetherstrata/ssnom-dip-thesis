function ds = loadImages()
    ds = imageDatastore('../SSNOMBACTER', 'IncludeSubfolders',true, 'LabelSource','none');
end
