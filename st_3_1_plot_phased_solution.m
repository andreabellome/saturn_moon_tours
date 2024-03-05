%% --> CLEAR ALL AND ADD AUTOMATE TO THE PATH

clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));
addpath(genpath([pwd '/Solutions']));

%%

% --> central body (Saturn in this case)
INPUT.idcentral = 6;

% --> load a phased solution
load('SOLUTION_PHASING.mat');

indsol = 5; % --> select a specific phased solution

% --> extract the info
t0        = SOLUTION_PHASING(indsol).t0;
PATHph    = SOLUTION_PHASING(indsol).PATHph;
PATHphNew = SOLUTION_PHASING(indsol).PATHphNew;

% --> plot the phasing solution
[VILTstruc, TOUR, fig0] = extractVILTstrucPhasedAndPlot(PATHphNew, INPUT, t0, 1);

% --> save in Images folder with a user-specified name
nameTraj = [ pwd '/AUTOMATE/Images/traj_phased_solution' ];
exportgraphics(fig0, [nameTraj '.png'], 'Resolution', 800);



