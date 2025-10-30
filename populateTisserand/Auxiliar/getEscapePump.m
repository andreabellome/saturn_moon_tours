function escapePump = getEscapePump(vInf,vFB,Vesc)
% Check the existance and compute the value of the pump angle that results
% in a parabolic escape trajectory with respect to the central body.
%
% Input:
% - vInf: vInf velocity of the flyby [m/s]
% - vFB: velocity of the flyby body [m/s]
% - Vesc: escape velocity with respect to the central body [m/s]
%
% Output:
% - escapePump: pump angle that results in a parabolic trajectory [rad]
%
% Example: generatePumpAnglesList.m
%
% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%
    % Check if a pump angle for which the orbit becomes a parabolic
    % trajectory exits
    n = (Vesc^2 - vInf^2 - vFB^2);
    d = 2*vInf*vFB;
    if abs(n) <= abs(d)
        % Compute escape pump angle
        escapePump = acos(n/d);
    else
        % Such angle does not exist
        escapePump = NaN;
    end

end