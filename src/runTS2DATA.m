for k = 1 : 15
    % Fixed filename string for Windows directories, with proper relative path
    fileName = sprintf('data\\Y%02d.m', k);
    fprintf("Working on %s ...", fileName);
    
    try
        TS2DATA(fileName);
    catch
        warning("Could not process %s : %s", fileName, ME.message);
    end
end

