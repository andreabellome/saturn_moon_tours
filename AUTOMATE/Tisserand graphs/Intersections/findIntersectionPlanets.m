function [LEGS, TYPES, LEGS_struc] = findIntersectionPlanets(pl_deps, vinf_dep_lev, planetlist, vinflevels, idcentral)

% DESCRIPTION :
% this function finds intersections between infinity velocity contours in
% Tisserand map between planets. The case on which the departing planet is 
% the same of the arrival one is considered as a resonant transfer.
%
% INPUT : 
% pl_deps      : list of IDs for departing planets
% vinf_dep_lev : infinity velocity contours for departing planets (km/s)
% planetlist   : list of IDs for arrival planets
% vinflevels   : infinity velocity contours for arrival planets (km/s)
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
% LEGS_struc : the same as LEGS, but with TOFs (days) for each row
% 
% -------------------------------------------------------------------------

if nargin == 4
     idcentral = 1;
end

% --> find all possible intersections between different planets
LEGS  = [];
TYPES = [];
for indpld = 1:length(pl_deps)
    
    indpld;

    pl_dep = pl_deps(indpld);
   
    % --> generate inputs
    INPUT.pl1          = pl_dep;
    INPUT.vinf_dep_lev = vinf_dep_lev;
    INPUT.planetlist   = planetlist;
    INPUT.vinflevels   = vinflevels;
    INPUT.idcentral    = idcentral;

    [legs, types] = generateFirstLegs(INPUT);
    
    LEGS  = [LEGS; legs];
    TYPES = [TYPES; types];

end

if nargout > 2

    % --> compute TOFs for each row of LEGS and save in structure
    for indleg = 1:size(LEGS,1)

        pl1   = LEGS(indleg,1);
        alpha = LEGS(indleg,2);
        vinf  = LEGS(indleg,3);
        pl2   = LEGS(indleg,4);

        kep   = alphaVinf2kep(alpha, vinf, pl1, idcentral);

        if idcentral == 1
            TOFs = timeOfFlight_INTER(kep, pl1, pl2)./86400;
        else
            TOFs = NaN;
        end

        LEGS_struc(indleg,:).pl1    = pl1;
        LEGS_struc(indleg,:).alpha1 = alpha;
        LEGS_struc(indleg,:).vinf1  = vinf;

        LEGS_struc(indleg,:).pl2    = pl2;
        LEGS_struc(indleg,:).alpha2 = LEGS(indleg,5);
        LEGS_struc(indleg,:).vinf2  = LEGS(indleg,6);

        LEGS_struc(indleg,:).TOFs   = TOFs; % --> [OO, OI, IO, II]

    end

end

end