function [vinf1, alpha1, crank1, vinf2, alpha2, crank2, tof] = ...
    strict_backflip(idcentral, idmoon, initial_epoch, initial_vinf_norm, side, forward)

% DESCRIPTION
% This function computes a backflip transfer that has revolutions<1.
% 
% INPUT
% - idcentral            : ID of the central body (see also constants.m)
% - idmoon               : ID of the flyby body (see also constants.m)
% - initial_epoch        : epoch at first encounter [MJD2000]
% - initial_vinf_norm    : v-infinity magnitude at flyby [km/s]
% - side                 : +1 is for ABOVE transfer, -1 is for BELOW
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


if nargin == 5
    forward = 1;
end

gm = constants(idcentral, idmoon);
[rr1ga, vv1ga, kep_fb] = approxEphem_CC(idmoon, initial_epoch, idcentral);
cart_fb_init = [rr1ga, vv1ga];

kep2ga         = kep_fb;
kep2ga(end)    = wrapToPi(wrapTo2Pi( kep2ga(end) + pi ));

cart_fb_target = kep2car( kep2ga, gm );

flyby_body_orbital_period = 2*pi*sqrt( kep_fb(1)^3/gm );
target_epoch              = initial_epoch + (forward * flyby_body_orbital_period / 2)/86400;

initial_vinf = adjust_vinf( gm, kep_fb(1), cart_fb_init, cart_fb_init(4:6), initial_vinf_norm, 8, side );
target_vinf = adjust_vinf( gm, kep_fb(1), cart_fb_target, cart_fb_target(4:6), initial_vinf_norm, 1, side );

if isnan(initial_vinf.vinf) || isnan(target_vinf.vinf)
    vinf1  = NaN;
    alpha1 = NaN;
    crank1 = NaN;
    vinf2  = NaN;
    alpha2 = NaN;
    crank2 = NaN;
    tof    = NaN;
    return
else
    vinf1  = initial_vinf.vinf;
    alpha1 = initial_vinf.alpha;
    crank1 = initial_vinf.crank;
    vinf2  = target_vinf.vinf;
    alpha2 = target_vinf.alpha;
    crank2 = target_vinf.crank;
    tof    = (target_epoch - initial_epoch)*86400;
end

end
