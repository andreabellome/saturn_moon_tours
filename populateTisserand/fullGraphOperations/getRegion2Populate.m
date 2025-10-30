function boundingRes = getRegion2Populate(objectIntersections,rEncs,muFB,rpFB,muCB,maxRev)
% Find the region of interest of a gravity-assist body's contours. This
% region is determined based on the intersections with contours of other
% gravity-assist bodies. The instersections acting as upper bounds of the
% region are those corresponding to higher energy orbits. The intersections
% acting as lower bounds of the region are those corresponding to the lower
% energy orbits.
%
% The function outputs two resonances wich are those acting as lower and
% upper bounds of the region of interest of the gravity-assist body.
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
% - maxRevs: maximum number of revolutions around central body [-]
%
% Output:
% - boundingRes: lower (smaller N/M) and upper (higher N/M) resonances
%                limiting the region of interest. Size 2x2 [-].
%                [lower resonance N, lower resonance M;
%                [upper resonance N, upper resonance M]
%
% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%

    % Current object name
    currentObjectName = string(objectIntersections(1, 1));

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

    % Find the resonance acting as lower bound for the region of interest
    lowerResonance = findObjectLimitResonance(filteredLowIntersections(:,2:3), rEncs.(currentObjectName), muFB, rpFB, muCB, maxRev, -1);

    % Find the resonance acting as lower bound for the region of interest
    upperResonance = findObjectLimitResonance(filteredHighIntersections(:,2:3), rEncs.(currentObjectName), muFB, rpFB, muCB, maxRev, 1);

    % Resonances bounding the region of interest
    boundingRes = [lowerResonance; upperResonance];

end

% Function to filter intersections keeping only the highest or lowest
% energy one for each vInf contour
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

