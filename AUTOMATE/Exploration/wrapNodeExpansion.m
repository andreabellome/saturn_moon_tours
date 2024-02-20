function LEGSnext = wrapNodeExpansion(depRow, INPUT)

% DESCRIPTION
% Wrapper function for expanding the tree of possible VILTs and
% intersections on a Tisserand graph, starting from MULTIPLE tours. 
% 
% INPUT
% - depRow : matrix containing the tours. Each row is a tour. Each tour
%              is made by 'next_nodes' rows (see generateVILTSall.m) one
%              after the other.
% - INPUT : structure with the following mandatory fields:
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
%
% -------------------------------------------------------------------------

if ~isempty(depRow)
    
    STRUC = struct( 'LEGSnext', cell(1,size(depRow,1)) );
    for indep = 1:size(depRow,1)
        
        % --> expand all the nodes
        lnext = nodeExpansion(depRow(indep,:), INPUT);

        % --> immediately apply the pruning to reduce memory load
        lnext = applyPruning_tiss(lnext, INPUT);

        % --> apply the pruning on VINF. decreasing in the ENDGAME
        STRUC(indep).LEGSnext = applyPruning_tissEndgame(lnext, INPUT);

    end
    STRUC(cellfun(@isempty,{STRUC.LEGSnext})) = [];
    LEGSnext = cell2mat({STRUC.LEGSnext}');

else
    LEGSnext = [];
end

end
