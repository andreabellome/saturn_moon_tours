function outputNext = solvePhasingSatMoons(LEGS, INPUT, seqph, inphasing)

% DESCRIPTION
% This function is used to solve the phasing problem using Lambert arcs and
% DV defect manoeuvres for a set of moon tous and given options for Lambert
% solver. Parallel is used and recommended for speed purposes. If not
% needed, then modify the line 'parfor indl = 1:size(LEGS,1)'.
%
% INPUT
% - LEGS : matrix containing the tours. Each row is a tour. Each tour
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
%           - h            : altitude of circular orbit for orbit insertion
%           manoeuvre [km]
%           - tofFB     : min. days between two flybys
%           - tofDSM    : min. days between flyby and manoeuvre 
% - seqph : 1x2 vector with IDs of initial and final moons to solve the
%           phasing problem (see constants.m)
% - inphasing : structure with the input for the phasing problem to be
%               solved with Lambert arcs. The following fields are
%               requested: 
%        - path   : matrix containing the tour. Each row is made by 'next_nodes'
%           rows (see generateVILTSall.m).
%        - idcentral : ID of the central body (see constants.m)
%        - seq    : 1x2 vector with initial and final moon IDs (see
%        constants.m)
%        - t0     : inital epoch [MJD2000]
%        - perct  : percentage of orbital period of next moon for step size
%        in TOF 
%        - toflim : max. integer number of revolutions for Lambert problem
%        - maxrev : max. integer number of revolutions for Lambert problem
%        - toldv  : max. DV defect [km/s]
%        - maxVinfArr : max. arrival infinity velocity at next moon [km/s]
% 
% OUTPUT 
% - outputNext : structure with the following fields:
%            - LEGS : matrix containing the tours. Each row is a tour. Each tour 
%              is made by 'next_nodes' rows (see generateVILTSall.m) one
%              after the other.
%            - dvtot : column vector containing the overall DV for the
%            tours [km/s] including phasing
%            - toftot : column vector containing the overall TOF for the
%            tours [days] including phasing
%            - vinfa : column vector containing the arrival infinity
%            velocity for the tours [km/s]
%            - lastNode : 1x3 vector with last node for the tour
%                (a node is made by ID of the flyby body (see constants.m),
%                pump angle [rad] and infinity velocity [km/s])
%            - nfb      : number of flybys for the tour 
%            - depNode  : 1x3 vector with departing node for the tour
%                (a node is made by ID of the flyby body (see constants.m),
%                pump angle [rad] and infinity velocity [km/s])
% 
% -------------------------------------------------------------------------


fprintf( 'Solving the phasing problem... \n' );

t0 = INPUT.t0;

% --> iterate the solution of the phasing problem over all the tours
out = struct( 'STRUC', cell(1, size(LEGS,1)) );
parfor indl = 1:size(LEGS,1)
    
    % --> extract the current moon tour
    path = reshape(LEGS(indl,:), 12, [])';

    % --> process the tour
    tofp      = sum(path(:,end));
    t1        = t0 + tofp;
    VILTstruc = pathRowVILTtoState_def(path(end-1,:), t0 + sum(path(1:end-2,end)), INPUT);

    % --> incoming state at the moon and moon state
    statein = [ VILTstruc.rr2 VILTstruc.vva ];
    statega = [ VILTstruc.rr2 VILTstruc.vv2 ];
    
    % --> process the input for solving the phasing problem
    in = writeInPhasing(path, t1, inphasing.perct, inphasing.toflim,...
        inphasing.maxrev, inphasing.toldv, INPUT);
    
    % --> solve the phasing problem with Lambert arcs and defects
    out(indl).STRUC = attachLambertInterMoonSat(statein, statega, in);

end

% --> post-process and update the overall DV and TOF for the tours
% including phasing
strucLegsNew = struct( 'legsnew', cell(1, length(out)) );
for indl = 1:length(out)
    
    legold = LEGS(indl,1:end-12);
    struc  = out(indl).STRUC;
    if ~isempty(struc)
        newLeg = zeros( length(struc),12 );
        for inds = 1:length(struc)
            newLeg(inds,:) = [ seqph(2) struc(inds).types seqph(1) 0 0 NaN struc(inds).alphadep struc(inds).vinfdep struc(inds).alphain struc(inds).vinfin struc(inds).dv struc(inds).tof ];
        end
        strucLegsNew(indl).legsnew = [ legold.*ones( size(newLeg,1), size(legold,2) ) newLeg ];
    end

end

LEGSnext = cell2mat({strucLegsNew.legsnew}');
if isempty(LEGSnext)
    outputNext = [];
    fprintf( 'No phasing solutions with given settings. \n' );
else
    [dvtot, toftot, vinfa] = INPUT.costFunction(LEGSnext);
    lastNode = [ LEGSnext(:,end-11) LEGSnext(:,end-3:end-2) ];
    nfb      = size(LEGSnext,2);
    depNode  = [ LEGSnext(:,1) LEGSnext(:,9:10) ];
    
    outputNext.LEGS     = LEGSnext;
    outputNext.dvtot    = dvtot;
    outputNext.toftot   = toftot;
    outputNext.vinfa    = vinfa;
    outputNext.lastNode = lastNode;
    outputNext.nfb      = nfb;
    outputNext.depNode  = depNode;
end

fprintf( 'Done! \n' );

end
