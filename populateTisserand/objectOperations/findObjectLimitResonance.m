function limitRes = findObjectLimitResonance(vInfPump, rEnc, muFB, rpFB, muCB, maxRevs, searchDirection)
% Given a list of v-infinity contours and pump angle bounds, find the
% resonance acting as bounding resonance for the full set of contours. The
% function will compute all find the resonance with lowest time of flight
% (lowest N) that allows to reach the provided superior or inferior pump
% angle bound. Then, it will take as bounding resonance for the full set of
% contours the one with higher or lower energy (depending on the search
% direction) among them.
% 
% If the search direction is set to 1 the algorithm searches towards 0°
% pump angle (searches an upper bound resonance). If the search direction
% is set to -1 the algorithm searches towards 180° pump angle (searches a
% lower bound resonance).
%
% The parameter maxRev establish the maximum allowed values for N and M of
% the selected bounding resonance.
%
% Input:
% - vInfPump: matrix containing the values of v-infinity and pump angle
%             bounds of each contour. Each row correspond to a contour. The
%             first column has the values of v-infinity [m/s] of each
%             contour. The second colum has the values of pump angle bounds
%             [rad] of each contour.
% - rEnc: radius of encounter [m] (distance from the central body to the
%         gravity-assist body)
% - muFB: gravitational parameter of the gravity-assist body [m^3/s^2]
% - rpFB: minimum radius of periapsis of the flyby hyperbola [m]
% - muCB: gravitational parameter of the central body [m^3/s^2]
% - maxRevs: maximum number of revolutions around central body [-]
% - searchDirection: if set to 1 the provided pump angle bounds on
%                    "vInfPump" are upper bounds in terms of orbital energy
%                    and the algorithm will search towards 0° of pump
%                    angle. If set to -1 the provided pump angle bounds are
%                    lower bounds in terms of orbital energy and the
%                    algorithm will search towards 180° of pump angle [-].
%
% Output:
% - limitRes: bounding resonance for the full set of v-infinity contours
%             [-]. Size 1x2 [N M]. Upper bound of the region of interest if
%             searchDirection is set to 1 and lower bound if the
%             searchDirection is set to -1.
%
% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%

    % Initialize the list to store the bounding resonances
    resBounds = [];

    % Loop through each row in the vInf and pump matrix
    for i = 1:size(vInfPump, 1)
        % Extract current row data
        currentRow = vInfPump(i, :);
        vInf = currentRow{1};
        pumpAngle = currentRow{2};

        % Compute the maximum bending angle for current vInf level
        maxBendAng = bendFromRpAndVInf(vInf, rpFB, muFB);

        % Compute the limit resonance for current vInf level
        newRes = findLimitResonance(maxBendAng, vInf, rEnc, muCB, maxRevs, searchDirection, pumpAngle);

        % Add the new resonance to the list
        resBounds = [resBounds; newRes];
    end

    % Sort the resonances
    resBounds = sortResonances(resBounds);

    % Return the appropriate value based on searchDirection
    if searchDirection == -1
        limitRes = resBounds(1,:);
    elseif searchDirection == 1
        limitRes = resBounds(end,:);
    else
        error('Invalid searchDirection. Must be -1 or 1.');
    end
end