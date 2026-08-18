function newResList = populateBetweenResonances(resList,vInf,rEnc,muCB,maxBendAng,maxRev)
% Check the distance in pump angle between each pair of adjacent resonances
% in a given set. If this distance is greater than the maximum bending
% angle, search for the intermediate resonance with lower N and add it to
% the list.
%
% For each pair of adjacent resonances, check also if there is any
% resonances in between with lower N than any of the two condsidered
% resonances. If so, add it to the list.
%
% The user must specify a maximum number of revolutions. If two adjacent
% resonances are at a pump angle distance greater than the  maximum bending
% angle, but no intermediate resonances with N lower than the maximum
% number of revolutions are available, the function will return a warning.
%
% Input:
% - resList: resonances list. Each colum correspond to a resonance. The
%            first colum is the number of revolutions of the gravity-assist
%            body (N) while the second colum is the number of spacecraft
%            revolutions (M) [-].
% - vInf: vInf velocity of the flyby [m/s]
% - rEnc: radius of encounter [m] (distance from the central body to the
%         gravity-assist body)
% - muCB: gravitational parameter of the central body [m^3/s^2]
% - maxBendAng: maximum bending angle of the flyby [rad]
% - maxRev: maximum number of revolutions around central body [-]
%
% Output:
% - newResList: updated resonances list with the new included resonances.
%               Same structure as "resList".
%
% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%

    % Sort the list of resonances
    resList = sortResonances(resList);

    % Copy the list
    newResList = num2cell(resList);

    % Compute velocity of gravity-assist body (assumes circular orbit)
    vFB = circularVelocity(muCB,rEnc);

    % Flag to determine whether the contour has been fully populated
    notPossibleToPopulate = false;

    for i = 1:size(resList,1)-1

        % Compute intermediate resonance
        interRes = findIntermediateResonance(resList(i,:),resList(i+1,:),maxRev);

        % Compute the pump angle of Res1
        pump1 = getResonancePump(resList(i,1),resList(i,2),vInf,rEnc,vFB,muCB);
        
        % Compute the pump angle of Res2
        pump2 = getResonancePump(resList(i+1,1),resList(i+1,2),vInf,rEnc,vFB,muCB);
        
        % Distance between resonances
        pumpDistance = abs(pump1 - pump2);
        
        % Check if an intermediate resonance is required
        if pumpDistance > maxBendAng
            if any(isnan(interRes))
                % It is not possible to fully populate the contour
                notPossibleToPopulate = true;
            else
                % Add the resonance to the list
                newResList = [newResList; {interRes(1),interRes(2)}];
            end

        % Check if the intermediate resonance has lower ToF that its
        % neighbours and therefore should be included in the list
        elseif interRes(1) < resList(i,1) || interRes(1) < resList(i+1,1)
            % Add the resonance to the list
            newResList = [newResList; {interRes(1),interRes(2)}];

        end


    end

    % Sort the output resonance list
    newResList = cell2mat(newResList);
    newResList = sortResonances(newResList);

    if notPossibleToPopulate
        warning('Not possible to fully populate contour with current number of maximum revolutions.')
    end

end
