function [r,v,kep] = EphSS_car_circular_coplanar(n,t, idcentral)

if nargin == 2
    idcentral = 1;
end

% Gravitational constant of the Sun
mu = constants(idcentral, n); % --> gravitational constant of the central body [km3/s2]

% keplerian elements of the planet
kep = uplanet(t,n);
kep(2) = 1e-8; % --> zero eccentricity
kep(3) = 1e-8; % --> zero inclination

% transform from Keplerian to cartesian
car = kep2car(kep,mu);
r   = car(1:3);
v   = car(4:6);

end