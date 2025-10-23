function [rcm, mum, radm, hmin] = altairaSystemConstants(idPlanet)

% DESCRIPTION
% This function extracts physical and orbital parameters of the major
% planets in the Altaira system.
% 
% INPUT
% - idPlanet : planet ID --> Same index as in problem data
% (1. Vulcan, 2. Yavin, 3. Eden, 4. Hoth, 5. Beyonce, 6. Bespin, 7. Jotunn
% 8. Wakonyingo, 9. Rogue1, 10. PlanetX)
%
% OUTPUT
% - rcm  : circular orbit radius of the body [km]
% - mum  : gravitational parameter of the body [km3/s2]
% - radm : circular radius of the body [km]
% - hmin : minimum altitude for the flyby [km]
%
% -------------------------------------------------------------------------

    % --> Minimum altitude of flyby in radii of the planet
    minHFlyby = 0.1;

    CONSTANTS = [
    [1.3811982942000E+07	6.5890637332000E+08	1.3302070000000E+05	minHFlyby*1.3302070000000E+05] % Vulcan
    [1.2852822996800E+08	6.3630374840000E+06	1.8013200000000E+04	minHFlyby*1.8013200000000E+04] % Yavin
    [1.7951744484000E+08	4.4385355900000E+05	6.6974000000000E+03	minHFlyby*6.6974000000000E+03] % Eden
    [4.3962700191100E+08	2.8444170800000E+05	5.4988000000000E+03	minHFlyby*5.4988000000000E+03] % Hoth
    [1.1191057672180E+09	4.9322760294000E+07	6.3476200000000E+04	minHFlyby*6.3476200000000E+04] % Beyonce
    [2.1385641733850E+09	1.2037712589500E+08	6.3661400000000E+04	minHFlyby*6.3661400000000E+04] % Bespin
    [2.6223188857630E+09	6.3418162560000E+06	2.3865300000000E+04	minHFlyby*2.3865300000000E+04] % Jotunn
    [5.1154991885870E+09	6.5984333910000E+06	1.3531400000000E+04	minHFlyby*1.3531400000000E+04] % Wakonyingo
    [1.0048973262572E+10	6.6346648135000E+07	1.0947120000000E+05	minHFlyby*1.0947120000000E+05] % Rogue1
    [1.5955016885357E+10	3.4119123970000E+06	1.2993800000000E+04	minHFlyby*1.2993800000000E+04]]; % PlanetX
    
    rcm  = CONSTANTS(idPlanet,1); % circular orbital radius of the moon (km)
    mum  = CONSTANTS(idPlanet,2); % mu of the moon (km3/s2)
    radm = CONSTANTS(idPlanet,3); % radius of the moon (km)
    hmin = CONSTANTS(idPlanet,4); % minimum flyby altitude (km)

    
end