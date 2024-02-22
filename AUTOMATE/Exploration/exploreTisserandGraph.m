function output = exploreTisserandGraph(LEGS, INPUT, seqTransfer)

% DESCRIPTION
% This is the function that performs the Tisserand exploration with Beam
% Search (BS) and Dynamic Programming (DP).
% 
% INPUT
% - LEGS : matrix where each row is similar to 'next_nodes' rows (see
%          generateVILTSall.m), containing info on departing node.
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
%           - h            : altitude of circular orbit for orbit insertion
%           manoeuvre [km]
%           
% - seqTransfer : optional input. This is a tour that the user can specify.
%                 If specified, the exploration is run to find this
%                 specific tour. 
% 
% OUTPUT
% - output : structure where each rows contains tours with same number of
%            flbys. It has the following fields: 
%            - LEGS : matrix containing the tours. Each row is a tour. Each tour
%              is made by 'next_nodes' rows (see generateVILTSall.m) one
%              after the other.
%            - dvtot : column vector containing the overall DV for the
%            tours [km/s] 
%            - toftot : column vector containing the overall TOF for the
%            tours [days]
%            - vinfa : column vector containing the arrival infinity
%            velocity for the tours [km/s]
%
% -------------------------------------------------------------------------

% --> check if a sequence is specified
if nargin == 2
    seqTransfer = [];
end

output = struct( 'LEGS', cell(1, INPUT.maxlegs) );
for indl = 1:INPUT.maxlegs
    
    fprintf('Tisserand exploration: computing leg %d out of %d \n', [indl, INPUT.maxlegs]);

    INPUT.indl = indl;

    %%

    % --> expand the tree
    LEGSnext = wrapNodeExpansion(LEGS, INPUT);

    %%

    % --> only save those that are specified in the seqTransfer
    LEGSnext = extractLEGSTransf(LEGSnext, seqTransfer, INPUT);

    %%

    % --> apply pruning (DV max., TOF max., ALPHA decr.)
    LEGSnext = applyPruning_tiss(LEGSnext, INPUT);
    
    % --> sort w.r.t. the total DV and then TOF
    LEGSnext = sortDVtof(LEGSnext, INPUT);

    %%

    % --> start: perform SODP-SOBS or MODP-MOBS
    if INPUT.opt == 1
        LEGSnext = apply_SOBS_tiss(LEGSnext, INPUT); % --> SOBS
    else
        LEGSnext = apply_MODP_tiss(LEGSnext, INPUT); % --> MODP
        LEGSnext = apply_MOBS_tiss(LEGSnext, INPUT); % --> MOBS
    end
    % --> end: perform SODP-SOBS or MODP-MOBS

%%
    
    % --> check if some paths arrived to the target planet, if so save them
    % and remove from the current legs
    [LEGSnext, output(indl).LEGS] = checkArrived(LEGSnext, INPUT);

    if ~isempty(LEGSnext)
        LEGS = LEGSnext;
    else
        break
    end

end
output(cellfun(@isempty,{output.LEGS})) = [];

% --> start: post-process output
if ~isempty(output)
    for indou = 1:length(output)
        
        legs                   = output(indou).LEGS;
        [dvtot, toftot, vinfa] = costFunctionTiss(legs);
        output(indou).dvtot    = dvtot;
        output(indou).toftot   = toftot;
        output(indou).vinfa    = vinfa;

    end
end
% --> end: post-process output

end
