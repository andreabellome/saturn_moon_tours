function [INPUT, path, seq, transf] = ...
    generateVILTdatabaseRefSolution(PATHph, indPhase, ...
    vinflevPrev, idcentral, tofFB, tofDSM)

% DESCRIPTION
% This function generates a new database with information (e.g., on
% infinity velocities) coming from a solution of the phasing problem with
% Lambert arcs, around a specific moon tour phase.
% 
% INPUT
% - PATHph : structure with a specific moon tour. Each row is a moon phase.
%            The structure has the following fields: 
%            - path : matrix with tour on specific phase. 
%            - dvPhase : DV total for the given phase [km/s]
%            - tofPhase : time of flight for the given phase [days]
%            - dvOI     : DV for orbit insertion only valid for the last
%            phase (see also orbitInsertion.m)
% - indPhase : index for selecting a moon phase, i.e., a row of PATHph
% - vinflevPrev : list with infinity velocities at the moon phase coming
%                 from solutions of phasing problem at the previous phase
%                 [km/s]
% - idcentral : ID of the central body (see constants.m)
% - tofFB     : min. days between two flybys
% - tofDSM    : min. days between flyby and manoeuvre
% 
% OUTPUT
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
% 
% -------------------------------------------------------------------------

if nargin == 4
    tofFB  = 0;
    tofDSM = 0;
elseif nargin == 5
    if isempty(tofFB)
        tofFB = 0;
    end
    tofDSM = 0;
elseif nargin == 6
    if isempty(tofFB)
        tofFB = 0;
    end
    if isempty(tofDSM)
        tofDSM = 0;
    end
end

INPUT.tofFB  = tofFB;
INPUT.tofDSM = tofDSM;

% --> extract the info of the current moon phase
[path, seq, ~, ~, vinfs, transf, ~, tolDVleg, vinflevels] =...
    extractInfoPathPhase(PATHph, indPhase);

[~, fullName] = planet_names_GA( path(2,1), idcentral);
phaseName = [ 'COMPUTING PHASE: ' fullName ' \n' ];
fprintf(phaseName);
fprintf( 'Generating new database... \n' );

% --> construct the new database around the reference solution
pl                       = seq(1);
INPUT.idcentral          = idcentral;
INPUT.IDS                = seq(1);
INPUT.allowed_geometries = [88 81 18 11];
INPUT.exterior_interior  = [ -1, 1 ];
INPUT.tolDV_leg          = tolDVleg + 0.05;
INPUT.vinflevels         = unique([vinflevels vinflevPrev]);
if indPhase == 5 % --> Enceladus phase
    resonances               = unique( path(2:end,4:5), 'rows', 'stable' );
else
    resonances               = unique( path(2:end-1,4:5), 'rows', 'stable' );
end
LEGSvilts                = wrap_generateVILTSall(pl, INPUT, resonances, 1);
vinflevels               = INPUT.vinflevels;

% --> only keep those that are in the reference solution
indtosave = zeros(200e3, 1);
ind       = 1;
for indt = 1:size(transf,1)
    
%     indxs = find(LEGSvilts(:,2) == transf(indt,1) & LEGSvilts(:,3) == transf(indt,2) &...
%                 LEGSvilts(:,4) == transf(indt,3) & LEGSvilts(:,5) == transf(indt,4) & ...
%                 LEGSvilts(:,6) == transf(indt,5));

    indxs = find(LEGSvilts(:,4) == transf(indt,3) & LEGSvilts(:,5) == transf(indt,4));

    indtosave(ind:ind-1+length(indxs),:) = indxs;
    ind = ind + length(indxs);

end
indtosave(indtosave == 0,:) = [];
LEGSvilts = LEGSvilts(indtosave,:);

% --> find intersections and DELTA max.
IDS                = unique(seq);
vinflevels         = unique([ vinflevels, unique( [ vinfs(end,2) vinfs(end,2)-0.05:0.02:vinfs(end,2)+0.05 ] ) ]);
LEGS_inter         = findIntersectionPlanets(IDS, vinflevels, IDS, vinflevels, INPUT.idcentral);
DELTA_MAX          = findDeltaMaxPlanets(IDS, vinflevels, INPUT.idcentral);
RES                = findResonances(IDS, vinflevels, INPUT.idcentral);
INPUT.LEGSvilts    = LEGSvilts;
INPUT.LEGS_inter   = LEGS_inter;
INPUT.DELTA_MAX    = DELTA_MAX;
INPUT.IDS          = IDS;
INPUT.RES          = RES;
INPUT.vinflevels   = vinflevels;
INPUT.vinfDepOPTS  = [0 Inf];
if indPhase == 5 % --> Enceladus phase
    INPUT.h            = 100;
    INPUT.vinfArrOPTS  = [0 0.25];
    INPUT.costFunction = @(LEGSnext) costFunctionTiss_endgameOI(LEGSnext, INPUT.idcentral, seq(end), INPUT.h);
else
    INPUT.vinfArrOPTS  = [0 Inf];
    INPUT.costFunction = @(LEGSnext) costFunctionTiss(LEGSnext);
end
INPUT.VILTS        = 1;
INPUT.tolDVmax     = Inf;
INPUT.tofdmax      = Inf;
INPUT.decrease     = 1;
INPUT.opt          = 2;
INPUT.BW           = Inf;

% --> remove repeated resonances
LEGSc           = INPUT.LEGSvilts;
LEGSc(:,3)      = [];
[~,IA]          = uniquetol(LEGSc, 1e-10, "ByRows", true);
INPUT.LEGSvilts = INPUT.LEGSvilts(IA,:);
clear LEGSc IA;

fprintf( 'Done! \n' );

end
