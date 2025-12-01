function resLists = populateTisserandGraph(objectNames,vInfLevels,rEncs,muCB,minRps,muFBs,maxRevs,minRes,maxRes,varargin)
% Generate a set of resonances for the full Tisserand graph of a problem.
% That means generating a set of resonances for all the contours of the
% different gravity-assist bodies. The resonances are chosen such that the
% distance between two adjacent resonances in terms of pump angle is
% smaller than the maximum bending angle of each contour.
%
% The algorithm tries to satisfy this requisite selecting the lowest
% possible number of resonances and prioritizing the selection of
% resonances with the lowest possible N (number of revolutions of the
% gravity-assist body around the central body).
%
% The algorithm populates with resonances only the regions of the contours
% of each gravity-assist body in between intersections with contours of
% other gravity-assist bodies.
%
% The user must specify a maximum number of revolutions for each body. If
% the no gaps between resonances condition can't be satisfied with the
% provided number of maximum revolutions, the function will warn the user
% but will anyways provide the must optimal distribution of resonances for
% the provided maximum revolutions.
%
% The only inputs from the user are the parameters required to construct
% the Tisserand graph of the problem (such as the v-infinity levels of each
% gravity-assist body), the maximum number of revolutions, and the lower
% and upper bound resonances to bound the region of interest of the most
% exterior and interior gravity-assist bodies of the graph (as these bodies
% do not have any intersections with other bodies above or below them,
% respectively).
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
% - maxRevs: maximum number of revolutions around central body [-].
%            Structure with nObj fields. Each field must be named as
%            one of the entries of objectNames. Each field must be a scalar
%            containing the object's maximum number of revolutions.
%
% - minRes: resonance acting as lower bound for the region of interest of
%           the most interior gravity-assist body in the graph [N M].
%
% - maxRes: resonance acting as upper bound for the region of interest of
%           the most exterior gravity-assist body in the graph [N M].
%
% - varargin{1} = intersections: structure containing a list of all the
%                 transfers of the defined Tisserand graph. Each transfer
%                 is identified by a vector of 6 parameters:
%                 [name of departure object [-], vInf of departure [m/s],
%                  pump angle of departure [rad], name of arrival object
%                  [-], vInf of arrival [m/s], pump angle of arrival [rad]]
%
% Output:
% - resLists: obtained list of resonances for each body. Structure with
%             nObj fields. Each field must is named as one of the entries
%             of objectNames. Each field is a 2-columns matrix in which
%             each of the rows is a different resonance. The first column
%             contains the values of N (number of gravity-assist body
%             revolutions) and the second column contains the values of M
%             (number of spacecraft revolutions).
%
% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%

    % Default variables
    default.intersections = {};

    % Treat optional parameters
    if nargin > 9
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
    if numel(fieldnames(maxRevs)) ~= nObj
        error('maxRevs must have %d fields.', nObj);
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
        elseif ~isfield(maxRevs, objectName)
            error('maxRevs must have a field named %s.', objectName);
        end
    end

    % Create the structure to store the results
    resLists = struct();
    for objectName = objectNames
        resLists.(objectName) = [];
    end

    % Extract the rEnc values for each object name
    rEncValues = zeros(1, length(objectNames));
    for i = 1:length(objectNames)
        rEncValues(i) = rEncs.(objectNames{i});
    end

    % Sort the objects in increasing order of rEnc
    [~, sortedIndices] = sort(rEncValues);
    objectNames = objectNames(sortedIndices);

    % Compute the list of intersections, if not provided
    if isempty(intersections)
        intersections = findAllTissTransfers(objectNames,vInfLevels,rEncs,muCB);
    end

    % Loop on the objects
    for i = 1:length(objectNames)

        % Get current object name
        currentObjectName = objectNames(i);

        % Extract intersections for current object
        objectIntersections = intersections(strcmp(intersections(:, 1), currentObjectName), :);

        % Get the resonances bounding the region of interest for the
        % current contour
        boundingRes = getRegion2Populate(objectIntersections,rEncs,muFBs.(currentObjectName),minRps.(currentObjectName),muCB,maxRevs.(currentObjectName));

        % Check if it is the lowest or highest object
        if i == 1
            boundingRes = [minRes; boundingRes(2,:)];
        end
        if i == length(objectNames)
            boundingRes = [boundingRes(1,:); maxRes];
        end
    
        % Populate the region of interest
        resLists.(currentObjectName) = populateObjectContours(vInfLevels.(currentObjectName),minRps.(currentObjectName),muFBs.(currentObjectName),rEncs.(currentObjectName),muCB,maxRevs.(currentObjectName),"resBounded",[boundingRes(1,:);boundingRes(2,:)]);

    end

end
