function [sma,ecc] = smaAndEccFromPump(pumpAngles,rEnc,muCB,vInf)
% Compute the semi-major axis and eccentricty of the spacecraft's orbit
% with respect to the central body based on the pump angle of the flyby.
% These expressions assume a circular orbit of the flyby body coplanar with
% the spacecraft's orbit.
%
% Reference
% Analytical Methods for Gravity-Assist Tour Design. Nathan Strange. 2016.
% PhD Thesis pg.23-24, Purdue University.
%
% Input:
% - pumpAngles: pump angle [rad] with size [N, 1]
% - rEnc: radius of encounter [m] (distance from the central body to the
%         flyby body)
% - muCB: gravitational parameter of the central body [m^3/s^2]
% - vInf: vInf velocity of the flyby [m/s]
%
% Output:
% - sma: semi-major axis [m] with size [N, 1]
% - ecc: eccentricity [-] with size [N, 1]
%
% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%
    % Flyby body orbital velocity
    vFB = circularVelocity(muCB,rEnc);

    % Compute semi-major axis
    sma = rEnc./(1 - vInf*(vInf/vFB + 2*cos(pumpAngles))/vFB);
    
    %Compute eccentricity
    ecc = sqrt(1 - rEnc*((3 - (vInf/vFB)^2 - (rEnc./sma)).^2)./sma/4);

end