function [r,v] = EphSS_car(n,t)

% EphSS_car.m - Ephemerides of the solar system.
%
% PROTOTYPE:
%	[r, v] = PROTYPE:(n,t)
%
% DESCRIPTION:
%   It uses uplanet for planets, moon_eph for the Moon, and NeoEphemeris
%   for asteroid ephemerides. Outputs cartesian position and velocity of
%   the body, centered in the Sun for all the bodies but the Moon (for
%   which a cartesian Earth-centered reference frame is chosen).
%
% INPUT:
%   n[1]	ID of the body:
%               1 to 9: Planets
%               11: Moon
%               >=12: NEOs
%   t[1]    Time [d, MJD2000]. That is:
%           modified Julian day since 01/01/2000, 12:00 noon
%           (MJD2000 = MJD-51544.5)
%
% OUTPUT:
%   r[1,3]  Cartesian position of the body (Sun-centered for all bodies,
%           Earth-centered for the Moon).
%   v[1,3]  Cartesian velocity.
%
% CALLED FUNCTIONS:
%   uplanet, ephMoon, ephNEO, kep2car, astroConstants
%
% ORIGINAL VERSION:
%   Massimilaino Vasile, 2002, MATLAB, EphSSfun.m
%
% AUTHOR:  
%   Matteo Ceriotti, 10/01/2007, MATLAB, EphSS_car.m
%
% PREVIOUS VERSION:
%   Matteo Ceriotti, 10/01/2007, MATLAB, EphSS.m
%       - Header and function name in accordance with guidlines.
%

if n<11 % uplanet needed
    kep = uplanet(t,n);
elseif n==11 % ephMoon needed
    [r, v] = ephMoon(t); % Returns the cartesian position and velocity
else % NeoEphemeris needed
    kep = ephNEO(t,n);
end

if n~=11 % Planet or asteroid, Sun-centered
    % Gravitational constant of the Sun
    mu = astroConstants(4); % 132724487690 copied here for speed
    
    % transform from Keplerian to cartesian
    car = kep2car(kep,mu);
    r   = car(1:3);
    v   = car(4:6);
end

return