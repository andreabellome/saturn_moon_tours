function [LEGS, TYPES] = generateFirstLegs(INPUT)

% DESCRIPTION :
% this function allows for computing first legs on Tisserand map. It
% computes intersections between a departing planet and infinity velocity
% contours of other planets specified in input (no DSM occur in the first
% leg). The case on which the departing planet is the same of the arrival
% one is considered as a resonant transfer.
%
% INPUT :
% INPUT : structure containing the following information:
%         - INPUT.pl1 : ID of the departing planet (1. Mercury, 2. Venus,
%         3. Earth, 4. Mars, 5. Jupiter, 6. Saturn, 7. Uranus, 8. Neptune)
%         - INPUT.vinf_dep_lev : vector with infinity velocity levels at
%         the departure (km/s)
%         - INPUT.planetlist : list of planets to be explored during the
%         search
%         - INPUT.vinflevels : vector with infinity velocity levels at each
%         planet to be explored during the search (km/s)
% 
% OUTPUT : 
% LEGS : matrix containing the first two nodes of the transfer. In
%        particular one has :
%        - LEGS(:,1) is the departing planet
%        - LEGS(:,2) is the departing alpha angle (rad)
%        - LEGS(:,3) is the departing infinity velocity (km/s)
%        - LEGS(:,4) is the arrival planet
%        - LEGS(:,5) is the arrival alpha angle (rad)
%        - LEGS(:,6) is the arrival infinity velocity (km/s)
% TYPES : matrix containing the type of transfer. In particular, one has :
%         - TYPES(:,1) is the type of transfer (in this case the only
%         admissible value is 1 since VILTs are not considered)
%         - TYPES(:,2) is the parameter defining the transfer (in this case
%         the only admissible value is NaN since VILTs are not considered) 
%         - TYPES(:,3) is the N value (in this case the only admissible
%         value is NaN since VILTs are not considered) 
%         - TYPES(:,4) is the M value (in this case the only admissible
%         value is NaN since VILTs are not considered) 
%         - TYPES(:,5) is the L value (in this case the only admissible
%         value is NaN since VILTs are not considered)
% 
% -------------------------------------------------------------------------

% --> extract inputs
pl1          = INPUT.pl1;
vinf_dep_lev = INPUT.vinf_dep_lev;
planetlist   = INPUT.planetlist;
vinflevels   = INPUT.vinflevels;
idcentral    = INPUT.idcentral;

%%%%% FIRST LEGS %%%%%
LEGS    = zeros(length(vinf_dep_lev)*length(planetlist)*length(vinflevels),6);
TYPES   = zeros(length(vinf_dep_lev)*length(planetlist)*length(vinflevels),5);
rownext = 1; 
for indvinfdep = 1:length(vinf_dep_lev)
    
    vinfpl1 = vinf_dep_lev(indvinfdep); % --> infinity velocity at departure (km/s)
    
    % --> find intersections (i.e. 0-DV solutions) with achievable planets
    for indpllist = 1:length(planetlist)
        pl2   = planetlist(indpllist);                                                       
        if pl2 ~= pl1 % --> the case of pl2 == pl1 is in the resonances
            INTER = checkIntersection(vinfpl1, pl1, vinflevels, pl2, idcentral);                        % --> compute intersections
            if ~isempty(INTER)                                                               % --> there is an intersection
                s = [1 NaN NaN NaN NaN];                                                     % --> transfer vector
                LEGS(rownext:rownext-1+size(INTER,1),:)  = INTER;                            % --> nodes  
                TYPES(rownext:rownext-1+size(INTER,1),:) = s.*ones(size(INTER,1),size(s,2)); % --> type of transfer  
                rownext = rownext + size(INTER,1);
            end
        end
    end
end
LEGS  = LEGS(~all(LEGS == 0, 2),:);   % --> eliminate rows all equal to zero
TYPES = TYPES(~all(TYPES == 0, 2),:); % --> eliminate rows all equal to zero
%%%%% FIRST LEGS %%%%%

end