%% --> CLEAR ALL AND ADD AUTOMATE TO THE PATH

clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));
addpath(genpath([pwd '/Solutions']));

%% --> INPUT

% --> Step 0: select the central body and the input
idcentral  = 6; % --> Saturn
mu         = constants(idcentral, 1);
bw         = 100; % --> Beam Width (suggested value: 100)
checkSolar = 0;   % --> check solar conjunction events (put 1 to check)
tofDSM     = 0;   % --> min. days between flyby and manoeuvre
tofFB      = 0;   % --> min. days between two flybys

INPUT.idcentral = idcentral;
INPUT.h         = 100; % --> altitude for orbit insertion [km]

% --> Step 1: load the Pareto front and select a tour from it
% load("PATHph_noOpCon.mat");
load('outputParetoFront_noOpCon.mat');
indo   = 1;
PATHph = dividePathPhases_tiss(reshape(outputParetoFront(indo).LEGS(1,:), 12, [])', INPUT);

% --> select a grid of initial tour dates and step size
step = 0.5; % --> step size [days]
TT0  = date2mjd2000( [2030 2 1 0 0 0] ):step:date2mjd2000( [2030 2 28 0 0 0] );

indtt = 1; % --> select a date

fprintf('Computing date %d out of %d \n', [indtt, length(TT0)]);

t0 = TT0(indtt); % --> initial tour date

%%

% --> Step 2: find new database around the reference solution
indPhase                   = 1;  % --> 1. Titan phase, 2. Rhea phase, 3. Dione phase, 4. Thetys phase, 5. Enceladus phase
vinflevPrev                = []; % --> empty, since at Titan there are no previous legs
[INPUT, path, seq, transf] = ...
    generateVILTdatabaseRefSolution(PATHph, indPhase, vinflevPrev,...
    idcentral, tofFB, tofDSM);
% --> end Step 2: find new database around the reference solution

%%

% --> Step 3: explore the new database
INPUT.pldep   = seq(1);
INPUT.plarr   = seq(end);
INPUT.maxlegs = size(path,1)-1;
depNode       = [ path(1,1) path(1,9:10) ];
LEGS          = depNode2depRows(depNode);
output2       = exploreTisserandGraph(LEGS, INPUT, transf); % --> explore Tisserand graph
% --> end Step 3: explore the new database

% --> start Step 3.1: apply BW on output2
output2 = MODP_MOBS_phasing(output2, bw, INPUT);
% --> end Step 3.1: apply BW on output2

%%

% --> Step 4: for every solution found, solve the phasing problem
inphasing.perct  = 1.5/100;   % --> percentage of orbital period of next moon for step size in TOF
inphasing.toflim = [ 10 45 ]; % --> min./max. TOFs [days]
inphasing.maxrev = 30;        % --> max. revs. for Lambert problem
inphasing.toldv  = 0.1;       % --> max. DV defect [km/s]

LEGS       = cell2mat({output2.LEGS}');
seqph      = [ path(end,3) path(end,1) ]; % --> moon sequence to solve the phasing
INPUT.t0   = t0;
outputNext = solvePhasingSatMoons(LEGS, INPUT, seqph, inphasing);
% --> end Step 4: for every solution found, solve the phasing problem

%%

% --> Step 5: take the output and find common nodes
outputNext      = outLineByLine(outputNext);
[~, outputNext] = apply_MODP_outNext(outputNext);
LEGS            = cell2mat({outputNext.LEGS}');
checkPhasingIsCorrect(LEGS, INPUT, t0, inphasing); % --> check the phasing has been done correctly
% --> end Step 5: take the output and find common nodes

%%

% --> Step 6: check solar conjunction (flybys)
INPUT.checkSolar = checkSolar;
INPUT.pl1        = 3;             % --> check solar conjunction with Earth (see constants.m)
INPUT.phaselim   = deg2rad(175);  % --> limit for conjunction event to occur
LEGS             = checkSolarConjunctionFlyby(LEGS, INPUT, inphasing);
% --> end Step 6: take the output and find common nodes

%% --> Rhea phase

% --> create the new database around the reference solution for the new phase
indPhase                   = 2;                      % --> 1. Titan phase, 2. Rhea phase, 3. Dione phase, 4. Thetys phase, 5. Enceladus phase
vinflevPrev                = unique(LEGS(:,end-2))'; % --> these are the infinty velocities at the new moon
[INPUT, path, seq, transf] = ...
    generateVILTdatabaseRefSolution(PATHph, indPhase, ...
    vinflevPrev, idcentral, tofFB, tofDSM);