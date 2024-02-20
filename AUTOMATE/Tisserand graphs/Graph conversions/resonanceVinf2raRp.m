function [ra, rp, alpha, vinf, asc, Tsc] = resonanceVinf2raRp(N, M, vinf, idcentral, idpl)

% DESCRIPTION
% On a Tisserand plot, this function computes (ra,rp) and (alpha,vinf)
% coordinates from a give N:M resonance for a given moon (only valid for
% elliptical orbits)
%
% INPUT
% - N    : integer number of flyby body revolutions 
% - M    : integer number of spacecraft body revolutions
% - vinf : infinity velocity at the flyby body [km/s]
% - idcentral : ID of the central body (see constants.m)
% - idpl      : ID of the flyby body (see constants.m)
%
% OUTPUT
% - ra    : spacecraft apoapsis of the resonant orbit [km]
% - rp    : spacecraft periapsis of the resonant orbit [km]
% - alpha : pump angle at the flyby body on the resonant orbit [rad]
% - vinf  : infinity velocity at the flyby body [km/s]
% - asc   : spacecraft semi-major axis of the resonant orbit [km]
% - Tsc   : spacecraft period of the resonant orbit [s]
%
% -------------------------------------------------------------------------

% --> constants
[mu, ~, rPL] = constants(idcentral, idpl);

vPL = sqrt(mu/rPL);
tPL = 2*pi*sqrt(rPL^3/mu);

Tsc = N/M*tPL; % find the N:M resonance
asc = (mu*(Tsc/(2*pi))^2)^(1/3)/rPL; % SC semi-major axis (non-dimensional)

% compute the corresponding alpha
alpha = acos(vPL/(2*vinf)*(1 - (vinf/vPL)^2 - 1/asc));
if isreal(alpha)
    alpha    = wrapToPi(alpha);
    [ra, rp] = alphaVinf2raRp(alpha, vinf, idpl, idcentral);
else
    % no resonance available for the given vinf
    alpha = NaN;
    ra    = NaN; 
    rp    = NaN;
end

end
