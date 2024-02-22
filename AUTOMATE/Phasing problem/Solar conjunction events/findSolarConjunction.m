function [P, phase, rr1, vv1, kep1, rr2, vv2, kep2] = findSolarConjunction(tt, pl1, pl2, phaselim)

% DESCRIPTION
% This function is a wrapper for 'findPhaseTT.m' and computes at which
% epoch the phase between two planets is below the limit.
%
% INPUT
% - tt       : list of epochs [MJD2000] 
% - pl1      : first planet ID (see constants.m)
% - pl2      : second planet ID (see constants.m)
% - phaselim : limit on phase angle [rad]
%
% OUTPUT
% - P      : 1x2 vector with P(1) equal to epoch [MJD2000] at which the
%            phase is equal to the limit and P(2) equal to the phase limit
%            [rad] 
% - phase  : list of phases between the two planets at specified epochs 
% - rr1    : Nx3 matrix with position vector of first planet at epochs [km]
% - vv1    : Nx3 matrix with velocity vector of first planet at epochs [km]
% - kep1   : Nx6 matrix with keplerian elements of first planet at epochs
%            (see kep2car.m)
% - rr2    : Nx3 matrix with position vector of second planet at epochs [km]
% - vv2    : Nx3 matrix with velocity vector of second planet at epochs [km]
% - kep2   : Nx6 matrix with keplerian elements of first planet at epochs
%            (see kep2car.m) 
% 
% -------------------------------------------------------------------------
 
% --> compute the phasing for the list of planets
[~, phase, rr1, vv1, kep1, rr2, vv2, kep2] = findPhaseTT(tt, pl1, pl2, phaselim);
phaselimcurve                              = phaselim.*ones( 1, length(tt) );

% --> find solar conjunction
P = InterX([tt; phase'], [tt; phaselimcurve]);

end