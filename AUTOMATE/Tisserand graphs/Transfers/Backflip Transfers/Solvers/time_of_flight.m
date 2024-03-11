function [tof] = time_of_flight( a, e, gm, tan1, tan2, full_revs, forward )

% DESCRIPTION
% This function computes the time of flight between two points on an orbit.
%
% INPUT
% - a         : semi-major axix [km]
% - e         : eccentricity
% - gm        : gravitational parameter of the central body [km/3/s2]
% - tan1      : true anomaly at the beginning [rad]
% - tan2      : true anomaly at the end [rad]
% - full_revs : integer number of revolutions
% - forward   : +1 is for foward direction (USE ALWAYS +1)
% 
% OUTPUT
% - tof : time of flight [sec]
% 
% -------------------------------------------------------------------------

if nargin == 6
    forward = 1;
elseif nargin == 7
    if isempty(forward)
        forward = 1;
    end
end

M2 = theta2M(tan2, e);
M1 = theta2M(tan1, e);
dm = wrapTo2Pi(M2-M1);

orbital_period = 2*pi*sqrt( a^3/gm );

if forward == 1
    tof = (full_revs + dm/(2*pi)) * orbital_period;
else
    tof = -1 * (full_revs + 1 - dm/(2*pi)) * orbital_period;
end

end