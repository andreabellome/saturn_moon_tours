%% --> select the INPUT

clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%%

% % --> parallel options
% delete(gcp('nocreate'));
% numWorkers = 6;
% parpool(numWorkers);

dtCode = tic;

% --> set up the search space
idcentral          = 6;                % --> central body (Saturn in this case)
IDS                = [5 4 3 2 1];      % --> planets IDs (Saturn moons in this case)
exterior_interior  = [+1 -1];          % --> +1 is exterior VILT, -1 is interior VILT
allowed_geometries = [ 88 81 18 11 ];  % --> allowed geometries for VILT
tolDV_leg          = 0.1;              % --> max. DSM magnitude (km/s)
tolDVmax           = 0.5;              % --> max. DSMtot magnitude (km/s)       
VILTS              = 1;                % --> (1) compute VILTS, (0) do not compute VILTS
vinfDepOPTS        = [ 0 3 ];          % --> min./max. departing infinity velocity (km/s)
vinfArrOPTS        = [ 0 3 ];          % --> min./max. arrival infinity velocity (km/s) 
pldep              = 5;                % --> departing planet/moon
plarr              = 4;                % --> arrival planet/moon
maxlegs            = 3;                % --> max. number of legs

tofDSM = 0; % --> min. days between flyby and manoeuvre
tofFB  = 0; % --> min. days between two flybys

% --> vinf levels (km/s)
vinfMinMax  = [ 1.35	1.46
                0.850	1.85
                0.750	1
                0.650	0.800
                0.200	0.800 ];
stepSize    = 0.05; % --> vinf step size (km/s)

%% --> generate database of VILTs transfers

STRUC = struct( 'next_nodes', cell(1,length(IDS)) );
parfor ind = 1:length(IDS)
    
    ind

	% --> this line simply re-writes the input parameters accordingly
    inpt(ind) = prepareINPUTdatabase(idcentral, allowed_geometries, ...
        exterior_interior, tolDV_leg, vinfMinMax(ind,1), vinfMinMax(ind,2), ...
        stepSize, tofDSM, tofFB);

    pl                    = IDS(ind);
    next_nodes            = wrap_generateVILTSall(pl, inpt(ind));
    STRUC(ind).next_nodes = next_nodes;

end
LEGSvilts = cell2mat({STRUC.next_nodes}');

%% --> generate database of INTERSECTIONS and of MAX. DEFLECTION

vinflevels               = uniquetol(cell2mat({inpt.vinflevels}'), 1e-7);

INPUT.idcentral          = inpt(1).idcentral;
INPUT.allowed_geometries = inpt(1).allowed_geometries;
INPUT.exterior_interior  = inpt(1).exterior_interior;
INPUT.tolDV_leg          = inpt(1).tolDV_leg;
INPUT.tolDVmax           = tolDVmax;
INPUT.vinflevels         = vinflevels;
INPUT.maxlegs            = maxlegs;
INPUT.opt                = opt;
INPUT.tofdmax            = tofdmax;
INPUT.BW                 = BW;

% --> find all possible intersections between different SS planets
LEGS_inter = findIntersectionPlanets(IDS, vinflevels, IDS, vinflevels, idcentral);

% --> find all possible max. deflections for SS planets
DELTA_MAX  = findDeltaMaxPlanets(IDS, vinflevels, idcentral);

% --> find all possible resonant orbits for planets and contours
RES        = findResonances(IDS, vinflevels, idcentral);

INPUT.VILTS       = VILTS;
INPUT.LEGSvilts   = LEGSvilts;
INPUT.LEGS_inter  = LEGS_inter;
INPUT.DELTA_MAX   = DELTA_MAX;
INPUT.IDS         = IDS;
INPUT.RES         = RES;
INPUT.vinflevels  = vinflevels;
INPUT.vinfDepOPTS = vinfDepOPTS;
INPUT.vinfArrOPTS = vinfArrOPTS;
INPUT.pldep       = pldep;
INPUT.plarr       = plarr;

dtCode = toc(dtCode); % --> computational time

% --> choose a name and save the databases
save -v7.3 database_noOpCon
