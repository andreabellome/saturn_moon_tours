function [E] = raRp2En(ra, rp, idcentral)

% DESCRIPTION :
% on a Tisserand map, from (ra,rp) find the energy of the orbit.
%
% INPUT
% - ra : apoapsis [km]
% - rp : periapsis [km]
% - idcentral : ID of the central body (see constants.m)
%
% OUTPUT
% - E : energy of the orbit [km2/s2]
% 
% -------------------------------------------------------------------------

if nargin == 2
    idcentral = 1;
end

mu = constants(idcentral, 1);
a  = 0.5*(ra + rp);
E  = -mu/(2*a);

end