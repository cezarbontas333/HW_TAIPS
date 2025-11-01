function [Rn, rn] = recursiveMCMMP(Rn_prev, rn_prev, y, p)
    
    % Input checking
    
    if(nargin < 1)
        error('Missing Rn from previous step.')
    end

    if(nargin < 2)
        error('Missing rn from previous step.')
    end
    
    if(nargin < 3)
        erorr('Missing time series.');
    end
    
    if(isempty(y))
        error('Time series parameter is empty.');
    end

    if(nargin < 4)
        warning('Missing matrix and vector size. Size set tot 1.');
        p = 0;
    end

    
    if(isempty(p))
        warning('Size parameter is empty. Size value set to 1.');
        p = 0;
    end

    if((isempty(Rn_prev) || isempty(rn_prev)) && p ~= 0)
        error('Rn size or rn size differ by more than 0');
    end
    
    p = floor(abs(p));
    y = y(:);
    N = size(y, 1);
    p = p + 1;

    Rn = zeros(p, p);
    rn = zeros(p, 1);
    timeInstants = (1 : N)';

    Rn(1 : p - 1, 1 : p - 1) = Rn_prev;
    rn(1 : p - 1, 1) = rn_prev;
    
    % Recursive construction of Rn and rn (without repeating the prev calc)
    
    if(p ~= 1)
        for i = 1 : p
            Rn(i, p) = 1 / N * sum(timeInstants.^(p + i - 2));
            Rn(p, i) = Rn(i, p);
        end
        rn(p, 1) = 1 / N * sum(timeInstants.^(p - 1) .* y);
    else
        Rn = 1;
        rn = 1 / N * sum(y);
    end
end