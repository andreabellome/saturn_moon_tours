function [vinf1, alpha1, crank1, vinf2, alpha2, crank2, tof] = ...
    compute_transfer_backflip(idcentral, idmoon, epoch, initial_vinf_norm, ...
    body_revolutions, sc_revolutions, side, asymptotic_direction, forward)

% DESCRIPTION
% This function computes back-flip transfers for revolutions>0. This is a
% MATLAB implementation of ESA's MIDAS software, encoded in Python. This
% can be found at:
% https://midas.io.esa.int/midas/api_reference/generated/midas.design.reso.html#module-midas.design.reso
% 
% INPUT
% - idcentral            : ID of the central body (see also constants.m)
% - idmoon               : ID of the flyby body (see also constants.m)
% - epoch                : epoch of the first encounter [MJD2000]
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

if nargin == 7
    asymptotic_direction = 1;
    forward              = 1;
elseif nargin == 8
    forward = 1;
end

muCentral = constants(idcentral, idmoon);
[rr1ga, vv1ga, kep1ga] = approxEphem_CC(idmoon, epoch, idcentral);

a    = kep1ga(1);
e    = kep1ga(2);
tan1 = wrapToPi(kep1ga(end));
tan2 = kep1ga(end)+pi;

target_tof = time_of_flight( a, e, muCentral, tan1, tan2, body_revolutions, forward );

kep2ga         = kep1ga;
kep2ga(end)    = wrapToPi(wrapTo2Pi( kep2ga(end) + pi ));
car2           = kep2car(kep2ga, muCentral);
rrga2          = car2(1:3);
vvga2          = car2(4:6);

r1    = norm( rr1ga );
r2    = norm( rrga2 );
ecost = (r2 - r1) / (r2 + r1);

if ~( (-1 <= ecost) && ( ecost<= 1 ))
    vinf1  = NaN;
    alpha1 = NaN;
    crank1 = NaN;
    vinf2  = NaN;
    alpha2 = NaN;
    crank2 = NaN;
    tof    = NaN;
    return
end

ecc_threshold = 5e-5;

gamma = acos(ecost);
eps = 1e-6;

left_bounds = [eps - gamma, eps];
right_bounds = [eps, gamma - eps];

if ecost < 0
    left_bounds  = [gamma + eps, pi - eps];
    right_bounds = [pi + eps, 2*pi - gamma - eps];
end

if abs(ecost) <= ecc_threshold
    left_bounds  = [0, 1 - eps];
    right_bounds = [0, 0];
end

if asymptotic_direction == 1 % --> INWARD
    bounds = left_bounds;
elseif asymptotic_direction == 8 % --> OUTWARD
    bounds = right_bounds;
end

fun = @(x) to_optimise( x, target_tof, ecost, ecc_threshold, r1, sc_revolutions, muCentral, forward );
if sign(fun(bounds(1))) ~= sign(fun(bounds(2)))
    result = fzero(fun, [bounds(1), bounds(2)]);
else
    vinf1  = NaN;
    alpha1 = NaN;
    crank1 = NaN;
    vinf2  = NaN;
    alpha2 = NaN;
    crank2 = NaN;
    tof    = NaN;
    return
end

[tof, a, e, theta] = compute_tof( result, ecost, ecc_threshold, r1, sc_revolutions, muCentral, forward );

aop                = kep1ga(5) + wrapToPi(kep1ga(6)) - theta;

kep_sc_init_planar  = [a, e, kep1ga(3), kep1ga(4), aop, theta];
cart_sc_init_planar = kep2car( kep_sc_init_planar, muCentral );

if forward == 1
    initial_heading = 8; 
else
    initial_heading = 1;
end

% --> extract pump and crank angles for the given v-infinity
vinfStruc = adjust_vinf( muCentral, a, [rr1ga, vv1ga], cart_sc_init_planar(4:6), initial_vinf_norm, initial_heading, side );

if isnan(vinfStruc.vinf)
    vinf1  = NaN;
    alpha1 = NaN;
    crank1 = NaN;
    vinf2  = NaN;
    alpha2 = NaN;
    crank2 = NaN;
    tof    = NaN;
    return
else
    vinf1  = vinfStruc.vinf;
    alpha1 = vinfStruc.alpha;
    crank1 = vinfStruc.crank;
    
    [~, rr1, vv1, ~] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank1, epoch, idmoon, idcentral);
    
    kep1     = car2kep([rr1, vv1], muCentral);
    [~, vvf] = FGKepler_dt(kep1, tof, muCentral);
    
    [~, vvga2, ~] = approxEphem_CC(idmoon, epoch+tof/86400, idcentral);
    vvinf2        = vvf - vvga2;
    [vinf2, alpha2, crank2] = VinfCART_to_vinfAlphaCrank(vvinf2, epoch+tof/86400, idmoon, idcentral);
    
end

end
