function [DELTA_MAX] = findDeltaMaxPlanets(planetslist, vinflevs, idcentral)

% DESCRIPTION :
% generate all possible maximum deflection angles for SS planets, given
% infinity velocity levels.
%
% INPUT : 
% planetslist : list of flyby bodies IDs (see constants.m)
% vinflevels  : list of infinity velocities at planets (km/s)
% idcentral   : ID of the central body (see constants.m)
%
% OUTPUT : 
% DELTA_MAX : matrix containing :
%             - DELTA_MAX(:,1) : planet ID
%             - DELTA_MAX(:,2) : infinity velocity (km/s)
%             - DELTA_MAX(:,3) : delta max. (rad)
%
% -------------------------------------------------------------------------

if nargin == 2
    idcentral = 1;
end

DELTA_MAX = zeros(length(planetslist)*length(vinflevs),3);
inddelta = 1;
for indpl = 1:length(planetslist)
    pl = planetslist(indpl);
    for indvinf = 1:length(vinflevs)

        [~, mu, ~, radius, hmin] = constants(idcentral, pl);

        rpip                  = radius + hmin;
        DELTA_MAX(inddelta,:) = [pl vinflevs(indvinf) Vinf2Hyperbola(vinflevs(indvinf), rpip, mu)];
        inddelta              = inddelta + 1;
    end
end

end
