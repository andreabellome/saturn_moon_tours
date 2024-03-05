function LEGSnext = nodeExpansion(depRow, INPUT)

% DESCRIPTION
% This function is used to expand the tree of possible VILTs and
% intersections on a Tisserand graph, starting from a SINGLE tour.
% 
% INPUT
% - depRow : row vector containing a tour. Each tour is made by
%           'next_nodes' rows (see generateVILTSall.m) one after the other.
% - INPUT  : structure with the following mandatory fields:
%           - maxlegs : max. number of flyby legs
%           - opt     : (1) is for single-objective BS, (2) is for
%           multi-objective BS and DP
%           - BW           : beam width
%           - decrease     : (1) IN Saturn System, (0) OUT Saturn System
%           - tolDVmax     : max. DV for the whole tour [km/s]
%           - tofdmax      : max. TOF for the whole tour [days]
%           - pldep        : ID of the departing flyby body (see constants.m)
%           - plarr        : ID of the arrival flyby body (see constants.m)
%           - costFunction : cost function (see for example
%           costFunctionTiss.m) 
%           - vinfArrOPTS  : 1x2 vector with min. and max. arrival infinity
%           velocities [km/s]
%           - VILTS        : (1) compute VILTS, (0) do not compute VILTS
%           - LEGSvilts    : database of VILTs. Each row is equal to
%           'next_nodes' (see also generateVILTSall.m)
%           - LEGS_inter   : database of intersections on Tisserand map,
%           see also findIntersectionPlanets.m
%           - DELTA_MAX    : database of max. deflections at flyby bodies
%           (see also findDeltaMaxPlanets.m)
%           - IDS          : IDs of the flyby bodies (see constants.m)
%           - idcentral    : ID of the central body (see constants.m)
%           - vinflevels   : list of infinity velocities at the flyby
%           bodies [km/s]
%
% OUTPUT
% - LEGSnext : matrix containing the tours. Each row is a tour. Each tour
%              is made by 'next_nodes' rows (see generateVILTSall.m) one
%              after the other.
% -------------------------------------------------------------------------


DELTA_MAX   = INPUT.DELTA_MAX;
LEGS_inter  = INPUT.LEGS_inter;
vinfArrOPTS = INPUT.vinfArrOPTS;
plarr       = INPUT.plarr;

% --> find departing node
depNode    = [ depRow( 1,end-11 ), depRow( 1,end-3 ) depRow( 1,end-2 ) ];
type       = depRow(1,end-10); % --> II/IO/OI/OO

deltaMax   = DELTA_MAX(DELTA_MAX(:,1) == depNode(1) & abs(DELTA_MAX(:,2) - depNode(3))<1e-7, 3);
deltaMax   = deltaMax(1);
alpha      = depNode(2);

% --> START: expand (1): VILTs transfer
LEGSnext_1 = [];
if INPUT.VILTS == 1

    toldegreesV = 0;
    
    LEGSvilts = INPUT.LEGSvilts;
    legtosave = LEGSvilts(LEGSvilts(:,1) == depNode(1) & abs(LEGSvilts(:,8) - depNode(3))<1e-7, :);

    % --> check the max. deflection rule
    diffalpav    = abs(legtosave(:,7) - depNode(2));
    diffalpadmax = - diffalpav + deltaMax;
    indxsa       = find(diffalpadmax >= 0 | (diffalpadmax < 0 & (abs(diffalpadmax)) <= toldegreesV)); % --> to save!

    if ~isempty(indxsa)
        
        legtosave = legtosave(indxsa,:);

        % --> check the type of transfer (II/IO/OI/OO)
        if type == 88 || type == 18 % --> only save 81 and 88
            indxst = find( legtosave(:,2) == 88 | legtosave(:,2) == 81 );
        elseif type == 11 || type == 81 % --> only save 18 and 11
            indxst = find( legtosave(:,2) == 18 | legtosave(:,2) == 11 );
        else
            indxst = [1:1:size(legtosave,1)]';
        end

        if ~isempty(indxst)
            legtemp = legtosave(indxst,:);
        else
            legtemp   = [];
        end
        
    else
        legtemp   = [];
    end
    legsnext  = legtemp;

    if ~isempty(legsnext)
        LEGSnext_1 = [ depRow.*ones(size(legsnext,1),size(depRow,2)) legsnext ];
    end
end
LEGSnext_1 = canYouReach11Res(LEGSnext_1, INPUT);
LEGSnext_1 = nodeAttachedAlreadyVisited(LEGSnext_1);
% --> END: expand (1): VILTs transfer

% --> START: expand (2): INTERSECTIONS transfer
LEGSnext_2 = [];
if INPUT.idcentral == 1
    toldegreesI = rad2deg(5);
else
    toldegreesI = 0;
end
LEGS_tempinter = LEGS_inter(LEGS_inter(:,1) == depNode(1) & abs(LEGS_inter(:,3) - depNode(3))<1e-7, :);
diffalpa       = abs(LEGS_tempinter(:,2) - alpha);
diffalpadmax   = - diffalpa + deltaMax;
indxs          = find(diffalpadmax >= 0 | (diffalpadmax < 0 & (abs(diffalpadmax)) <= toldegreesI)); % --> to save!
if ~isempty(indxs)
    LEGS_tempinter = LEGS_tempinter(indxs,:);
else
    LEGS_tempinter = [];
end
if ~isempty(LEGS_tempinter)
    indxs = find( LEGS_tempinter(:,end-2) == plarr );
    if ~isempty(indxs)
        LEGS_tempinter  = LEGS_tempinter(indxs,:);    
        LEGS_tempinter(LEGS_tempinter(:,end) > vinfArrOPTS(2),:)  = [];
        if ~isempty(LEGS_tempinter)
            
            LEGSnext_2          = zeros( size(LEGS_tempinter,1), 12 );
            LEGSnext_2(:,1)     = LEGS_tempinter(:,4);   % --> next node: planet
            LEGSnext_2(:,7:8)   = LEGS_tempinter(:,2:3); % --> prev node: (alpha vinf)
            LEGSnext_2(:,9:10)  = LEGS_tempinter(:,5:6); % --> next node: (alpha vinf)
            LEGSnext_2(:,3)     = LEGS_tempinter(:,1);   % --> prev node: planet
            LEGSnext_2(:,end-6) = NaN;                   % --> flag to specify this is an intersection and not a VILT

        end
    end
end
LEGSnext_2 = [ depRow.*ones(size(LEGSnext_2,1),size(depRow,2)) LEGSnext_2 ];
% --> END: expand (2): INTERSECTIONS transfer

% --> save next legs
LEGSnext  = [ LEGSnext_1; LEGSnext_2 ];

end
