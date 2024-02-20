function [rr, vv, kep] = approxEphem_CC(idmoon, t, idcentral)

% DESCRIPTION
% Approximate circular-coplanar ephemerides for different systems (e.g.,
% Solar System planets, Juputer moons,...)
%
% INPUT
% - idmoon : ID of the flyby body (see constants.m)
% - t : epoch [MJD2000]
% - idcentral : ID of the central body (see constants.m)
%
% OUTPUT
% - rr  : 1x3 position vector of flyby body at epoch [km] 
% - vv  : 1x3 velocity vector of flyby body at epoch [km/s] 
% - kep : 1x6 keplerian elements of the flyby body at epoch (see car2kep.m)
%
% -------------------------------------------------------------------------

if idcentral == 1 % --> SS planets

elseif idcentral == 5 % --> Jupiter moons
    [rr, vv, kep] = approxEphemJupMoons_cc(idmoon, t);
elseif idcentral == 6 % --> Saturn moons
    [rr, vv, kep] = approxEphemSatMoons_cc(idmoon, t);
elseif idcentral == 7 % --> Uranus moons
    [rr, vv, kep] = approxEphemUraMoons_cc(idmoon, t);
end

end