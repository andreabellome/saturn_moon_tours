function kep = EphSS_kep(n,t)

% EphSS_kep.m - Ephemerides of the solar system in Keplerian parameters.
%
% PROTOTYPE:
%   kep = EphSS_kep(n,t)
%
% DESCRIPTION:
%  Uses uplanet for planets, moon_eph for the Moon, and NeoEphemeris for
%  asteroid ephemerides. Outputs the keplerian elements of the body,
%  centered in the Sun for all the bodies but the Moon (Earth-centered).
%
% INPUT:
%   n[1]        ID of the body:
%                   1 to 9: Planets
%                   11: Moon
%                   >=12: NEOs
%   t[1]        Time [d, MJD2000]. That is:
%               modified Julian day since 01/01/2000, 12:00 noon
%               (MJD2000 = MJD-51544.5)
%
% OUTPUT:
%   kep[1,6]    Keplerian elements of the body (Sun-centered for all bodies,
%               Earth-centered for the Moon).
%               kep = [a e i Om om theta] [km, rad]
%
% CALLED FUNCTIONS:
%   uplanet, ephMoon, ephNEO, car2kep, astroConstants
%
% AUTHOR:
%	Nicolas Croisard 03/05/2008, MATLAB, EphSS_kep.m
%
% PREVIOUS VERSION:
%   Nicolas Croisard 03/05/2008, MATLAB, EphSS_kep.m
%       - Header and function name in accordance with guidlines.
%
% CHANGELOG:
%   03/05/2008, REVISION, Matteo Ceriotti
%   04/10/2010, Camilla Colombo: Header and function name in accordance
%       with guidlines (also changed name of called functions: ephMoon,
%       ephNEO, kep2car, astroConstants)
%
% ------------------------- - SpaceART Toolbox - --------------------------

if n<11 % uplanet needed
    kep = uplanet(t,n);
elseif n==11 % ephMoon needed
    [r, v] = ephMoon(t); % Returns the cartesian position and velocity
    mu = astroConstants(13); % Gravitational constant of the Earth
    kep = car2kep([r, v],mu); % Transform from cartesian to Keplerian 
else % NeoEphemeris needed
    kep = ephNEO(t,n);
end

return