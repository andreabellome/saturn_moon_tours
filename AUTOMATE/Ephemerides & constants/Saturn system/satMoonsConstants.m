function [rcm, mum, radm, hmin] = satMoonsConstants(idMO)

% DESCRIPTION
% This function extracts physical and orbital parameters of main Saturn
% moons.
% 
% INPUT
% - idMO : moon ID (0. Mimas, 1. Enceladus, 2. Tethys, 3. Dione, 4. Rhea, 5. Titan)
%
% OUTPUT
% - rcm  : circular orbit radius of the body [km]
% - mum  : gravitational parameter of the body [km3/s2]
% - radm : circular radius of the body [km]
% - hmin : minimum altitude for the flyby [km]
%
% -------------------------------------------------------------------------


if idMO == 0 % --> Mimas


    rcm  = 185539;
    mum  = 3.7506e19*6.67259e-20;
    radm = 198.2;
    hmin = 25;

else

    CONSTANTS = [[237948  7.2094 252.1  25];    % Enceladus
                 [294619  41.209 531.1  50];    % Tethys
                 [377396  73.110 561.4  50];    % Dione
                 [527108  153.94 763.8  50];    % Rhea
                 [1221870 8977.9 2574.7 1600]]; % Titan
    
    rcm  = CONSTANTS(idMO,1); % circular orbital radius of the moon (km)
    mum  = CONSTANTS(idMO,2); % mu of the moon (km3/s2)
    radm = CONSTANTS(idMO,3); % radius of the moon (km)
    hmin = CONSTANTS(idMO,4); % minimum flyby altitude (km)

end

end