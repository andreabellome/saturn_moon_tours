function [ra, rp] = alphaVinf2raRp(alpha, vInf, pl, idcentral)

% DESCRIPTION :
% on a Tisserand plot, this function computes (ra,rp) from (alpha,vinf) 
% only valid for elliptical orbits
% 
% INPUT : 
% alpha : pump angle w.r.t. the current planet (rad)
% vinf  : infinity velocity w.r.t. the current planet (km/s)
% idPL      : ID of the flyby body (see constants.m)
% idcentral : ID of the central body (see constants.m)
%
% OUTPUT :
% ra : apoapsis of the orbit (km)
% rp : periapsis of the orbit (km)
%
% -------------------------------------------------------------------------

if nargin == 3
    idcentral = 1;
end

% --> constants
[mu, ~, rPL] = constants(idcentral, pl);
vPL          = sqrt(mu/rPL); % --> flyby body orbital velocity (km/s)

asc  = 1./(1 - (vInf/vPL).^2 - 2.*(vInf./vPL).*cos(alpha));
esc  = (1 - 1./asc.*(0.5*(3 - 1./asc - (vInf./vPL).^2)).^2).^(1/2);
asc  = rPL.*asc;

rp = asc.*(1 - esc);
ra = asc.*(1 + esc);

end
