function [rr, vv, kep] = approxEphemUraMoons_cc(idmoon, t)

% This function computes the state vector & OE of the desired moon of Uranus 
% at a specified epoch using the circular coplanar orbits approximation. 
% The orbital elements for the reference epoch have been taken from the 
% JPL Horizons system.

% Author: A. Bellome
% Last revision: 27/08/2024

%% INPUTS %%
% - idmoon: number indicating which Uranus moon to consider.
%
% - t: Epoch at which moon state vector & Orbital Elements are to be
%      computed, expressed in days past since MJD2000.

%% OUTPUTS %%
% - rr: Moon position vector components  at the desired epoch in [km].
%
% - vv: Moon velocity vector components at the desired epoch in [km/s].
%
%  - kep: 1x6 vector of orbital elements ordered as [a, e, i, Om, om, th],  
%         where th is the true anomaly. Angles in [rad], semi-major axis in [km].

%% CHANGELOG %%
% 27/08/2024, J.C Garcia Mateas: corrected the Orbital Elements for the
%             reference epoch & added function description & comments.

%% FUNCTIONS %%
muUranus = planetConstants(7);

tref = date2mjd2000([2030 1 1 0 0 0]); % --> reference epoch (MJD2000) - 2030-01-01

if idmoon == 1 % --> Miranda
    kep0 = [ 129900 0 0 0 0 deg2rad(2.485736290880579E+02)];
elseif idmoon == 2 % --> Ariel
    kep0 = [ 190900 0 0 0 0 deg2rad(9.801239575718014E+01)];
elseif idmoon == 3 % --> Umbriel
    kep0 = [ 266000 0 0 0 0 deg2rad(2.033032495733215E+02)];
elseif idmoon == 4 % --> Titania
    kep0 = [ 436300 0 0 0 0 deg2rad(2.407449111705677E+02)];
elseif idmoon == 5 % --> Oberon
    kep0 = [ 583400 0 0 0 0 deg2rad(1.447878323624638E+02)];
end

dt = t - tref;
[rr, vv, kep] = FGKepler_dt(kep0, dt*86400, muUranus);

end