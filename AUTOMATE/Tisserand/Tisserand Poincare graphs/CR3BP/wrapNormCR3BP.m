function strucNorm = wrapNormCR3BP(idcentral, idplPert)

% DESCRIPTION
% This function computes all the relevant variables for the CR3BP problem,
% given a primary (central body) and a secondary (flyby body).
%
% INPUT
% - idcentral : ID of the central body (see constants.m)
% - idplPert  : ID of the flyby body (see constants.m)
% 
% OUTPUT
% - strucNorm : structure with the following fields
%               - strucNorm.G        : universal gravity constant
%               - strucNorm.normMu   : normalized gravitational constant of
%               the CR3BP 
%               - strucNorm.normDist : distance of the flyby body from the
%               central body [km]
%               - strucNorm.normTime : time normalization CR3BP [sec]
%               - strucNorm.normVel  : time normalization CR3BP [km/s]
%               - strucNorm.x1       : position of the primary in
%               normalized units
%               - strucNorm.x2       : position of the secondary in
%               normalized units
%               - strucNorm.mass1    : mass of the primary [kg]
%               - strucNorm.mass2    : mass of the secondary [kg]
%               - strucNorm.mu1      : normalized gravitational constant of
%               the primary
%               - strucNorm.mu2      : normalized gravitational constant
%               of the secondary
%               - strucNorm.LagrangePoints : 5x3 matrix with coordinates of
%               Lagrange points in normalized units (L1, L2, L3, L4, L5)
%
% -------------------------------------------------------------------------

% --> constants
G = 6.67259e-20; % --> universal gravity constant

% --> info on central body and perturbative body
if idcentral == 1 && idplPert == 3
    % --> consider both Earth and Moon when computing the CR3BP
    [muSun, ~, smaTitan, ~, ~, PTitan]  = constants(idcentral, idplPert);
    [muEarth, muMoon] = constants(30, 0);

    muSaturn   = muSun;
    massSaturn = muSun/G;
    massTitan  = muEarth/G + muMoon/G;
    muTitan    = muEarth + muMoon;
    mu         = (massTitan)/(massTitan+massSaturn); 

else
    [muSaturn, muTitan, smaTitan, ~, ~, PTitan] = ...
        constants(idcentral, idplPert);
    massSaturn = muSaturn/G;
    massTitan  = muTitan/G;
    mu         = (massTitan)/(massTitan+massSaturn); 
end

x1        = -mu;
x2        = 1 - mu;

% --> normalization
normDist  = smaTitan;          % --> distance between the primary and secondary
normTime  = PTitan/2/pi;
normVel   = normDist/normTime; 

% --> save the normalization for CR3BP
strucNorm.idcentral = idcentral;
strucNorm.idplPert  = idplPert;

strucNorm.G        = G;
strucNorm.normMu   = mu;
strucNorm.normDist = normDist;
strucNorm.normTime = normTime;
strucNorm.normVel  = normVel;
strucNorm.x1       = x1; % --> primary
strucNorm.x2       = x2; % --> secondary

strucNorm.mass1    = massSaturn;
strucNorm.mass2    = massTitan;
strucNorm.mu1      = muSaturn;
strucNorm.mu2      = muTitan;

% --> find libration point
[L1, L2, L3, L4, L5] = librationPoints(strucNorm.normMu);

strucNorm.LagrangePoints = [ L1; L2; L3; L4; L5 ];

end
