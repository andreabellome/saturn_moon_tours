function resList = populateVInfContour(vInf,rpFB,muFB,rEnc,muCB,maxRev,lowerBound,upperBound)
% Populate a v-infinity contour with resonances so that adjacent resonances
% are at pump angle distance of less than the bending angle corresponding
% to a flyby with the provided radius of periapsis of the flyby hyperbola.
% The algorithm chooses the resonances with the lowest times of flight
% (lowest number of gravity-assist body revolutions N).
% 
% The parameter maxRev establish the maximum allowed values for N and M. If
% it is not possible to fully populate the contour with the provided maxRev
% the function will return a warning message but will return anyways the
% best possible distribution of resonances.
%
% It is possible to limit the population of the contour to a given region
% by providing the superior and inferior values of the interval of pump
% angle to be populated, or by providing the lower and upper resonances
% limiting the region of interest.
%
% Input:
% - vInf: vInf velocity of the flyby [m/s]
% - rpFB: radius of periapsis of the flyby hyperbola [m]
% - muFB: gravitational parameter of the gravity-assist body [m^3/s^2]
% - rEnc: radius of encounter [m] (distance from the central body to the
%         flyby body)
% - muCB: gravitational parameter of the central body [m^3/s^2]
% - maxRev: maximum number of revolutions around central body [-]
%
% - varargin{1} = pumpResBounded: flag to set the definition of the region
%                 of interest to pump angle bounded or resonance bounded.
%                 String with possible values:
%                 - 'pumpBounded' (default value)
%                 - 'resBounded'
%
% - varargin{2} = pumpBounds (if pumpBounded) or resBounds (if resBounded):
%
%                 - pumpBounds: interval of pump angles to populate.
%                   Size 1x2 [rad]. Default value: [0 pi]
%
%                 - resBounds: lower (smaller N/M) and upper (higher N/M)
%                   resonances limiting the region of interest.
%                   Size 2x2 [-].
%                   [lower resonance N, lower resonance M;
%                   [upper resonance N, upper resonance M]
%
% Output:
% - resList: obtained list of resonances. Each colum correspond to a
%            resonance. The first colum is the number of revolutions of the
%            gravity-assist body (N) while the second colum is the number
%            of spacecraft revolutions (M) [-].
%
% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%

    % Check if the lower bound is a pump bound or a resonance bound
    if length(lowerBound) == 1
        lowerBoundMode = "pump";
    elseif length(lowerBound) == 2
        lowerBoundMode = "resonance";
    else
        error("Bound dimensions not recognized.")
    end

    % Check if the upper bound is a pump bound or a resonance bound
    if length(upperBound) == 1
        upperBoundMode = "pump";
    elseif length(upperBound) == 2
        upperBoundMode = "resonance";
    else
        error("Bound dimensions not recognized.")
    end

    % Compute maximum bending angle
    maxBendAng = bendFromRpAndVInf(vInf,rpFB,muFB);

    % Get current contour bounds
    pumpContourLimits = generatePumpAnglesList(vInf,rEnc,muCB,2);

    % Get minimum and maximum sma for current vInf level
    smaBounds = smaAndEccFromPump([pumpContourLimits(2) pumpContourLimits(1)],rEnc,muCB,vInf);

    % Get the resonance acting as lower bound for the region of interest
    if lowerBoundMode == "pump"

        % Get the resonance with lowest N that can be reached from the lower
        % pump bound
        lowerResonance = findLimitResonance(maxBendAng,vInf,rEnc,muCB,maxRev,-1,lowerBound);

    elseif lowerBoundMode == "resonance"

        % Get sma for lower bound resonance
        smaResBound = getResonanceSma(lowerBound,rEnc);

        % Check if the lower resonance exists in the contour
        if smaResBound < smaBounds(1)
            lowerResonance = findLimitResonance(maxBendAng,vInf,rEnc,muCB,maxRev,-1,pi);
        else
            lowerResonance = lowerBound;
        end

    end

    % Get the resonance acting as upper bound for the region of interest
    if upperBoundMode == "pump"

        % Get the resonance with lowest N that can be reached from the lower
        % pump bound
        upperResonance = findLimitResonance(maxBendAng,vInf,rEnc,muCB,maxRev,1,upperBound);

    elseif upperBoundMode == "resonance"

        % Get sma for lower bound resonance
        smaResBound = getResonanceSma(upperBound,rEnc);

        % Check if the lower resonance exists in the contour
        if smaResBound > smaBounds(2)
            upperResonance = findLimitResonance(maxBendAng,vInf,rEnc,muCB,maxRev,1,0);
        else
            upperResonance = upperBound;
        end

    end
    
    % Check that both bounds exist
    if any(isnan(lowerResonance) | isnan(upperResonance))
        error('Not possible to fully populate contour.')
    end

    % Check if both resonances are equal (then the graph can be populated
    % with this single resonance) otherwise add the resonances to the list
    if lowerResonance == upperResonance
        resList = lowerResonance;
        return

    % Check that the lower bound is below the upper bound
    elseif getResonanceSma(upperResonance,rEnc) < getResonanceSma(lowerResonance,rEnc)
        error("The upper bound is below the lower bound.")
    else
        resList = [lowerResonance; upperResonance];
    end

    % Start the iterations
    maxIterations = 1e3;
    for i = 1:maxIterations

        % Populate between resonances that are at a distance greater than
        % the maximum bending angle
        newResList = populateBetweenResonances(resList,vInf,rEnc,muCB,maxBendAng,maxRev);

        % Check if the list has not been modified (meaning that the contour
        % is fully populated or no more resonances can be added)
        if size(newResList,1) == size(resList,1)
            break
        end

        % Update the resonance list
        resList = newResList;

    end

    % Check if the maximum number of iterations has been reached
    if i == maxIterations
        warning('Contour is not fully populated, maximum number of iterations reached.')
    end

end




