function gaps = findTisserandGraphGaps(objectNames,vInfLevels,rEncs,muCB,minRps,muFBs,resLists,varargin)
% Generate a list of all gaps in a full Tisserand graph, meaning in all
% the v-infinity contours defined for each gravity-assist body considered
% for the problem. A gap means two adjacent resonances whose corresponding
% pump angles difference is greater than the maximum bending angle of the
% corresponding v-infinity contour. It can also happen in between a
% resonance and an intersection between contours of different
% gravity-assist bodies.
%
% The output of the function is list of the identified gaps for each of the
% gravity-assist bodies. Each list identifies the contours in which the
% gaps are found and the two adjacent resonances corresponding to the gap.
%
% Input:
% - objectNames: names of the bodies [-]. String vector with size 1xnObj
%                (nObj = number of objects)
%
% - vInfLevels: v-infinity velocity levels considered for each object [m/s]
%               Structure with nObj fields. Each field must be named as one
%               of the entries of objectNames. Each field contains a vector
%               with each of the vInf levels of the corresponding body. 
%
% - rEncs: radius of encounter with each object [m] (distance from the
%          central body to the gravity-assist body). Structure with nObj
%          fields. Each field must be named as one of the entries of
%          objectNames. Each field must be a scalar containing the radius
%          of encounter.
%
% - muCB: gravitational parameter of the central body [m^3/s^2]
%
% - minRps: minimum radius of the flyby hyperbola for each of the objects
%           [m]. Structure with nObj fields. Each field must be named as
%           one of the entries of objectNames. Each field must be a scalar
%           containing the object's minimum radius of the flyby hyperbola.
%
% - muFBs: gravitational parameter of each of the objects [m^3/s^2].
%          Structure with nObj fields. Each field must be named as one of
%          the entries of objectNames. Each field must be a scalar
%          containing the standard gravitational parameter of the object.
%
% - resLists: list of resonances for each body. Structure with nObj fields.
%             Each field must be named as one of the entries of
%             objectNames. Each field must be a 2-columns matrix in which
%             each of the rows is a different resonance. The first column
%             contains the values of N (number of gravity-assist body
%             revolutions) and the second column contains the values of M
%             (number of spacecraft revolutions).
%
% - varargin{1} = intersections: structure containing a list of all the
%                 transfers of the defined Tisserand graph. Each transfer
%                 is identified by a vector of 6 parameters:
%                 [name of departure object [-], vInf of departure [m/s],
%                  pump angle of departure [rad], name of arrival object
%                  [-], vInf of arrival [m/s], pump angle of arrival [rad]]
%
% Output:
% - gaps: list of identified gaps (adjacent resonances at distance greater
%         than the maximum bending angle of the corresponding contour).
%         Structure with nObj fields. Each field is named as one of the
%         entries of objectNames. Each of these fields is a 5-columns
%         matrix in which each row corresponds to an identified gap.
%       
%         Each row is read as follows, the two first columns correspond to
%         one of the adjacent resonances in which the gap is identified.
%         The third and fourth columns correspond to the other adjacent
%         resonances. The fifth colum identifies the v-infinity magnitude
%         of the contour in which the gap is found. Therefore, if a gap is
%         identified between adjacent resonaces 3:4 and 5:6 in the 1500 m/s
%         contour, the corresponding line will read: [3 4 5 6 1500].
%
%         The intersections are identified through the reserved values
%         [-1 -1]. Therefore, if a line reads [-1 -1 3 4 1500], it means
%         that the function has identified a gap between the lowest
%         intersection in the 1500 m/s contour and the 3:4 resonance.
%
% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%

    % Default variables
    default.intersections = {};

    % Treat optional parameters
    if nargin > 7
        intersections = varargin{1};
    else
        intersections = default.intersections;
    end

    % Compute number of objects
    nObj = length(objectNames);

    % Validate inputs
    if numel(fieldnames(vInfLevels)) ~= nObj
        error('vInfRanges must have %d fields.', nObj);
    end
    if numel(fieldnames(rEncs)) ~= nObj
        error('rEncs must have %d fields.', nObj);
    end
    if numel(fieldnames(minRps)) ~= nObj
        error('minRps must have %d fields.', nObj);
    end
    if numel(fieldnames(muFBs)) ~= nObj
        error('muFBs must have %d fields.', nObj);
    end
    if numel(fieldnames(resLists)) ~= nObj
        error('resLists must have %d fields.', nObj);
    end

    % Check that each object name has a corresponding field in vInfRanges,
    % rEncs and resonances
    for i = 1:nObj
        objectName = objectNames{i};
        if ~isfield(vInfLevels, objectName)
            error('vInfRanges must have a field named %s.', objectName);
        elseif ~isfield(rEncs, objectName)
            error('rEncs must have a field named %s.', objectName);
        elseif ~isfield(minRps, objectName)
            error('minRps must have a field named %s.', objectName);
        elseif ~isfield(muFBs, objectName)
            error('muFBs must have a field named %s.', objectName);
        elseif ~isfield(resLists, objectName)
            error('resLists must have a field named %s.', objectName);
        end
    end

    % Create the structure to store the results
    gaps = struct();
    for objectName = objectNames
        gaps.(objectName) = [];
    end

    % Extract the rEnc values for each object name
    rEncValues = zeros(1, length(objectNames));
    for i = 1:length(objectNames)
        rEncValues(i) = rEncs.(objectNames{i});
    end

    % Sort the objects in increasing order of rEnc
    [~, sortedIndices] = sort(rEncValues);
    objectNames = objectNames(sortedIndices);

    % Compute the list of intersections if not provided
    if isempty(intersections)
        intersections = findAllTissTransfers(objectNames,vInfLevels,rEncs,muCB);
    end

    % Loop on the objects
    for i = 1:length(objectNames)

        % Get current object name
        currentObjectName = objectNames(i);

        % Get the resonance list for current object
        resListCurrent = resLists.(currentObjectName);

        % Get the resonances bounding the region of interest for the
        % current contour
        boundingRes = [resListCurrent(1,:); resListCurrent(end,:)];

        % Populate the region of interest
        intermediateGaps = findObjectContoursGaps(vInfLevels.(currentObjectName),minRps.(currentObjectName),muFBs.(currentObjectName),rEncs.(currentObjectName),muCB,resListCurrent,"resBounded",[boundingRes(1,:);boundingRes(2,:)]);

        % Extract intersections for current object
        objectIntersections = intersections(strcmp(intersections(:, 1), currentObjectName), :);

        % Get gaps between limits of region of interest and intersections
        [lowerGaps,upperGaps] = findGapsWithIntersections(objectIntersections,rEncs,muFBs.(currentObjectName),minRps.(currentObjectName),muCB,boundingRes(1,:),boundingRes(2,:));

        % Check if it is the lowest or highest object
        if i == 1
            lowerGaps = [];
        end
        if i == length(objectNames)
            upperGaps = [];
        end

        % Construct the gaps matrix
        gaps.(currentObjectName) = [lowerGaps; intermediateGaps; upperGaps];

    end

end