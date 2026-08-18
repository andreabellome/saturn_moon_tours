function lastRes = findLimitResonance(maxBendAng,vInf,rEnc,muCB,maxRev,searchDirection,varargin)
% Given a v-infinity contour, find the resonance with lowest time of flight
% (lowest N) that allows to reach the provided superior or inferior pump
% angle bound.
% 
% If the search direction is set to 1 the algorithm searches towards 0°
% pump, the resonance with lowest N, pump angle greater than the provided
% pump bound, and at a pump angle distance of this bound lower than the
% provided maximum bending angle.
%
% If the search direction is set to -1 the algorithm searches towards 180°
% pump, the resonance with lowest N, pump angle smaller than the provided
% pump bound, and at a pump angle distance of this bound lower than the
% provided maximum bending angle.
%
% The parameter maxRev establish the maximum allowed values for N and M. If
% it is not possible to satisfy all the described conditions with the
% provided maxRev, the function will return a warning message and will
% return the resonance that satify the first two conditions and its the
% closest one to satisfying the maximum bending angle condition.
%
% Input:
% - maxBendAng: maximum bending angle [rad]
% - vInf: vInf velocity of the flyby [m/s]
% - rEnc: radius of encounter [m] (distance from the central body to the
%         flyby body)
% - muCB: gravitational parameter of the central body [m^3/s^2]
% - maxRev: maximum number of revolutions around central body [-]
% - searchDirection: if set to 1 the algorithm will search towards the
%                    inferior limit of pump angle. If set to -1 it will
%                    serach towards the superior limit [-].
% - varargin{1} = pumpBound: bound on pump angle [rad]. Default value: 0 if
%                 searchDirection is set to 1 and pi if searcDirection set
%                 to -1.
%
% Output:
% - lastRes: resonance satisfying the described conditions [-].
%            Size 1x2 [N M].
%
% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%

    % Default value
    default.inferiorPumpBound = 0;
    default.superiorPumpBound = pi;

    % Treat optional parameter
    if nargin > 6
        pumpBound = varargin{1};
    else
        if searchDirection == 1
            pumpBound = default.inferiorPumpBound;
        else
            pumpBound = default.superiorPumpBound;
        end
    end

    % Obtain the pump angle bounds that do not result in escape or
    % retrograde orbit
    %pumpContourLimits = generatePumpAnglesList(vInf,rEnc,muCB,2);

    % Compute velocity of gravity-assist body (assumes circular orbit)
    vFB = circularVelocity(muCB,rEnc);
    
    if searchDirection == 1 % Search resonances towards 0° pump

        % Get maximum sma value corresponding to the pump angle bound value
        smaMax = smaAndEccFromPump(pumpBound,rEnc,muCB,vInf);
        
        % Start by geting the first non-available N:1 resonance
        M = 1;
        for N = 1:maxRev
    
            % Get sma for the current resonance
            smaRes = getResonanceSma([N M],rEnc);
    
            % Check if it is greater than the maximum achievable sma
            if smaRes > smaMax
                % Get the first non-available resonance
                firstNonAvRes = [N M];

                % Get the last available resonance
                lastAvRes = [N-1 M];
                break
            end

            % Check if the maximum number of revolutions is achieved
            if N == maxRev
                % Get the first non-available resonance
                firstNonAvRes = [N+1 M];

                % Get the last available resonance
                lastAvRes = [N M];
            end
    
        end
    
        stopIterations = false;
        while ~stopIterations
    
            % Compute the corresponding pump angle
            resPump = getResonancePump(lastAvRes(1),lastAvRes(2),vInf,rEnc,vFB,muCB);
    
            % Check if current resonance is within reach
            if resPump < maxBendAng + pumpBound
                lastRes = lastAvRes;
                stopIterations = true;
            else
                % Find intermediate resonance
                interRes = findIntermediateResonance(lastAvRes,firstNonAvRes,maxRev);

                % Check if there is still revolutions to check
                if isnan(interRes)
                    warning('Not possible to find an available resonance with current number of maximum revolutions.')
                    lastRes = lastAvRes;
                    stopIterations = true;
                end
    
                % Compute the corresponding sma
                smaRes = getResonanceSma(interRes,rEnc);
    
                % Is this resonance available
                if smaRes <= smaMax
                    lastAvRes = interRes;
                else
                    firstNonAvRes = interRes;
                end
            end
    
        end
    
    elseif searchDirection == -1 % Search resonances towards 180° pump

        % Get minimum sma value corresponding to the pump angle bound value
        smaMin = smaAndEccFromPump(pumpBound,rEnc,muCB,vInf);
        
        % Start by geting the first non-available 1:M resonance
        N = 1;
        for M = 1:maxRev
    
            % Get sma for the current resonance
            smaRes = getResonanceSma([N M],rEnc);
    
            % Check if it is smaller than the minimum achievable sma
            if smaRes < smaMin
                % Get the first non-available resonance
                firstNonAvRes = [N M];

                % Get the last available resonance
                lastAvRes = [N M-1];
                break
            end

            % Check if the maximum number of revolutions is achieved
            if M == maxRev
                % Get the first non-available resonance
                firstNonAvRes = [N M+1];

                % Get the last available resonance
                lastAvRes = [N M];
            end
    
        end
    
        stopIterations = false;
        while ~stopIterations
    
            % Compute the corresponding pump angle
            resPump = getResonancePump(lastAvRes(1),lastAvRes(2),vInf,rEnc,vFB,muCB);
    
            % Check if current resonance is within reach
            if resPump > pumpBound - maxBendAng
                lastRes = lastAvRes;
                stopIterations = true;
            else
                % Find intermediate resonance
                interRes = findIntermediateResonance(lastAvRes,firstNonAvRes,maxRev);

                % Check if there is still revolutions to check
                if isnan(interRes)
                    warning('Not possible to find an available resonance with current number of maximum revolutions.')
                    lastRes = lastAvRes;
                    stopIterations = true;
                end
    
                % Compute the corresponding sma
                smaRes = getResonanceSma(interRes,rEnc);
    
                % Is this resonance available
                if smaRes >= smaMin
                    lastAvRes = interRes;
                else
                    firstNonAvRes = interRes;
                end
            end
    
        end
    
    end


end