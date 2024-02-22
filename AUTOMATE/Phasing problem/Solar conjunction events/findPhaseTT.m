function [dphase, phase, rr1, vv1, kep1, rr2, vv2, kep2] = findPhaseTT(tt, pl1, pl2, phaselim)

% DESCRIPTION
% This function computes phase angle between two Solar System planets for
% different epochs.
%
% INPUT
% - tt       : list of epochs [MJD2000] 
% - pl1      : first planet ID (see constants.m)
% - pl2      : second planet ID (see constants.m)
% - phaselim : optional input. Limit on phase angle [rad]. Default is 0.
% 
% OUTPUT
% - dphase : list of differences between the phase and the limit
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

if nargin == 3
    phaselim = 0;
end

% --> find ephemerides and latitude/longitude
rr1   = zeros( length(tt),3 );
vv1   = zeros( length(tt),3 );
kep1  = zeros( length(tt),6 );
rr2   = zeros( length(tt),3 );
vv2   = zeros( length(tt),3 );
kep2  = zeros( length(tt),6 );
phase = zeros( length(tt),1 );
for indtt = 1:length(tt)
    [rr1(indtt,:), vv1(indtt,:), kep1(indtt,:)] = EphSS_car(pl1, tt(indtt));
    [rr2(indtt,:), vv2(indtt,:), kep2(indtt,:)] = EphSS_car(pl2, tt(indtt));
    phase(indtt,:) = acos( dot(rr1(indtt,:), rr2(indtt,:))./(norm(rr1(indtt,:))*norm(rr2(indtt,:))) );
end

dphase = abs( phase - phaselim );

end