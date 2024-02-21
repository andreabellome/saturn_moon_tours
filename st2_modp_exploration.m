%% --> CLEAR ALL AND ADD AUTOMATE TO THE PATH

clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%% --> DATABASE AND INPUT

% --> load the database
load('database_noOpCon.mat'); % --> this is for scenario without operational constraints

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

% --> explore Tisserand graph
output2 = exploreTisserandGraph(LEGS, INPUT);

% --> on the last leg, only the Pareto fronts to common nodes are relevant
output2      = outLineByLine(output2);
[~, output2] = apply_MODP_outNext(output2);

% --> reconstruct the full path
outputNext = reconstructFullOutput(outputNext, output2, INPUT);
clear output2 LEGSvilts LEGS_inter LEGSc C DELTA_MAX; % --> clear variables that are not needed

dtCode = toc(dtCode); % --> computational time of the script (see also line 43)

% --> compute the orbit insertion manoeuvre
for indou = 1:length(outputNext)
    outputNext(indou).dvOI = orbitInsertion(INPUT.idcentral, INPUT.plarr, ...
        outputNext(indou).vinfa, INPUT.h);
end

%% --> FINAL PARETO FRONT AND PLOTS

% --> plot the pareto front
close all; clc;

takubo   = [ 0.689 721 ];
campag   = [ 0.445 997 ];
strange  = [ 0.734 745 ];
takuboPF = [ 0.360 1090; 0.400 960; 0.450 900; ...
    0.5 855; 0.565 800; 0.6 766; 0.689 721; 0.760 710 ];

dvtot  = cell2mat({outputNext.dvtot}');
toftot = cell2mat({outputNext.toftot}');
vinfa  = cell2mat({outputNext.vinfa}');
dvOI   = cell2mat({outputNext.dvOI}');
dvSUM  = dvtot+dvOI;

pf = paretoQS([ toftot dvSUM ]);
pf = pf';

% --> save the Pareto front
outputParetoFront = outputNext( pf(:,end) );
save(nameParetoFront, 'outputParetoFront', '-v7.3');

fig1 = figure('Color', [1 1 1]);
hold on; grid on;
ylabel('TOF [days]'); xlabel('\Deltav [m/s]');
plot( dvSUM(pf(:,end)).*1000, toftot(pf(:,end)), 'o', 'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', 'Yellow', 'MarkerSize', 10, ...
    'HandleVisibility', 'off' );

plot( campag(1)*1000, campag(2), 's', 'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', 'Red', 'MarkerSize', 10, ...
    'DisplayName', 'Campagnola et al. 2010' );

plot( strange(1)*1000, strange(2), 'o', 'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', 'Magenta', 'MarkerSize', 10, ...
    'DisplayName', 'Strange et al. 2009' );

plot( takuboPF(:,1).*1000, takuboPF(:,2), 'v', 'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', 'Blue', 'MarkerSize', 10, ...
    'DisplayName', 'Pareto front Takubo et al. 2022');

legend( 'Location', 'Best' );

exportgraphics(gca, [nameParetoFront '.png'], 'Resolution', 1200);

%% --> post-processing and plot (2)

% --> extract the min. DV path
[minDV, row] = min( dvtot+dvOI );
tofminDV     = toftot(row);
path         = reshape(outputNext(row).LEGS(1,:), 12, [])';
dvpath       = sum( path(:,end-1) );
tofpath      = sum( path(:,end) );

% --> divide the path in different moon phases
PATHph = dividePathPhases_tiss(path, INPUT);
save(nameBestDVpath, 'PATHph', '-v7.3');

% --> plot trajectory on Tisserand map
plotFullPath_tiss(PATHph, INPUT);



