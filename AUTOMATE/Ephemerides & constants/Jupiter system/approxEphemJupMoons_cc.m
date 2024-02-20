function [rr, vv, kep] = approxEphemJupMoons_cc(idmoon, t)

% DO NOT USE FOR MISSION DESIGN BUT JUST FOR DV/TOF ANALYSES

muidcentral = planetConstants(5);

tref = date2mjd2000([2030 1 1 0 0 0]); % --> reference epoch (MJD2000) - 2030-01-01
if idmoon == 1 % --> Io
    kep0 = [ 422029.68714001 0 0 0 0 deg2rad(2.500815419418998E+02) ];
elseif idmoon == 2 % --> Europa
    kep0 = [ 671224.23712681 0 0 0 0 deg2rad(1.932732150115001E+00) ];
elseif idmoon == 3 % --> Ganymede
    kep0 = [ 1070587.4692374 0 0 0 0 deg2rad(3.387029874381438E+02) ];
elseif idmoon == 4 % --> Callisto
    kep0 = [ 1883136.6167305 0 0 0 0 deg2rad(3.130144905250815E+01) ];
end

dt            = t - tref;
[rr, vv, kep] = FGKepler_dt(kep0, dt*86400, muidcentral);

end