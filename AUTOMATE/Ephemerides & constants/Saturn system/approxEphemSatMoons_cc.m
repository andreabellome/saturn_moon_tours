function [rr, vv, kep] = approxEphemSatMoons_cc(idmoon, t)

% DESCRIPTION
% Approximate ephemerides of Saturn moons, assumed to be in circular
% coplanar orbits around Saturn.
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

muidcentral = 37931005.114; % --> gravitational parameter of Saturn

tref = date2mjd2000([2030 1 1 0 0 0]); % --> reference epoch (MJD2000) - 2030-01-01
if idmoon == 1 % --> Enceladus
    kep0 = [ 237948 0 0 0 0 deg2rad(2.500815419418998E+02) ];
elseif idmoon == 2 % --> Thetys
    kep0 = [ 294619 0 0 0 0 deg2rad(1.932732150115001E+00) ];
elseif idmoon == 3 % --> Dione
    kep0 = [ 377396 0 0 0 0 deg2rad(3.387029874381438E+02) ];
elseif idmoon == 4 % --> Rhea
    kep0 = [ 527108 0 0 0 0 deg2rad(3.130144905250815E+01) ];
elseif idmoon == 5 % --> Titan
    kep0 = [ 1221870 0 0 0 0 deg2rad(2.133513863591349E+02) ];
end

dt            = t - tref;
[rr, vv, kep] = FGKepler_dt(kep0, dt*86400, muidcentral);

end
