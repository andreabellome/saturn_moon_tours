function bendingAngle = bendFromRpAndVInf(vInf,rpFB,muFB)
% Compute the bending angle of the flyby from the v-infinity magnitude and
% the radius of periapsis of the flyby hyperbola.
%
% Reference:
% Fundamentals of Astrodynamics and Applications. David A. Vallado.
% Springer Science & Business Media. 2001. Pg. 959.
%
% Input:
% - vInf: v-infinity magnitude of the flyby [m/s]
% - rpFB: radius of periapsis of the flyby hyperbola [m]
% - muFB: gravitational parameter of the body over which the flyby is
%         performed [m^3/s^2]
%
% Output:
% - bendingAngle: bending angle of the flyby [rad]
%
% Example: maxBendPointsAll.m
%
% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%
    bendingAngle = 2*asin(1./(1 + rpFB.*(vInf.^2)/muFB));
    
end