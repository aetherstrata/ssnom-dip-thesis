function ds = getSubset(store, imageType, species)
    if ~isa(store, "matlab.io.datastore.ImageDatastore")
        error('store must be an image datastore')
    end

    match = true(size(store.Files));

    if exist('species','var')
        if isa(species, "char")
            species = string(species);
        end
        matchSubdir = false(size(store.Files));
        for i=1:numel(species)
            matchSubdir = matchSubdir | contains(store.Files, species(i));
        end
        match = match & matchSubdir;
    end

    if exist('imageType','var') & isa(imageType, 'string')
        endings = [];
        if isa(imageType, "char")
            imageType = string(imageType);
        end

        if strcmp(imageType, 'topography') % AFM topography
            endings = [endings "Z.tiff" "Z C.tiff"];
        end

        if strcmp(imageType, 'topographyError') % AFM topography error
            endings = [endings "M0A.tiff" "M1A.tiff" "M2A.tiff" "M3A.tiff" "M4A.tiff" "M5A.tiff"];
        end

        if strcmp(imageType, 'topographyPhase') % AFM topography phase
            endings = [endings "M0P.tiff" "M1P.tiff" "M2P.tiff" "M3P.tiff" "M4P.tiff" "M5P.tiff"];
        end

        if strcmp(imageType, 'snomAmplitude') % s-SNOM amplitude
            endings = [endings "O0A.tiff" "O1A.tiff" "O2A.tiff" "O3A.tiff" "O4A.tiff" "O5A.tiff"];
        end

        if strcmp(imageType, 'snomPhase') % s-SNOM phase
            endings = [endings "O0P.tiff" "O1P.tiff" "O2P.tiff" "O3P.tiff" "O4P.tiff" "O5P.tiff"];
        end

        matchEnding = false(size(store.Files));
        for i = 1:numel(endings)
            matchEnding = matchEnding | endsWith(store.Files, endings(i));
        end
        match = match & matchEnding;
    end

    files = store.Files(match);
    ds = imageDatastore(files);
end
