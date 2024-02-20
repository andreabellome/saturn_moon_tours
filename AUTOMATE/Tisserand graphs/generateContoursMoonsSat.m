function [rascCONT, rpscCONT, alpha] = generateContoursMoonsSat(pl, vInf, idpl)

% DESCRIPTION
% This function computes the apoapsis-periapsis Tisserand contours (only
% works for elliptical orbits and prograde orbits).
%
% INPUT
% - pl   : ID of the flyby body, depending on the idpl (see
%          centralBody_Planet.m)
% - vInf : infinity velocity at the flyby body [km/s]
% - idpl : ID of the central body (see centralBody_Planet.m)
% 
% OUTPUT
% - rascCONT : 1x100 vector of spacecraft apoapsis [km]
% - rpscCONT : 1x100 vector of spacecraft periapsis [km]
% - alpha    : 1x100 vector of pump angles [rad]
%
% -------------------------------------------------------------------------

% --> pump angle
alpha = deg2rad(linspace(0,180));

rpscCONT = zeros(length(alpha),1);
rascCONT = zeros(length(alpha),1);

for indi = 1:length(alpha)
    [rascCONT(indi,:), rpscCONT(indi,:)] = alphaVinf2raRp(alpha(indi), vInf, pl, idpl);
end

% --> eliminate hyperbolic orbits
idxs           = find(rascCONT < 0);
rascCONT(idxs) = [];
rpscCONT(idxs) = [];
alpha(idxs)    = [];

% --> eliminate retrograde orbits
[~, row] = min(rpscCONT);
rascCONT(row+1:end) = [];
rpscCONT(row+1:end) = [];
alpha(row+1:end)    = [];

end
