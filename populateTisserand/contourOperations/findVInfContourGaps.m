function gaps = findVInfContourGaps(vInf,rpFB,muFB,rEnc,muCB,resList,lowerBound,upperBound)
% Given a resonances list and a Tisserand graph contour, check for adjacent
% resonances whose pump angle difference is greater than the maximum
% bending angle (gaps). This bending angle is defined through the minimum
% radius of periapsis of the flyby hyperbola and the v-infinity magnitude
% of the Tisserand graph contour.
%
% It is possible to bound the region of interest to check for gaps only in
% some region of the contour. This region can be defined through a pump
% angle interval or by specifying two resonances that act as lower and
% upper bounds of the region. It is possible to combine both modes and
% define a pump angle as lower bound and a resonance as upper bound or
% viceversa.
%
% Input:
% - vInf: vInf magnitude of the contour [m/s]
% - rpFB: minimum radius of periapsis of the flyby hyperbola [m]
% - muFB: gravitational parameter of the gravity-assist body [m^3/s^2]
% - rEnc: radius of encounter [m] (distance from the central body to the
%         gravity-assist body)
% - muCB: gravitational parameter of the central body [m^3/s^2]
% - resList: resonances list. Each colum correspond to a resonance. The
%            first colum is the number of revolutions of the gravity-assist
%            body (N) while the second colum is the number of spacecraft
%            revolutions (M) [-].
%
% - lowerBound: lower bound of the region of interest. Can be defined as
%               pump angle or as a resonance:
%               - Pump angle definition: scalar value [rad]
%               - Resonance definition: size 1x2 [-]. Structure [N M].
%
% - upperBound: upper bound of the region of interest. Can be defined as
%               pump angle or as a resonance:
%               - Pump angle definition: scalar value [rad]
%               - Resonance definition: size 1x2 [-]. Structure [N M].
%
% Note: the lower and upper bounds are defined such that the lower bound
% correspond to the orbit with lower energy. Therefore, if defined as pump
% angles, the value of the lower bound must be greater than the upper bound
% (as greater pump angle means lower orbital energy).
%
% Output:
% - gaps: list of identified gaps (adjacent distances at distance greater
%         than the maximum bending angle). 4-columns matrix in which each
%         row corresponds to an identified gap.
%         Each row is read as follows, the two first columns correspond to
%         one of the adjacent resonances in which the gap is identified.
%         The last two columns correspond to the other adjacent resonances.
%         Therefore, if a gap is identified between adjacent resonaces 3:4
%         and 5:6, the corresponding line will read: [3 4 5 6].
%         The bounds are identified through the reserved values [0 0].
%         Therefore, if a line reads [0 0 3 4], it means that the function
%         has identified a gap between the provided lower bound and the
%         resonance 3:4.
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

    % Compute velocity of gravity-assist body (assumes circular orbit)
    vFB = circularVelocity(muCB,rEnc);

    % Obtain the pump angle bounds that do not result in escape or
    % retrograde orbit
    pumpContourLimits = generatePumpAnglesList(vInf,rEnc,muCB,2);

    % Get minimum and maximum sma for current vInf level
    smaBounds = smaAndEccFromPump([pumpContourLimits(2) pumpContourLimits(1)],rEnc,muCB,vInf);

    % Get the pump angle acting as lower bound for the region of interest
    if lowerBoundMode == "pump"

        pumpBounds(2) = lowerBound;

    elseif lowerBoundMode == "resonance"

        % Get sma for lower bound resonance
        smaResBound = getResonanceSma(lowerBound,rEnc);

        % Check if the lower resonance exists in the contour
        if smaResBound < smaBounds(1)
            pumpBounds(2) = pi;
        else
            pumpBounds(2) = getResonancePump(lowerBound(1),lowerBound(2),vInf,rEnc,vFB,muCB);
        end

    end

    % Get the pump angle acting as upper bound for the region of interest
    if upperBoundMode == "pump"

        pumpBounds(1) = upperBound;

    elseif upperBoundMode == "resonance"

        % Get sma for lower bound resonance
        smaResBound = getResonanceSma(upperBound,rEnc);

        % Check if the lower resonance exists in the contour
        if smaResBound > smaBounds(2)
            pumpBounds(1) = 0;
        else
            pumpBounds(1) = getResonancePump(upperBound(1),upperBound(2),vInf,rEnc,vFB,muCB);
        end

    end

    % Sort and format the resonances list
    resList = unique(resList,'rows');
    resList = sortResonances(resList);

    % Number of resonances in the list
    nRes = size(resList,1);

    % Get resonances pump angles
    pumpRes = zeros(nRes,1);
    for i = 1:nRes
        pumpRes(i) = getResonancePump(resList(i,1),resList(i,2),vInf,rEnc,vFB,muCB);
    end

    % Strip all resonances that are not within pump bounds
    resToKeep = (pumpRes >= pumpBounds(1)) & (pumpRes <= pumpBounds(2));
    filteredResList = resList(resToKeep,:);
    filteredPumpRes = pumpRes(resToKeep);

    % Update number of resonances
    nRes = size(filteredResList,1);

    % Matrix to store the results
    gapsMatrix = zeros(nRes+1,5);

    % Check gap between first resonance and upper bound
    gapsMatrix(1,1:4) = [0 0 filteredResList(1,:)];
    if pumpBounds(2) - filteredPumpRes(1) > maxBendAng
        gapsMatrix(1,5) = 1;
    end

    % Check gap between last resonance and lower bound
    gapsMatrix(end,1:4) = [filteredResList(end,:) 0 0];
    if filteredPumpRes(end) - pumpBounds(1) > maxBendAng
        gapsMatrix(end,5) = 1;
    end

    % Check gaps between resonances
    for i = 1:nRes-1
        gapsMatrix(i+1,1:4) = [filteredResList(i,:) filteredResList(i+1,:)];
        if filteredPumpRes(i) - filteredPumpRes(i+1) > maxBendAng
            gapsMatrix(i+1,5) = 1;
        end
    end

    % Get the gaps
    gapsRows = gapsMatrix(:,5) == 1;
    gaps = gapsMatrix(gapsRows,1:4);

end




