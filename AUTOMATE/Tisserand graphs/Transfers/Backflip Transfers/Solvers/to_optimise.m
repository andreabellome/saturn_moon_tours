function dtof = to_optimise( theta, target_tof, ecost, ecc_threshold, r1, sc_revolutions, gm, forward )

% DESCRIPTION
% Cost function used to find the time of flight for a backflip transfer.
% 
% INPUT
% - theta          : initial true anomaly [rad]
% - target_tof     : target time of flight to match [sec]
% - ecost          : eccentricity
% - ecc_threshold  : threshold on eccentricity to circular orbit
% - r1             : initial distance from the central body [km]
% - sc_revolutions : integer number of spacecraft revolutions
% - gm             : gravitational parameter of the central body [km/3/s2]
% - forward        : +1 is for foward direction (USE ALWAYS +1)
% 
% OUTPUT
% - dtof : cost function, i.e., residual between time of flight and target
%          one [sec]
%
% -------------------------------------------------------------------------

tof  = compute_tof( theta, ecost, ecc_threshold, r1, sc_revolutions, gm, forward );
dtof = tof - target_tof;

end