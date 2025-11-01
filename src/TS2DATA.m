%
%   File TS2DATA.M
%
%   Function: TS2DATA
%
%   Synopsis: DATA = TS2DATA(fileName)
%
%   Creates an IDDATA object from a time series defined
%   inside a .M data file.
%
%   The .M file must define the following variables:
%       y      - measured data vector
%       Ts     - sampling period (scalar or NaN for nonuniform)
%       unit   - string describing the time unit (e.g. 'Time [months]')
%       ntime  - time instants (vector, required if Ts = NaN)
%       label  - description / experiment name
%       yunit  - measurement unit (e.g. 'Monthly rate [%]')
%
%   The function automatically creates an IDDATA object,
%   adds auxiliary information, and saves it into a .MAT file
%   with the same base name (e.g. Y01.mat).
%
%   Example:
%       DATA = TS2DATA('Y01.m');
%
%   Author:   Andrei DUMITRU
%   Created:  23.10.2025


function DATA = TS2DATA(fileName)

%
% Messages
% ~~~~~~~~
    BL = [blanks(3), '* Insert '];
    FN = '<TS2DATA>: ';
    E1 = [FN 'requires the name of a .M file, e.g TS2DATA(''Y01.m'').'];
    E2 = [FN 'The file you mentioned could not be found in the current folder.'];
    I1 = [BL 'the starting date in format <dd-mm-yyyy HH:MM:SS (ENTER = NOW): '];
    I2 = [BL 'the output signal name (ENTER = default): '];
    I3 = ['\n' BL 'the correct time unit type'];
    I4 = [BL 'the time format description: '];
    E3 = [blanks(3) 'Time unit information could not be extracted' ...
                     '\n   The stored data contained the following info: '];
    I4 = ['\n' BL 'the correct time unit type '];
%
% Faults preventing
% ~~~~~~~~~~~~~~~~~
    if(nargin < 1)
        war_err(E1);
        return;
    end
    
    if ~isfile(fileName)
        war_err(E2);
        return; 
    end
%
% Building the DATA object
% ~~~~~~~~~~~~~~~~~~~~~~~~

    fprintf('\n--- Running %s ---\n\n', fileName);

    run(fileName);
    
    DATA = iddata;
    DATA.Name = label;
    DATA.y = y(:);
    DATA.ExperimentName = label;

    if isnan(Ts)
        DATA.SamplingInstants = ntime(:);
        Data.Ts = [];
    else
        DATA.Ts = Ts;
        StartDate = input(I1, 's');
        if isempty(StartDate)
            DATA.Tstart = datenum(datetime('now'));
        else
            DATA.Tstart = datenum(StartDate);
        end
    end

    try
        timeUnit = sscanf(unit, 'Time[%s');
        DATA.TimeUnit = timeUnit(1:end-1);
        DATA.Notes = '';
    catch
        fprintf(E3, unit);
        DATA.TimeUnit = input(I4, 's');
        DATA.Notes = input(I4, 's');
    end

    OutputName = input(I2, 's');
    if ~isempty(OutputName)
        DATA.OutputName = OutputName;
    else
        DATA.OutputName = label;
    end
    DATA.OutputUnit = yunit;

    % Get both next level path and keep file name
    [relativePath, baseName, ~] = fileparts(fileName);
    outFile = [relativePath + "\\" + baseName + '.mat'];
    save(outFile, 'DATA');

    fprintf('\nFile %s has been successfully created and saved.\n', outFile);
end