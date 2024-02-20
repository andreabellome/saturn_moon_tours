function M = theta2M(theta, e)

% DESCRIPTION
% Conversion from true anomaly to mean anomaly for keplerian orbits. Also
% works for hyperbolic paths.
% 
% INPUT
% - theta : true anomaly [rad]
% - e     : eccentricity 
% 
% OUTPUT
% - M : mean anomaly 
%
% -------------------------------------------------------------------------

if e < 1
    E = 2*atan(sqrt((1-e)/(1+e))*tan(theta/2));
    M = E - e*sin(E);
elseif e > 1
    E = 2*atanh(sqrt((e-1)/(e+1))*tan(theta/2));
    M = e*sinh(E) - E;
end

end