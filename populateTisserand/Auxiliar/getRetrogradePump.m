function retrogradePump = getRetrogradePump(vInf,vFB)
% Check the existance and compute the value of the pump angle that results
% in 0 tangential velocity with respect to the central body. This pump angle
% then represent the transition between prograde and retrograde orbits with
% respect to the central body.
%
% Input:
% - vInf: vInf velocity of the flyby [m/s]
% - vFB: velocity of the flyby body [m/s]
%
% Output:
% - retrogradePump: pump angle that results in 0 tangential velocity [rad]
%
% Example: generatePumpAnglesList.m
%
% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%

    % Check that a pump angle for which the orbit becomes retrograde exits
    if vInf >= vFB
        % Compute the angle for which the prograde-retrograde transition
        % occurs
        retrogradePump = acos(-vFB/vInf);
    else
        % Such angle do not exist
        retrogradePump = NaN;
    end
end