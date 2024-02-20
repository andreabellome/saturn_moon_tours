function [rrf, vvf, kep2] = FGKepler_dt(kep1, dt, mu)

% DESCRIPTION
% Kepler propagation of an orbit. This works also for hyperbolic paths.
% 
% INPUT
% - kep1 : 1x6 vector with initial keplerian elements (see car2kep.m)
% - dt   : time of flight [s]
% - mu   : gravitational parameter of the central body [km3/s2]
% 
% OUTPUT
% - rrf  : 1x3 vector of spacecraft position after the propagation [km]
% - vvf  : 1x3 vector of spacecraft velocity after the propagation [km/s]
% - kep2 : 1x6 vector of final keplerian elements after the propagation
%          (see car2kep.m)
%
% -------------------------------------------------------------------------

if kep1(2) < 1
    n = sqrt(mu/kep1(1)^3);
elseif kep1(2) > 1
    n = sqrt(mu/(-kep1(1)^3));
end
M1   = theta2M(kep1(6), kep1(2));
M2   = M1 + n*dt;
th2  = M2theta(M2,kep1(2));

kep2 = [kep1(1) kep1(2) kep1(3) kep1(4) kep1(5) th2];
car2 = kep2car(kep2,mu);

rrf = car2(1:3);
vvf = car2(4:6);

end