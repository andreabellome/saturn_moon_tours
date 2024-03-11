function [tof, a, e, theta] = compute_tof( theta, ecost, ecc_threshold, r1, sc_revolutions, gm, forward )

% DESCRIPTION
% This function computes the time of flight between two points on an orbit
% that are (multiple of) 180 degrees apart.
% 
% INPUT
% - theta          : initial true anomaly [rad]
% - ecost          : eccentricity
% - ecc_threshold  : threshold on eccentricity to circular orbit
% - r1             : initial distance from the central body [km]
% - sc_revolutions : integer number of spacecraft revolutions
% - gm             : gravitational parameter of the central body [km/3/s2]
% - forward        : +1 is for foward direction (USE ALWAYS +1)
% 
% OUTPUT
% - tof   : time of flight [sec]
% - a     : semi-major axis of the transfer orbit [km]
% - e     : eccentricity of the transfer orbit [km]
% - theta : angle spanned [rad]
% 
% -------------------------------------------------------------------------

if abs(ecost) <= ecc_threshold
    e     = abs(theta);
    theta = sign(theta) * (pi/2);
else
    e = ecost / cos(theta);
end

a = r1 * (1 + ecost) / (1 - e^2);

tof = time_of_flight( a, e, gm, theta, theta+pi, sc_revolutions, forward );

end