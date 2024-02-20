function theta = M2theta(M, e)

% DESCRIPTION
% Conversion from mean anomaly to true anomaly for keplerian orbits. Also
% works for hyperbolic paths. Newton method is used.
% 
% INPUT
% - M : mean anomaly  
% - e : eccentricity 
% 
% OUTPUT
% - theta :true anomaly [rad] 
%
% -------------------------------------------------------------------------


E     = M;
it    = 0;
itmax = 1000;
if e<1
    while abs((M-E + e*sin(E)))>1e-13 && it < itmax
        ddf = (e*cos(E)-1);
        E  = E-(M-E + e*sin(E))/ddf;
        it = it + 1;
    end
    theta = 2*atan2(sqrt(1+e)*sin(E/2), sqrt(1-e)*cos(E/2));    
else
    for i = 1:50
        ddf = (1 - e*cosh(E));
        E  = E-(M + E - e*sinh(E))/ddf;
        theta  = 2*atan(sqrt((1+e)/(e-1))*tanh(E/2));
    end
end

end
