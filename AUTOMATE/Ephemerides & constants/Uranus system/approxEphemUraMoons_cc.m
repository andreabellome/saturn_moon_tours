function [rr, vv, kep] = approxEphemUraMoons_cc(idmoon, t)

% DESCRIPTION
% Approximate ephemerides of Uranus moons, assumed to be in circular
% coplanar orbits around Uranus.
% 
% INPUT
% - idmoon : ID of the moon (see constants.m)
% - t      : epoch at which the ephemerides are computed [MJD2000]
% 
% OUTPUT
% - rr  : 1x3 vector with moon position [km]
% - vv  : 1x3 vector with moon velocity [km]
% - kep : 1x6 vector with keplerian elements (see car2kep.m)
% 
% -------------------------------------------------------------------------


muUranus = planetConstants(7);

tref = date2mjd2000([2000 1 1.5 0 0 0]); % --> reference epoch (MJD2000) - 2000-01-01.5
if idmoon == 1 % --> Miranda
    kep0 = [ 129900 0 0 0 deg2rad(155.6) deg2rad(72.4)];
elseif idmoon == 2 % --> Ariel
    kep0 = [ 190900 0 0 0 deg2rad(83.3) deg2rad(119.8)];
elseif idmoon == 3 % --> Umbriel
    kep0 = [ 266000 0 0 0 deg2rad(157.5) deg2rad(258.3)];
elseif idmoon == 4 % --> Titania
    kep0 = [ 436300 0 0 0 deg2rad(202.0) deg2rad(53.2)];
elseif idmoon == 5 % --> Oberon
    kep0 = [ 583400 0 0 0 deg2rad(182.4) deg2rad(139.7) ];
end

dt = t - tref;
[rr, vv, kep] = FGKepler_dt(kep0, dt*86400, muUranus);

end