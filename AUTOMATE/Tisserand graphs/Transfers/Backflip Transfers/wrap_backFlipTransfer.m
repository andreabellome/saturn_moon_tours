function [ vinf1, alpha1, crank1, vinf2, alpha2, crank2, tof] = ...
            wrap_backFlipTransfer( idcentral, idmoon, initial_epoch, initial_vinf_norm, ...
            revolutions, side, asymptotic_direction, forward )

% DESCRIPTION
% This function computes a backflip transfer for any revolutions>=0.
% 
% - idcentral            : ID of the central body (see also constants.m)
% - idmoon               : ID of the flyby body (see also constants.m)
% - initial_epoch        : epoch of the first encounter [MJD2000]
% - initial_vinf_norm    : v-infinity magnitude at flyby [km/s]
% - body_revolutions     : integer number of body revolutions 
% - sc_revolutions       : integer number of spacecraft revolutions (should
%                          be equal to body_revolutions)
% - side                 : +1 is for ABOVE transfer, -1 is for BELOW
% - asymptotic_direction : 1.INWARD, 8.OUTWARD (only INWARD works?)
% - forward              : +1 is for foward direction (USE ALWAYS +1)
% 
% OUTPUT
% - vinf1  : v-infinity magnitude when leaving the flyby body [km/s]
% - alpha1 : pump angle when leaving the flyby body [rad]
% - crank1 : crank angle when leaving the flyby body [rad]
% - vinf2  : v-infinity magnitude when arriving at the flyby body [km/s]
% - alpha2 : pump angle when arriving at the flyby body [rad]
% - crank2 : crank angle when arriving at the flyby body [rad]
% - tof    : time of flight of the transfer [sec]
%
% -------------------------------------------------------------------------

if nargin == 6
    asymptotic_direction = 1;
    forward = 1;
elseif nargin == 7
    forward = 1;
end

if revolutions == 0
    
    [vinf1, alpha1, crank1, vinf2, alpha2, crank2, tof] = ...
        strict_backflip(idcentral, idmoon, initial_epoch, initial_vinf_norm, side, forward);

else

    [vinf1, alpha1, crank1, vinf2, alpha2, crank2, tof] = ...
        compute_transfer_backflip(idcentral, idmoon, initial_epoch, initial_vinf_norm, ...
        revolutions, revolutions, side, asymptotic_direction, forward);

end

end
