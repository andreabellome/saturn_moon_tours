function [rcm, mum, radm, hmin] = uranusMoonsConstants(idMO)

% DESCRIPTION
% This function extracts physical and orbital parameters of main Uranus
% moons.
% 
% INPUT
% - idMO : moon ID (1. Miranda, 2. Ariel, 3. Umbriel, 4. Titania, 5. Oberon)
%
% OUTPUT
% - rcm  : circular orbit radius of the body [km]
% - mum  : gravitational parameter of the body [km3/s2]
% - radm : circular radius of the body [km]
% - hmin : minimum altitude for the flyby [km]
%
% -------------------------------------------------------------------------


CONSTANTS = [[129900 4.3   235.8 25];                                  % Miranda
             [190900 83.5  578.9 25];                                  % Ariel
             [266000 85.1  584.7 25];                                  % Umbriel
             [436300 226.9 788.9 25];                                  % Titania
             [583400 205.3 761.4 25]];                                 % Oberon

rcm  = CONSTANTS(idMO,1); % circular orbital radius of the moon (km)
mum  = CONSTANTS(idMO,2); % mu of the moon (km3/s2)
radm = CONSTANTS(idMO,3); % radius of the moon (km)
hmin = CONSTANTS(idMO,4); % minimum flyby altitude (km)

end