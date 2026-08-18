function resList = populateObjectContours(vInfLevels,rpFB,muFB,rEnc,muCB,maxRev,varargin)
% Populate all v-infinity contours of an object with resonances so that
% adjacent resonances are at pump angle distance of less than the bending
% angle corresponding to a flyby with the provided radius of periapsis of
% the flyby hyperbola. The algorithm chooses the resonances with the lowest
% times of flight (lowest number of gravity-assist body revolutions N).
% 
% The parameter maxRev establish the maximum allowed values for N and M. If
% it is not possible to fully populate the contours with the provided
% maxRev the function will return a warning message but will return anyways
% the best possible distribution of resonances.
%
% It is possible to limit the population of the contours to a given region
% of the Tisserand graph. This can be done by providing the superior and
% inferior values of the interval of pump angle to be populated for each
% contour, or by providing the lower and upper resonances limiting the
% region of interest.
%
% Input:
% - vInfLevels: vInf velocity of each of the considered contours [m/s].
%               Size nx1 where n is the number of contours.
% - rpFB: minimum radius of periapsis of the flyby hyperbola [m]
% - muFB: gravitational parameter of the gravity-assist body [m^3/s^2]
% - rEnc: radius of encounter [m] (distance from the central body to the
%         gravity-assist body)
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
% - resList: obtained list of resonances. Each colum correspond to a
%            resonance. The first colum is the number of revolutions of the
%            gravity-assist body (N) while the second column is the number
%            of spacecraft revolutions (M) [-].
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

    % Create the list of resonances
    resList = resBounds;

    % Loop on the contours
    for i = nContours:-1:1

        % Get the v-infinity level
        vInf = vInfLevels(i);

        % Obtain the list of resonances required to populate the current
        % contour
        if pumpResBounded == "pumpBounded"

            newList = populateVInfContour(vInf,rpFB,muFB,rEnc,muCB,maxRev,pumpBounds(i,2),pumpBounds(i,1));

        elseif pumpResBounded == "resBounded"

            % Get current contour bounds
            pumpContourLimits = generatePumpAnglesList(vInf,rEnc,muCB,2);

            % Compute bounds on sma for the current contour
            smaBounds = smaAndEccFromPump([pumpContourLimits(2) pumpContourLimits(1)],rEnc,muCB,vInf);

            % Compute the semi-major axis of each resonance on the current
            % list
            resSmaList = getResonanceSma(resList,rEnc);

            % Get the index of the first available resonance for the
            % current contour
            firstResIndex = find(resSmaList > smaBounds(1), 1, 'first');

            % Get the index of the last available resonance for the
            % current contour
            lastResIndex = find(resSmaList < smaBounds(2), 1, 'last');

            % Populate contour between the two resonances
            newList = populateVInfContour(vInf,rpFB,muFB,rEnc,muCB,maxRev,resList(firstResIndex,:),resList(lastResIndex,:));
        end

        % Add the new list to the existing list
        resList = [resList; newList];

        % Remove any duplicate resonances
        resList = unique(resList,'rows');

        % Sort the list
        resList = sortResonances(resList);

    end

end