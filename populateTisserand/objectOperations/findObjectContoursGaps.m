function objectGaps = findObjectContoursGaps(vInfLevels,rpFB,muFB,rEnc,muCB,resList,varargin)
% Given a resonances list and a list of Tisserand graph contours of a
% gravity-assist body, check for adjacent resonances whose pump angle
% difference is greater than the maximum bending angle (gaps). This bending
% angle is defined through the minimum radius of periapsis of the flyby
% hyperbola and the v-infinity magnitude of each of the Tisserand graph
% contours.
%
% It is possible to bound the region of interest to check for gaps only in
% some region of the graph. This region can be defined through pump angle
% intervals for each contour or by specifying two resonances that act as
% lower and upper bounds of the region of interest.
%
% Input:
% - vInfLevels: vInf velocity of each of the considered contours [m/s].
%               Size nx1 where n is the number of contours.
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
% - varargin{1} = pumpResBounded: flag to set the definition of the region
%                 of interest to pump angle bounded or resonance bounded.
%                 String with possible values:
%                 - 'pumpBounded' (default value)
%                 - 'resBounded'
%
% - varargin{2} = pumpBounds (if pumpBounded) or resBounds (if resBounded):
%
%                 - pumpBounds: interval of pump angles to populate.
%                   Size nx2 [rad]. Each row correspond to a contour in the
%                   input vInfLevels vector. Default value: [0 pi]
%
%                 - resBounds: lower (smaller N/M) and upper (higher N/M)
%                   resonances limiting the region of interest.
%                   Size 2x2 [-].
%                   [lower resonance N, lower resonance M;
%                   [upper resonance N, upper resonance M]
%
% Output:
% - objectGaps: list of identified gaps (adjacent resonances at distance
%               greater than the maximum bending angle of the corresponding
%               contour). 5-columns matrix in which each row corresponds to
%               an identified gap. The 4 first columns identifies the
%               adjacent resonances between which the gap is found, as
%               described for the output of the "findVInfContourGaps"
%               function. The fifth colum identifies the v-infinity
%               magnitude of the contour in which the gap is found.
%
% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%

    % Default values
    default.pumpResBounded = 'pumpBounded';
    default.pumpBounds = [0 pi];

    % Get number of v-infinity contours
    nContours = length(vInfLevels);

    % Treat optional parameters
    if nargin > 7
        pumpResBounded = string(varargin{1});
        if pumpResBounded == "pumpBounded"
            pumpBounds = varargin{2};
        else
            resBounds = varargin{2};
        end
    else
        pumpResBounded = default.pumpResBounded;
        pumpBounds = ones(nContours,2);
        pumpBounds(:,1) = default.pumpBounds(1)*pumpBounds(:,1);
        pumpBounds(:,2) = default.pumpBounds(2)*pumpBounds(:,2);
    end

    % Check that pump bounds has correct dimensions
    if pumpResBounded == "pumpBounded" && size(pumpBounds,1) ~= length(vInfLevels)
        error("Pump bounds must have the same number of rows as vInf levels.")
    end

    % Sort and format the resonances list
    resList = unique(resList,'rows');
    resList = sortResonances(resList);

    % Create the list of gaps
    objectGaps = [];

    % Loop on the contours
    for i = 1:nContours

        % Get the v-infinity level
        vInf = vInfLevels(i);

        % Obtain the list of gaps for current contour
        if pumpResBounded == "pumpBounded"
            contourGaps = findVInfContourGaps(vInf,rpFB,muFB,rEnc,muCB,resList,pumpBounds(i,2),pumpBounds(i,1));
        else
            contourGaps = findVInfContourGaps(vInf,rpFB,muFB,rEnc,muCB,resList,resBounds(1,:),resBounds(2,:));
        end

        % Create the new gap rows to add
        newGaps = [contourGaps vInf*ones(size(contourGaps,1),1)];

        % Add the new list to the existing list
        objectGaps = [objectGaps; newGaps];

    end

    % Sort the gaps matrix
    ratiosMatrix = [objectGaps(:, 1) ./ objectGaps(:, 2), objectGaps(:, 5)];
    [~,sortedIndices] = sortrows(ratiosMatrix);
    objectGaps = objectGaps(sortedIndices,:);

end