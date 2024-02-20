%% --> CLEAR ALL AND ADD AUTOMATE TO THE PATH

clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%% --> DATABASE AND INPUT

% --> load the database
load('wksp_test_cleaned_noOp.mat');

% --> clear variables that are not needed
clearvars -except INPUT;

% --> select names to save the variables
nameParetoFront = 'outputParetoFront_noOpCon';
nameBestDVpath  = 'PATHph_noOpCon';

% --> define the INPUT
INPUT.opt           = 2;     % --> (1) SODP, (2) MODP
INPUT.BW            = Inf;   % --> Beam Width (suggested value: Inf)
INPUT.decrease      = 1;     % --> (1) IN Saturn System, (0) OUT Saturn System
INPUT.tolDVmax      = Inf;   % --> max. DV for the whole tour (suggested value: Inf)
INPUT.tolDV_leg     = 0.05;  % --> max. DV between two flybys (suggested value: 0.05 km/s)
INPUT.tofdmax       = 1100;  % --> max. TOF for the whole tour (suggested value: 1100 days)

% --> prune the LEGSvilts
INPUT = pruneINPUTlegsvilts(INPUT);

%% --> TITAN PHASE

% --> define the cost function 
INPUT.costFunction = @(LEGSnext) costFunctionTiss(LEGSnext);

% --> define the input for the phase
INPUT.pldep       = 5;       % --> departing planet/moon
INPUT.plarr       = 4;       % --> arrival planet/moon
INPUT.maxlegs     = 3;       % --> maximum number of legs per moon phase
INPUT.vinfArrOPTS = [0 Inf]; % --> v-infinity bounds for the plarr encounter (suggested value: [0 Inf])

% --> select the departing nodes
depNode  = [ 5 deg2rad(50) 1.460 ];
LEGS     = depNode2depRows(depNode);

dtCode = tic; % --> start to measure the efficiency of the code here

% --> explore Tisserand graph
output = exploreTisserandGraph(LEGS, INPUT);

% --> take the output and find common nodes
outputNext = outLineByLine(output);

% --> prune
outputNext = pruneOutputNext(outputNext, INPUT);

% --> apply MODP on outputNext
[LEGS, outputNext] = apply_MODP_outNext(outputNext);

%% --> RHEA PHASE

INPUT.pldep   = 4;   % --> departing planet/moon
INPUT.plarr   = 3;   % --> arrival planet/moon
INPUT.maxlegs = 17;

% --> explore Tisserand graph
output2    = exploreTisserandGraph(LEGS, INPUT);

% --> reconstruct the full path
outputNext = reconstructFullOutput(outputNext, output2, INPUT);

% --> apply MODP on outputNext
[LEGS, outputNext] = apply_MODP_outNext(outputNext);

%% --> DIONE PHASE

INPUT.pldep   = 3;   % --> departing planet/moon
INPUT.plarr   = 2;   % --> arrival planet/moon
INPUT.maxlegs = 13;

% --> explore Tisserand graph
output2    = exploreTisserandGraph(LEGS, INPUT);

% --> reconstruct the full path
outputNext = reconstructFullOutput(outputNext, output2, INPUT);

% --> apply MODP on outputNext
[LEGS, outputNext] = apply_MODP_outNext(outputNext);

%% --> THETYS PHASE

INPUT.pldep       = 2;   % --> departing planet/moon
INPUT.plarr       = 1;   % --> arrival planet/moon
INPUT.maxlegs     = 13;

% --> explore Tisserand graph
output2    = exploreTisserandGraph(LEGS, INPUT);

% --> reconstruct the full path
outputNext = reconstructFullOutput(outputNext, output2, INPUT);

% --> apply MODP on outputNext
[LEGS, outputNext] = apply_MODP_outNext(outputNext);

%% --> ENCELADUS phase

INPUT.h            = 100; % --> circular orbit altitude around Enceladus
INPUT.pldep        = 1;   % --> departing planet/moon
INPUT.plarr        = 1;   % --> arrival planet/moon
INPUT.maxlegs      = 15;
INPUT.vinfArrOPTS  = [ 0 0.25 ]; % --> this is important to be specified
INPUT.costFunction = @(LEGSnext) costFunctionTiss_endgameOI(LEGSnext, INPUT.idcentral, INPUT.plarr, INPUT.h);
