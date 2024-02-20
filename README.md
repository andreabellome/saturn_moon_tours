# Saturn moon tours using MATLAB
This folder contains AUTOMATE toolbox (100% MATLAB-based) for designing moon tours in Saturn system. AUTOMATE is meant to assess the feasibility of different moon tours using Tisserand graphs (TGs). The tours can include v-infinity leveraging transfers (VILTs), full-resonant and pseudo-resonant transfers, as well as intersections on the Tisserand graphs (i.e., transfer orbits between different moons). This project is the result of a collection of papers and theses. The main references are: Strange et al. [[1]](#1), Takubo et al. [[2]](#2), and Bellome [[3]](#3).

The corresponding Python implementation can be found in ESA's MIDAS tool at:

```bash
https://midas.io.esa.int/midas/api_reference/generated/midas.design.tour.html
```

## Installation & Requirements

To work with AUTOMATE, one can simply clone the repository in the local machine:

```bash
git clone "https://github.com/andreabellome/saturn_moon_tours"
```

Only invited developers can contribute to the folder, and each should create a separate branch, otherwise push requests will not be accepted.

One notices here that a the [MATLAB Optimization Toolbox](https://it.mathworks.com/products/optimization.html) is required for the current version of AUTOMATE. Future developments will eliminate this need.

To run a full exploration of Saturn system, the following recommended system requirements:
+ CPU six-core from 2.6 GHz to 3.6 GHz
+ RAM minimum 16 GB

Python implementation requires less strict requirements, but it also takes more computational time for a full Saturn exploration.

## Usage and test cases

To use the repository, one finds different test scripts. These are listed here:

1. Test script 1: [st0_tisserand_graphs.m](https://github.com/andreabellome/saturn_moon_tours/blob/main/st2_modp_exploration.m), to plot TG for Saturn system
2. Test script 2: [st1_database_generation.m](https://github.com/andreabellome/saturn_moon_tours/blob/main/st1_database_generation.m) to generate databases of VILTs and intersections on TG
3. Test script 3: [st2_modp_exploration.m](https://github.com/andreabellome/saturn_moon_tours/blob/main/st2_modp_exploration.m) to perform a full exploration with DP

More details are provided in the following sections.

### Test script 1: Plot a Tisserand graph for Saturn system

This simple test script is used to plot a Tisserand graph for Saturn system. The reference script is [st0_tisserand_graphs.m](https://github.com/andreabellome/saturn_moon_tours/blob/main/st2_modp_exploration.m).

### Test script 2: Generating databases of VILTs and intersections on Tisserand graph

The reference script described here is: [st1_database_generation.m](https://github.com/andreabellome/saturn_moon_tours/blob/main/st1_database_generation.m). This is used to generate a database of VILTs and intersections on TG for Saturn sytem.

It all starts by clearing the workspace and including the required libraries:

```matlab
%% --> select the INPUT

clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));
```

Then one can uncomment the following lines if parallel computing is preferred:

```matlab
% % --> parallel options
% delete(gcp('nocreate'));
% numWorkers = 6;
% parpool(numWorkers);
```

The following lines set-up the input parameters for computing a database of VILTs. For the terminology, the interested reader is referrd to Strange et al. [[1]](#1) and Bellome [[3]](#3). In particular, for moons' IDs and central body ID one can refer to [constants.m](https://github.com/andreabellome/saturn_moon_tours/blob/main/AUTOMATE/Ephemerides%20%26%20constants/constants.m).


```matlab
dtCode = tic; % --> start counting for computational time

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
```

A for-loop is then launched over the moons' IDs, to generate a database of VILTs with the specified input.

```matlab
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
```

Next step is to generate the databases of: 1) intersections on TG, and 2) the maximum deflection angles at moons for the specified infinity velocities.

```matlab
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

dtCode = toc(dtCode); % --> total computational time
```

Finally, one saves the workspace with a user-defined name (please modify accordingly). Be careful that this name matches the one that is used in next test case (i.e., TG exploration).

```matlab
% --> choose a name and save the databases
save -v7.3 wksp_test_cleaned_noOp
```

With the given options and the recommended system requirements, the overall computational time should be **XXXX seconds**. One is now ready to launch the next test case. 

### Test script 3: Full exploration of Tisserand graph

The tours in Saturn system are assumed to be performed one moon at a time. This is why the following script [st2_modp_exploration.m](https://github.com/andreabellome/saturn_moon_tours/blob/main/st2_modp_exploration.m). is divided in different moon phases.

It all starts by clearing the workspace and including the required libraries:

```matlab
%% --> CLEAR ALL AND ADD AUTOMATE TO THE PATH

clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));
```

The databases are then loaded. Care should be taken, as the name of the .mat file loaded should be the same of the one used in the previous script:

```matlab
%% --> DATABASE AND INPUT

% --> load the database
load('wksp_test_cleaned_noOp.mat');

% --> clear variables that are not needed
clearvars -except INPUT;
```

One can then select names to save the final tour (best DV), and the Pareto front that will be generated:

```matlab
% --> select names to save the variables
nameParetoFront = 'outputParetoFront_noOpCon';
nameBestDVpath  = 'PATHph_noOpCon';
```

The input are then processed (for more details see [pruneINPUTlegsvilts.m](https://github.com/andreabellome/saturn_moon_tours/blob/main/AUTOMATE/Exploration/Pruning/pruneINPUTlegsvilts.m)). As it can be seen, one can select a wide range of different input, depending on the needs:

```matlab
% --> define the INPUT
INPUT.opt           = 2;     % --> (1) SODP, (2) MODP (suggested value: 2)
INPUT.BW            = Inf;   % --> Beam Width (suggested value: Inf)
INPUT.decrease      = 1;     % --> (1) IN Saturn System, (0) OUT Saturn System
INPUT.tolDVmax      = Inf;   % --> max. DV for the whole tour (suggested value: Inf)
INPUT.tolDV_leg     = 0.05;  % --> max. DV between two flybys (suggested value: 0.05 km/s)
INPUT.tofdmax       = 1100;  % --> max. TOF for the whole tour (suggested value: 1100 days)

% --> prune the LEGSvilts
INPUT = pruneINPUTlegsvilts(INPUT);
```

The different moon phases can then be initiated. One assumes to start from an equatorial Saturn orbit crossing Titan at a given infinity velocity [km/s] and pump angle [rad]. This is specified in the following variable `node = [ 5 deg2rad(50) 1.460 ]`. A node is made by the ID of the moon, the pump angle and the infinity velocity at the moon. A cost function is to be specified (see [costFunctionTiss.m](https://github.com/andreabellome/saturn_moon_tours/blob/main/AUTOMATE/Exploration/Cost%20functions/costFunctionTiss.m)).

```matlab
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
```

Tisserand graph exploration can then be launched and the output processed:

```matlab
% --> explore Tisserand graph
output = exploreTisserandGraph(LEGS, INPUT);

% --> take the output and find common nodes
outputNext = outLineByLine(output);

% --> prune
outputNext = pruneOutputNext(outputNext, INPUT);

% --> apply MODP on outputNext
[LEGS, outputNext] = apply_MODP_outNext(outputNext);
```

Variables `LEGS` and `outputNext` are needed for the next moon phase. This is the Rhea phase, that is reported below:

```matlab
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
```

The process is repeated for the other moons, i.e., Dione and Thetys:

```matlab
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
```

At this point, variables `LEGS` and `outputNext` encode moon tours starting at `node = [ 5 deg2rad(50) 1.460 ]` and arriving at Enceladus. The last step remaining is the so-called endgame problem at Enceladus, i.e., a fly-by tour that leverages the infinity velocity to the minimum possible. The search is stopped when the moon is encountered with infinty velocity within the bounds specified in the variable `INPUT.vinfArrOPTS  = [ 0 0.25 ];`.

Another cost function is specified that considers the overall DV to reach Enceladus, plus a contribution due to the orbital insertion around the moon. Please, refer to [costFunctionTiss_endgameOI.m](https://github.com/andreabellome/MRPLP_DACE_python/blob/main/final_mrplp_j2_analytic.py).


```matlab
%% --> ENCELADUS PHASE

INPUT.h            = 100; % --> circular orbit altitude around Enceladus
INPUT.pldep        = 1;   % --> departing planet/moon
INPUT.plarr        = 1;   % --> arrival planet/moon
INPUT.maxlegs      = 15;
INPUT.vinfArrOPTS  = [ 0 0.25 ]; % --> min. and max. v-inf [km] VERY IMPORTANT TO BE SPECIFIED
INPUT.costFunction = @(LEGSnext) costFunctionTiss_endgameOI(LEGSnext, INPUT.idcentral, INPUT.plarr, INPUT.h);

% --> explore Tisserand graph
output2 = exploreTisserandGraph(LEGS, INPUT);

% --> on the last leg, only the Pareto fronts to common nodes are relevant
output2      = outLineByLine(output2);
[~, output2] = apply_MODP_outNext(output2);

% --> reconstruct the full path
outputNext = reconstructFullOutput(outputNext, output2, INPUT);
clear output2 LEGSvilts LEGS_inter LEGSc C DELTA_MAX;

dtCode = toc(dtCode); % --> computational time of the script
```
A post-processing step is added to compute the contribution due to the DV for orbit insertion:

```matlab
% --> compute the orbit insertion manoeuvre
for indou = 1:length(outputNext)
    outputNext(indou).dvOI = orbitInsertion(INPUT.idcentral, INPUT.plarr, ...
        outputNext(indou).vinfa, INPUT.h);
end
```

The variable `outputNext` finally encodes the full set of tours. With the given options and the recommended system requirements, the overall computational time should be **1.5 hours**.

Finally, one can extract the Pareto front for the whole set of tours and plot the preferred trajectories.

```matlab
% --> plot the Pareto front
close all; clc;

% --> extract the info from the set of tours
dvtot  = cell2mat({outputNext.dvtot}');
toftot = cell2mat({outputNext.toftot}');
vinfa  = cell2mat({outputNext.vinfa}');
dvOI   = cell2mat({outputNext.dvOI}');
dvSUM  = dvtot+dvOI;

% --> compute the final Pareo front
pf = paretoQS([ toftot dvSUM ]);
pf = pf';

% --> save the Pareto front
outputParetoFront = outputNext( pf(:,end) );
save(nameParetoFront, 'outputParetoFront', '-v7.3');

% --> plot the Pareto front
fig1 = figure('Color', [1 1 1]);
hold on; grid on;
ylabel('TOF - days'); xlabel('\Deltav - m/s');
plot( dvSUM(pf(:,end)).*1000, toftot(pf(:,end)), 'o', 'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', 'Yellow', 'MarkerSize', 10, ...
    'HandleVisibility', 'off' );

% --> save the Pareto front
exportgraphics(gca, [nameParetoFront '.png'], 'Resolution', 1200);
```

One can then select a desired tour from `outputNext` variable and plot the Tisserand trajectory. The tour is saved in a variable called `PATHph` where each moon phase is specified.

```matlab
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

% --> plot trajectory
INPUT.t0   = date2mjd2000([2033 12 21 0 0 0]);
[fig, dvc] = plotFullPathTraj_tiss(PATHph, INPUT);
```

The variable `PATHph` is then saved in the local folder with the name specified above and the trajectories are plotted.

## References
<a id="1">[1]</a> 
Strange, N. J., Campagnola, S., & Russell R. P. (2010). 
*Leveraging flybys of low mass moons to enable an Enceladus orbiter*.
Advances in the Astronautical Sciences. https://www.researchgate.net/publication/242103688_Leveraging_flybys_of_low_mass_moons_to_enable_an_Enceladus_orbiter.

<a id="2">[2]</a> 
Takubo, Y., Landau, D., & Brian, A. (2022). 
*Automated Tour Design in the Saturnian System*.
33rd AAS/AIAA Space Flight Mechanics Meeting, Austin, Texas, 2023 . https://arxiv.org/abs/2210.14996.

<a id="3">[3]</a> 
Bellome, A. (2023). 
Trajectory Design of Multi-Target Missions via Graph Transcription and Dynamic Programming.
Ph.D. Thesis, Cranfield University. https://dspace.lib.cranfield.ac.uk/handle/1826/20830
