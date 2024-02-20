function [rascCONT, rpscCONT] = tisserandTrajectory_SS(idMO, vinf1,...
    rp1, ra1, rp2, ra2, idcentral)

% DESCRIPTION
% This function computes contours in Tisserand map in terms of apoapsis and
% periapsis given a flyby body, an infinity velocity, and initial and final
% periapsis and apoapsis.
% 
% INPUT
% - idMO      : ID of the flyby body (see also constants.m)
% - vinf1     : infinity velocity of the flyby [km/s]
% - rp1       : initial periapsis [km]
% - ra1       : initial apoapsis [km]
% - rp2       : final periapsis [km]
% - ra2       : final apoapsis [km]
% - idcentral : ID of the central body (see also constants.m)
% 
% OUTPUT
% - rascCONT : locus of apoapsis from ra1 to ra2 [km]
% - rpscCONT : locus of periapsis from rp1 to rp2 [km]
% 
% -------------------------------------------------------------------------

if nargin == 6
    idcentral = 1;
end

% --> constants
[mu, ~, rPL] = constants(idcentral, idMO);
vPL = sqrt(mu/rPL);                  % --> planet orbital velocity (km/s)

% --> from (ra,rp) to (alpha,vinf)
[alpha1] = raRp2AlphaVinf(ra1, rp1, idMO, idcentral);
[alpha1] = checkZeroAlphas(alpha1);
[alpha2] = raRp2AlphaVinf(ra2, rp2, idMO, idcentral);
[alpha2] = checkZeroAlphas(alpha2);

if alpha2 > alpha1

    % --> you are going down on the Tisserand map
    alphaMin = alpha1;
    alphaMax = alpha2;
    alpha    = linspace(alphaMin,alphaMax); 
    rpscCONT = zeros(length(alpha),1);
    rascCONT = zeros(length(alpha),1);
    for indi = 1:length(alpha)
        [rascCONT(indi,:), rpscCONT(indi,:)] = ...
            alphaVinf2raRp(alpha(indi), vinf1, idMO, idcentral);
    end
    
else

    % --> you are going up on the Tisserand map
    alphaMin = alpha1;
    alphaMax = alpha2;
    alpha    = linspace(alphaMin,alphaMax); 
    rpscCONT = zeros(length(alpha),1);
    rascCONT = zeros(length(alpha),1);
    for indi = 1:length(alpha)
        [rascCONT(indi,:), rpscCONT(indi,:)] = ...
            SCorbit(alpha(indi), vinf1, vPL, rPL);
    end

end

end
