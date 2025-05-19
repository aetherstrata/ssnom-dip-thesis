function [data, header] = gsfread(filename)
arguments (Input)
    filename {mustBeFile}
end
arguments (Output)
    data {mustBeFloat}
    header struct
end

    fd = fopen(filename,"rb");
    if fd == -1
        error('Failed to open file: %s', filename);
    end

    % Read all bytes
    try
        raw = fread(fd, inf, 'uint8');
        fclose(fd);
    catch ME
        fclose(fd);
        rethrow(ME);
    end

    % Find first NULL char
    nullIdx = find(raw == 0, 1);
    if isempty(nullIdx)
        error('No NULL byte found in file.');
    end

    % Extract UTF-8 header bytes before NULL
    utf8Bytes = raw(1:nullIdx-1);

    headerChars = native2unicode(utf8Bytes', 'UTF-8');
    headerChars = strsplit(headerChars,'\n');

    % Process lines into dictionary
    header = struct();
    for i = 1:numel(headerChars)
        line = strtrim(headerChars{i});
        if isempty(line) || ~contains(line, '=')
            continue;
        end
        tokens = strsplit(line, '=');  % Split into key and value (limit to 2 parts)
        key = strtrim(tokens{1});
        value = strtrim(tokens{2});
        % Store in struct (convert key to valid field name if needed)
        key = matlab.lang.makeValidName(key);
        header.(key) = value;
    end
    
    %Parse known fields to numbers
    header.XRes = str2double(header.XRes);
    header.YRes = str2double(header.YRes);

    % Compute offset of next 4-byte boundary from start of file
    nextAlignedOffset = ceil(nullIdx / 4) * 4 + 1;

    if nextAlignedOffset > length(raw)
        data = [];
    else
        data = raw(nextAlignedOffset:end);

        numFloats = floor(length(data) / 4);
        data = typecast(uint8(data(1:numFloats * 4)), 'single');
    end

    % Check if reshaping is possible
    if numel(data) ~= header.XRes * header.YRes
        error('The stored data does not correspond to the header metadata.\n  Data length = %d\n  Resolution from header: [%d, %d] = %d', ...
            numel(data), header.YRes, header.XRes, header.YRes * header.XRes);
    end

    data = reshape(data, [header.XRes, header.YRes])';

    % Remove NaNs
    data = fill_nans(data);
end

function filled = fill_nans(original)
    % Replaces NaN values in a matrix with the average of their valid neighbors
    
    filled = original; 
    [rows, cols] = size(original);

    % Define the 8-connected neighbor offsets
    neighborOffsets = [-1 -1; -1 0; -1 1;
                        0 -1;        0 1;
                        1 -1;  1 0;  1 1];

    % Find NaN positions
    [nanRows, nanCols] = find(isnan(original));

    for idx = 1:length(nanRows)
        r = nanRows(idx);
        c = nanCols(idx);

        neighborVals = [];
        for k = 1:size(neighborOffsets, 1)
            rr = r + neighborOffsets(k, 1);
            cc = c + neighborOffsets(k, 2);

            % Check bounds
            if rr >= 1 && rr <= rows && cc >= 1 && cc <= cols
                val = original(rr, cc);
                if ~isnan(val)
                    neighborVals(end+1) = val; %#ok<AGROW>
                end
            end
        end

        % Replace NaN with the mean of neighbors, if any exist
        if ~isempty(neighborVals)
            filled(r, c) = mean(neighborVals);
        else  % Fallback: if no valid neighbors, set to 0
            filled(r, c) = 0; 
        end
    end
end