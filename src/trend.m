function [ysta, yT, theta] = trend(y, pMax)
  
    %  Input checking
    
    if(nargin < 1)
        error('Missing time series and polynomial order parameters.');
    end

    if(isempty(y))
        error('Time series set as an empty object.');
    end
    
    if(nargin < 2)
        warning('Missing polynomial order.  Order set to 0 by default.');
        pMax = 0;
    end
    
    if(isempty(pMax))
        warning('Polynomial order is set as empty. Order set to 0 by default.');
        pMax = 0;
    end

    pMax = floor(abs(pMax));

    if(pMax > 3)
        warning('Polynomial order exceds 3. Data may be overffited.');
    end
    
    if(pMax > 10)
        warning('The value of Pmax must be at most 10. Pmax set to 10 by default.')
        pMax = 10;
    end

    y = y(:);
    N = size(y, 1);
    M = N;
    Rn = [];
    rn = [];
   
    for p = 0 : pMax
        Bm = balancingMatrix(M, p);
        [Rn, rn] = recursiveMCMMP(Rn, rn, y, p);
        theta = Bm * inv(Bm * Rn * Bm) * Bm * rn;
    end
   yT = polyval(theta(end : -1 : 1), 1 : N)';
   ysta = y - yT;
   theta(1) = theta(1) + mean(ysta);
   ysta = ysta - mean(ysta);
end