function [rcm, mum, radm, hmin] = jupMoonsConstants(idMO)

% DESCRIPTION
% This function extracts physical and orbital parameters of main Juoiter
% moons.
% 
% INPUT
% - idMO : moon ID (1. Io, 2. Europa, 3. Ganimede, 4. Callisto)
%
% OUTPUT
% - rcm  : circular orbit radius of the body [km]
% - mum  : gravitational parameter of the body [km3/s2]
% - radm : circular radius of the body [km]
% - hmin : minimum altitude for the flyby [km]
%
% -------------------------------------------------------------------------

CONSTANTS = [[422029.68714001 5959.916 1826.5 50];      % --> Io
             [671224.23712681 3202.739 1561.0 50];      % --> Europa
             [1070587.4692374 9887.834 2634.0 50];      % --> Ganimede
             [1883136.6167305 7179.289 2408.0 50]];     % --> Callisto

rcm  = CONSTANTS(idMO,1); % --> circular orbital radius of the moon (km)
mum  = CONSTANTS(idMO,2); % --> mu of the moon (km3/s2)
radm = CONSTANTS(idMO,3); % --> radius of the moon (km)
hmin = CONSTANTS(idMO,4); % --> minimum flyby altitude (km)

% rcm  = [421.6e3 670.9e3 1.07e6 1.883e6]; % moon distance -> Io, Europa, Ganimede and Callisto respectevely [km]
% radm =[3642/2 3120/2 5268/2 4800/2]; %radius of the moons: Io, Europa, Ganimede and Callisto in km
% % mu_jup = 1.899*10^27 * 6.6743 * 10^(-20); %Jupiter gravitational constant [km^3/s^2]
% mum = [8.93*10^22,  4.80*10^22, 1.48*10^23 ,1.08*10^23];
% % m_jup = 1.90 * 10^27;
% 
% rcm  = rcm(idMO);
% radm = radm(idMO);
% mum  = mum(idMO);

end

