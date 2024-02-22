%% --> CLEAR ALL AND ADD AUTOMATE TO THE PATH

clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

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
load('outputParetoFront_noOpCon.mat');
indo   = 1;
PATHph = dividePathPhases_tiss(reshape(outputParetoFront(indo).LEGS(1,:), 12, [])', INPUT);

%% --> PHASING

% --> select a grid of initial tour dates and step size
step = 1; % --> step size [days]
TT0  = date2mjd2000( [2035 1 1 0 0 0] ):step:date2mjd2000( [2035 1 31 0 0 0] );

% --> iterate over the initial tour dates
for indtt = 1:length(TT0)

    fprintf('Computing date %d out of %d \n', [indtt, length(TT0)]);

    t0 = TT0(indtt); % --> initial tour date

    try
        
        % --> Step 2: find new database around the reference solution
        indPhase                   = 1;  % --> 1. Titan phase, 2. Rhea phase, 3. Dione phase, 4. Thetys phase, 5. Enceladus phase
        vinflevPrev                = []; % --> empty, since at Titan there are no previous legs
        [INPUT, path, seq, transf] = ...
            generateVILTdatabaseRefSolution(PATHph, indPhase, vinflevPrev,...
            idcentral, tofFB, tofDSM);
        % --> end Step 2: find new database around the reference solution
        
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
        
        % --> Step 5: take the output and find common nodes
        outputNext      = outLineByLine(outputNext);
        [~, outputNext] = apply_MODP_outNext(outputNext);
        LEGS            = cell2mat({outputNext.LEGS}');
        checkPhasingIsCorrect(LEGS, INPUT, t0, inphasing); % --> check the phasing has been done correctly
        % --> end Step 5: take the output and find common nodes
        
        % --> Step 6: check solar conjunction (flybys)
        INPUT.checkSolar = checkSolar;
        INPUT.pl1        = 3; % --> check solar conjunction with Earth
        INPUT.phaselim   = deg2rad(175);
        LEGS             = checkSolarConjunctionFlyby(LEGS, INPUT, inphasing);
        % --> end Step 6: take the output and find common nodes
        
        % NOW DO THE SAME FOR ALL THE SUCCESSIVE MOONS' PHASES

        %% --> Rhea phase
        
        % --> create the new database around the reference solution for the new phase
        indPhase                   = 2;                      % --> 1. Titan phase, 2. Rhea phase, 3. Dione phase, 4. Thetys phase, 5. Enceladus phase
        vinflevPrev                = unique(LEGS(:,end-2))'; % --> these are the infinty velocities at the new moon
        [INPUT, path, seq, transf] = ...
            generateVILTdatabaseRefSolution(PATHph, indPhase, ...
            vinflevPrev, idcentral, tofFB, tofDSM);
        
        % --> explore the new database
        INPUT.pldep   = seq(1);
        INPUT.plarr   = seq(end);
        INPUT.maxlegs = size(path,1)-1;
        output2       = exploreTisserandGraph(LEGS, INPUT, transf); % --> explore Tisserand graph from previous legs
        
        % --> apply BW on output2
        output2 = MODP_MOBS_phasing(output2, bw, INPUT);
        
        % --> solve the phasing with the next moon
        inphasing.perct  = 2/100;
        inphasing.toflim = [ 5 25 ];
        inphasing.maxrev = 30;
        inphasing.toldv  = 0.1;
        
        LEGS        = cell2mat({output2.LEGS}');
        seqph       = [ path(end,3) path(end,1) ];
        INPUT.t0    = t0; % --> starting epoch of the whole tour
        outputNext2 = solvePhasingSatMoons(LEGS, INPUT, seqph, inphasing); % --> solve the phasing
        
        % --> reconstruct the full path
        outputNext2      = outLineByLine(outputNext2);
        [~, outputNext2] = apply_MODP_outNext(outputNext2);
        LEGS             = cell2mat({outputNext2.LEGS}');
        LEGS             = uniquetol( LEGS, 1e-6, 'lowest', 'ByRows', true );
        checkPhasingIsCorrect(LEGS, INPUT, t0, inphasing); % --> check the phasing has been done correctly
        
        % --> check Solar conjunction
        INPUT.checkSolar = checkSolar;
        INPUT.pl1        = 3; % --> check solar conjunction with Earth
        INPUT.phaselim   = deg2rad(175);
        LEGS             = checkSolarConjunctionFlyby(LEGS, INPUT, inphasing);
        
        %% --> Dione phase
        
        % --> create the new database around the reference solution for the new phase
        indPhase                   = 3;                      % --> 1. Titan phase, 2. Rhea phase, 3. Dione phase, 4. Thetys phase, 5. Enceladus phase
        vinflevPrev                = unique(LEGS(:,end-2))'; % --> these are the infinty velocities at the new moon
        [INPUT, path, seq, transf] = ...
            generateVILTdatabaseRefSolution(PATHph, indPhase, vinflevPrev, idcentral, tofFB, tofDSM);
        
        % --> explore the new database
        INPUT.pldep   = seq(1);
        INPUT.plarr   = seq(end);
        INPUT.maxlegs = size(path,1)-1;
        output2       = exploreTisserandGraph(LEGS, INPUT, transf); % --> explore Tisserand graph from previous legs
        
        % --> apply BW on output2
        output2 = MODP_MOBS_phasing(output2, bw, INPUT);
        
        % --> solve the phasing with the next moon
        inphasing.perct  = 2/100;
        inphasing.toflim = [ 5 25 ];
        inphasing.maxrev = 30;
        inphasing.toldv  = 0.05;
        
        LEGS       = cell2mat({output2.LEGS}');
        seqph      = [ path(end,3) path(end,1) ];
        INPUT.t0   = t0; % --> starting epoch of the phase
        outputNext2 = solvePhasingSatMoons(LEGS, INPUT, seqph, inphasing);
        
        % --> reconstruct the full path
        outputNext2      = outLineByLine(outputNext2);
        [~, outputNext2] = apply_MODP_outNext(outputNext2);
        LEGS             = cell2mat({outputNext2.LEGS}');
        checkPhasingIsCorrect(LEGS, INPUT, t0, inphasing); % --> check the phasing has been done correctly
        
        % --> check Solar conjunction
        INPUT.checkSolar = checkSolar;
        INPUT.pl1        = 3; % --> check solar conjunction with Earth
        INPUT.phaselim   = deg2rad(175);
        LEGS             = checkSolarConjunctionFlyby(LEGS, INPUT, inphasing);
        
        %% --> Thetys phase
        
        % --> create the new database around the reference solution for the new phase
        indPhase                   = 4;                   % --> 1. Titan phase, 2. Rhea phase, 3. Dione phase, 4. Thetys phase, 5. Enceladus phase
        vinflevPrev                = unique(LEGS(:,end-2))'; % --> these are the infinty velocities at the new moon
        [INPUT, path, seq, transf] = ...
            generateVILTdatabaseRefSolution(PATHph, indPhase, vinflevPrev, idcentral, tofFB, tofDSM);
        
        % --> explore the new database
        INPUT.pldep   = seq(1);
        INPUT.plarr   = seq(end);
        INPUT.maxlegs = size(path,1)-1;
        
        output2       = exploreTisserandGraph(LEGS, INPUT, transf);        % --> explore Tisserand graph from previous legs
        
        % --> apply BW on output2
        output2 = MODP_MOBS_phasing(output2, bw, INPUT);
        
        % --> solve the phasing with the next moon
        inphasing.perct  = 2/100;
        inphasing.toflim = [ 5 25 ];
        inphasing.maxrev = 30;
        inphasing.toldv  = 0.05;
        
        LEGS        = cell2mat({output2.LEGS}');
        seqph       = [ path(end,3) path(end,1) ];
        INPUT.t0    = t0; % --> starting epoch of the phase
        outputNext2 = solvePhasingSatMoons(LEGS, INPUT, seqph, inphasing);
        
        % --> reconstruct the full path
        outputNext2      = outLineByLine(outputNext2);
        [~, outputNext2] = apply_MODP_outNext(outputNext2);
        LEGS             = cell2mat({outputNext2.LEGS}');
        checkPhasingIsCorrect(LEGS, INPUT, t0, inphasing); % --> check the phasing has been done correctly
        
        % --> check Solar conjunction
        INPUT.checkSolar = checkSolar;
        INPUT.pl1        = 3; % --> check solar conjunction with Earth
        INPUT.phaselim   = deg2rad(175);
        LEGS             = checkSolarConjunctionFlyby(LEGS, INPUT, inphasing);
        
        %% --> Enceladus phase
        
        % --> create the new database around the reference solution for the new phase
        indPhase                   = 5;                      % --> 1. Titan phase, 2. Rhea phase, 3. Dione phase, 4. Thetys phase, 5. Enceladus phase
        vinflevPrev                = unique(LEGS(:,end-2))'; % --> these are the infinty velocities at the new moon
        [INPUT, path, seq, transf] = ...
            generateVILTdatabaseRefSolution(PATHph, indPhase, vinflevPrev, idcentral, tofFB, tofDSM);
        
        % --> explore the new database
        INPUT.pldep   = seq(1);
        INPUT.plarr   = seq(end);
        INPUT.maxlegs = size(path,1)-1;
        
        output2       = exploreTisserandGraph(LEGS, INPUT, transf);        % --> explore Tisserand graph from previous legs
        outputNext    = outLineByLine(output2);
        
        % --> check Solar conjunction
        INPUT.checkSolar     = checkSolar;
        INPUT.pl1            = 3; % --> check solar conjunction with Earth
        INPUT.phaselim       = deg2rad(175);
        [LEGS, indtodel]     = checkSolarConjunctionFlyby(LEGS, INPUT, inphasing);
        outputNext(indtodel) = [];
        
        %%
        
        % --> compute the orbit insertion manoeuvre
        for indou = 1:length(outputNext)
            outputNext(indou).dvOI = orbitInsertion(INPUT.idcentral, INPUT.plarr, ...
                outputNext(indou).vinfa, INPUT.h);
        end
        
        dvtot  = cell2mat({outputNext.dvtot}');
        toftot = cell2mat({outputNext.toftot}');
        vinfa  = cell2mat({outputNext.vinfa}');
        dvOI   = cell2mat({outputNext.dvOI}');
        dvSUM  = dvtot+dvOI;
        
        % --> extract the min. DV path
        [minDV, row] = min( dvSUM );
        tofminDV     = toftot(row);
        path         = reshape(outputNext(row).LEGS(1,:), 12, [])';
        dvpath       = sum( path(:,end-1) );
        tofpath      = sum( path(:,end) );
        
        % --> divide the path in different moon phases
        PATHphNew = dividePathPhases_tiss(path, INPUT);

        % --> save the solution
        PATHph(end).dvOI = orbitInsertion(INPUT.idcentral, ...
            PATHph(end).path(end,1), PATHph(end).path(end,10), INPUT.h);
        SOLUTION_PHASING(indtt).t0         = t0;
        SOLUTION_PHASING(indtt).PATHph     = PATHph;
        SOLUTION_PHASING(indtt).PATHphNew  = PATHphNew;
        SOLUTION_PHASING(indtt).outputNext = outputNext;

        fprintf('Phasing solution found! \n');

    catch

    end

end



