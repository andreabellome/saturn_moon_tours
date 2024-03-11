function [alpha, vinf] = raRp2AlphaVinf(ra, rp, pl, idcentral)

% DESCRIPTION :
% on a Tisserand map, this function computes (alpha,vinf) from (ra,rp)
% only valid for elliptical orbits.
%
% INPUT:
% - ra        : apoapsis [km]
% - rp        : periapsis [km]
% - pl        : ID of the flyby body (see constants.m)
% - idcentral : ID of the central body (see constants.m)
%
% OUTPUT
% - alpha : pump angle [rad]
% - vinf  : infinity velocity [km/s]
% 
% -------------------------------------------------------------------------

if nargin == 3
    idcentral = 1;
end

% --> constants
[mu, ~, rPL] = constants(idcentral, pl);

vPL = sqrt(mu/rPL);

a = 0.5.*(ra + rp)./rPL; % non-dimensional semi-major axis
e = (ra - rp)./(ra + rp);

% compute the corresponding vinf
vinf = sqrt(3 - 1./a - sqrt(4.*a.*(1 - e.^2))).*vPL; % dimensional vinf (km/s)

% compute the corresponding alpha
alpha = acos(vPL./(2.*vinf).*(1 - (vinf./vPL).^2 - 1./a));
alpha = wrapToPi(alpha);

if (~isreal(alpha) && abs(imag(alpha))<1e-3) && isreal(vinf)
    alpha = real(alpha);
elseif (~isreal(alpha) && abs(imag(alpha))>1e-3) || (~isreal(vinf) && abs(imag(vinf))>1e-3)
    alpha = [];
    vinf  = [];
end

end
