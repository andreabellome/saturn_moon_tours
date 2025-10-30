function pumpAngles = generatePumpAnglesList(vInf,rEnc,muCB,nPoints,varargin)
% Generate the list of pump angles for which the resulting orbit is neither
% an escape trajectory nor a retrograde orbit. If an interval for which
% these conditions are satisfied is found, the function creates a list of
% equidistant values along the interval.
% 
% Additionally, the function provides an optional parameter "includeEsc".
% When this option is activated, the function considers pump angles that do
% not result in retrograde orbits, however it will include those that
% result in prograde escape trajectories.
%
%
% Input:
% - vInf: vInf velocity of the flyby [m/s]
% - rEnc: radius of encounter [m] (distance from the central body to the
%         flyby body)
% - muCB: gravitational parameter of the central body [m^3/s^2]
% - nPoints: number of pump angles in the list [-]
% - varargin{1} = includeEsc: do or do not include pump angles resulting in
%                 prograde escape trajectories. Possible values:
%                 - "notIncludeEsc" (default value)
%                 - "includeEsc"
%
% Output:
% - pumpAngles: list of pump angles that satisfy the described conditions
%               [rad]
%
% Example: vInfCurve.m
%
% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%
    % Default values
    default.includeEsc = "notIncludeEsc";

    % Treat the optional parameter
    if nargin > 4
        includeEsc = varargin{1};

        % Check entry
        if ~ismember(includeEsc,["notIncludeEsc","includeEsc"])
            error("The includeEsc input variable must be chosen among: notIncludeEsc or includeEsc")
        end
    else
        includeEsc = default.includeEsc;
    end

    % Get circular velocity
    vFB = circularVelocity(muCB,rEnc);

    % Get escape velocity
    Vesc = escapeVelocity(muCB, rEnc);

    % Get escape pump angle if escape trajectories are not desired
    if includeEsc == "notIncludeEsc"
        escapePump = getEscapePump(vInf,vFB,Vesc);
    else
        escapePump = NaN;
    end

    % Get retrograde pump
    retrogradePump = getRetrogradePump(vInf,vFB);

    % Define the starting and end points of the pump angles list
    if ~isnan(escapePump)
        pumpStartPoint = escapePump + escapePump / 100;
    elseif includeEsc == "notIncludeEsc" && vInf - vFB > Vesc
        % All the orbits are escape trajectories
        pumpStartPoint = NaN;
    else
        pumpStartPoint = 0;
    end
    if ~isnan(retrogradePump)
        pumpEndPoint = retrogradePump - retrogradePump / 100;
    else
        pumpEndPoint = pi;
    end

    % Check that the limits on the angles are in the correct order
    if ~isnan(pumpStartPoint) && pumpStartPoint <= pumpEndPoint
        % Create pump angles list
        pumpAngles = linspace(pumpStartPoint, pumpEndPoint, nPoints);
    else
        % Pump angles satisfying the desired conditions do not exist
        pumpAngles = NaN;
    end

end