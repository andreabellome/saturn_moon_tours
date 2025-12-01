function [lowerGaps,upperGaps] = findGapsWithIntersections(objectIntersections,rEncs,muFB,rpFB,muCB,minRes,maxRes)
% Check for gaps in between the resonance acting as a lower bound for the 
% of interest of a gravity-assist body and the intersections with contours
% of other gravity-assist bodies.
%
% The function checks the distances in pump angle between the lower
% bounding resonance and the intersections with the highest pump angle on
% each contour. Similarly, it checks the distances in pump angle between
% the upper bounding resonance and the intersections with the lowest pump
% angle on each contour. If any of these distances is greater than the
% maximum bending angle of the corresponding v-infinity contour, the
% function will collect the information of the gap and output it.
%
% Input:
% - objectIntersections: matrix containing all the intersections of the
%                        gravity-assist body's contours with other bodies'
%                        contours. Each row correspond to an intersection.
%                        Each intersection is identified by a vector of 6
%                        parameters:
%                        [name of departure object [-], vInf of departure
%                        [m/s], pump angle of departure [rad], name of
%                        arrival object [-], vInf of arrival [m/s], pump
%                        angle of arrival [rad]]
%                        The departure body must always be the gravity-
%                        assist body whose region of interest is being
%                        computed.
% - rEncs: radius of encounter of all gravity-assist bodies [m]. Structure
%          in which is field is named with the same identifier for the
%          gravity-assist bodies as those used in the objectIntersections
%          matrix.
% - muFB: gravitational parameter of the gravity-assist body [m^3/s^2]
% - rpFB: minimum radius of periapsis of the flyby hyperbola [m]
% - muCB: gravitational parameter of the central body [m^3/s^2]
% - minRes: resonance acting as lower bound of the region of interest of
%           the gravity-assist body [N M]
% - maxRes: resonance acting as upper bound of the region of interest of
%           the gravity-assist body [N M]
%
% Output:
% - lowerGaps: gaps identified between the lower intersections and lower
%              bounding resonances. Format: [-1 -1 N M vInf] where N and M
%              identify the lower bounding resonance and vInf identifies
%              the v-infinity magnitude of the contour in which the gap is
%              identified.
%
% - upperGaps: gaps identified between the upper intersections and upper
%              bounding resonances. Format: [N M -1 -1 vInf] where N and M
%              identify the upper bounding resonance and vInf identifies
%              the v-infinity magnitude of the contour in which the gap is
%              identified.
%
% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%

    % Current object name
    currentObjectName = string(objectIntersections(1, 1));

    % Compute circular velocity of object
    vFB = circularVelocity(muCB,rEncs.(currentObjectName));

    % Extract the names of the objects for which intersection with
    % contours of this object exist
    ObjectNames2 = unique(objectIntersections(:, 4));

    % Extract the rEnc values for each object name
    rEncValues = zeros(1, length(ObjectNames2));
    for i = 1:length(ObjectNames2)
        rEncValues(i) = rEncs.(ObjectNames2{i});
    end

    % Find objects with lowest and highest rEnc values
    [~, sortedIndices] = sort(rEncValues);
    lowestREncObject = ObjectNames2{sortedIndices(1)};
    highestREncObject = ObjectNames2{sortedIndices(end)};

    % Extract intersections with the object with lowest rEnc
    lowIntersections = objectIntersections(strcmp(objectIntersections(:, 4), lowestREncObject),:);

    % Filter lowIntersections to keep the row with the highest
    % pump angle for each vInf contour
    filteredLowIntersections = filterIntersections(lowIntersections, true);

    % Extract intersections with the object with highest rEnc
    highIntersections = objectIntersections(strcmp(objectIntersections(:, 4), highestREncObject),:);
    
    % Filter lowIntersections to keep the row with the lowest
    % pump angle for each vInf contour
    filteredHighIntersections = filterIntersections(highIntersections, false);

    % Initialize lowerGaps and upperGaps matrices
    lowerGaps = [];
    upperGaps = [];

    % Check for gaps between the smaller resonance and the lower
    % intersections
    for i = 1:size(filteredLowIntersections, 1)
        currentRow = filteredLowIntersections(i, :);

        % Get current vInf level
        vInf = currentRow{2};

        % Get intersection pump angle
        pumpAngle = currentRow{3};

        % Compute resonance pump for current vInf level
        resPump = getResonancePump(minRes(1), minRes(2), vInf, rEncs.(currentObjectName), vFB, muCB);

        % Compute maximum bending angle for current vInf level
        maxBendAng = bendFromRpAndVInf(vInf, rpFB, muFB);

        % Check for gap
        if pumpAngle - resPump > maxBendAng
            lowerGaps = [lowerGaps; [-1 -1 minRes(1) minRes(2) vInf]];
        end
    end

    % Check for gaps between the highest resonance and the upper
    % intersections
    for i = 1:size(filteredHighIntersections, 1)
        currentRow = filteredHighIntersections(i, :);

        % Get current vInf level
        vInf = currentRow{2};

        % Get intersection pump angle
        pumpAngle = currentRow{3};

        % Compute resonance pump
        resPump = getResonancePump(maxRes(1), maxRes(2), vInf, rEncs.(currentObjectName), vFB, muCB);

        % Compute maximum bending angle
        maxBendAng = bendFromRpAndVInf(vInf, rpFB, muFB);

        % Check for gap
        if resPump - pumpAngle > maxBendAng
            upperGaps = [upperGaps; [maxRes(1) maxRes(2) -1 -1 vInf]];
        end
    end

end

% Function to filter intersections to keep only the highest or lowest one
% for each vInf contour
function filteredIntersections = filterIntersections(intersections, keepHighest)
    % Extract unique vInf values
    uniqueVInf = unique([intersections{:, 2}]);

    % Initialize filteredIntersections
    filteredIntersections = {};

    % Loop through each unique vInf value
    for i = 1:length(uniqueVInf)
        currentVInf = uniqueVInf(i);

        % Extract rows where vInf = currentVInf
        vInfGroup = intersections([intersections{:, 2}] == currentVInf, :);

        % Extract intersections pumpAngle values for the current vInf contour
        pumpAngleValues = [vInfGroup{:, 3}];

        % Determine the index of the row with the highest or lowest pumpAngle
        if keepHighest
            [~, maxIndex] = max(pumpAngleValues);
        else
            [~, minIndex] = min(pumpAngleValues);
            maxIndex = minIndex;
        end

        % Keep the row with the highest or lowest pumpAngle
        filteredIntersections = [filteredIntersections; vInfGroup(maxIndex, :)];
    end
end