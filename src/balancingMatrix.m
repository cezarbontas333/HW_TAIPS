function Bm = balancingMatrix(M, p)
    
    % Input checking

    if(nargin < 1)
        error('Missing balancing factor.')
    end
    
    if(isempty(M))
        error('Balancing factor is empty.')
    end
    
    if(nargin < 2)
        warning('Missing balancing matrix dimension. Size set to 1.');
        p = 0;
    end

    if(isempty(p))
        warning('Balancing matrix dimension set as empty. Size set to 1.')
        p = 0;
    end
    
    % Balancing matrix construction

    p = floor(abs(p));
    bm = zeros(1, p + 1);
    for i = 1 : p + 1
        bm(1, i) = 1/(M^(i - 1) * sqrt(M));
    end
    Bm = diag(bm);
end