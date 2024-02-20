function [rrf, vvf, kep2] = FGCar_dt(rr1, vv1, dt, mu)

% DESCRIPTION
% Keplerian propagation of Kepler propagation of an orbit. This works also
% for hyperbolic paths. Compared to FGKepler_dt.m, this takes in input the
% state of the spacecraft and not the keplerian elements.
%
% INPUT
% - rr1 : 1x3 vector of spacecraft position before the propagation [km]
% - vv1 : 1x3 vector of spacecraft velocity before the propagation [km/s]
% - dt  : time of flight [s]
% - mu  : gravitational parameter of the central body [km3/s2]
% 
% OUTPUT
% - rrf  : 1x3 vector of spacecraft position after the propagation [km]
% - vvf  : 1x3 vector of spacecraft velocity after the propagation [km/s]
% - kep2 : 1x6 vector of final keplerian elements after the propagation
%          (see car2kep.m)
%
% -------------------------------------------------------------------------

kep = car2kep( [rr1, vv1], mu );
[rrf, vvf, kep2] = FGKepler_dt(kep, dt, mu);

end