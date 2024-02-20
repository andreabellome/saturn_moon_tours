function [rp, ra] = En2raRp(E, pl, vinf, idcentral)

% DESCRIPTION : 
% on the Tisserand map, from the energy of the orbit, find the (ra,rp)
% w.r.t. the given planet and infinity velocity.
%
% INPUT :
% E    : energy of the orbit (km2/s2)
% pl   : ID of the planet
% vinf : infinity velocity at the planet (km/s)
%
% OUTPUT :
% rp : periapsis of the orbit (km)
% ra : apoapsis of the orbit (km)
%
% -------------------------------------------------------------------------

if nargin == 3
    idcentral = 1;
end

[mu, ~, rPL] = constants(idcentral, pl);
vPL          = sqrt(mu/rPL);        % --> planet orbtial velocity (km/s)

a    = -mu/(2*E);                        % --> semi-major axis (km)
v    = sqrt(mu*(2/rPL - 1/a));           % --> velocity (km/s)
cosk = (v^2 + vPL^2 - vinf^2)/(2*v*vPL); % --> cosine of the flight path angle
h    = rPL*v*cosk;                       % --> angluar momentum (km2/s)

e    = sqrt(1 - h^2/(mu*a));             % --> eccentricity 
rp   = a*(1 - e);                        % --> periapsis (km)
ra   = a*(1 + e);                        % --> apoapsis (km)

end
