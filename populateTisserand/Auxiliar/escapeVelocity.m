function Vesc = escapeVelocity(muPlanet, r)

%% Compute the escape velocity (parabolic orbit)
%
% Input:
% - muPlanet: mu for the planet in [m^3/s²]
% - r : radial distance [m]
%
% Output:
% - Vesc : escape velocity in [m/s]
%
% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%
Vesc = sqrt(2*muPlanet/r);
