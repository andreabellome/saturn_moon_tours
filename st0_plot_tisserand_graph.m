%% --> CLEAR ALL AND ADD AUTOMATE TO THE PATH

clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%% --> Plot contours of multiple moons

% --> set-up the system (Saturn in this case)
idcentral  = 6;             % --> Saturn is the central body (see constants.m)
IDS        = [ 1 2 3 4 5 ]; % --> Saturn moon IDs (see constants.m)
vinflevels = 0.1:0.1:3;     % --> infinity velocity levels [km/s]

% --> plot the Tisserand contours and add legend
nametosave = 'tisserand_graph_saturn_moons';
plotContours(IDS, vinflevels, idcentral, 0, 1, 1);
exportgraphics(gca, [pwd '/AUTOMATE/Images/' nametosave '.png'], 'Resolution', 800);

%% --> plot contours of a single moon with resonances

id = 5; % --> Titan (see constants.m)

% --> plot the Tisserand contours and add legend
plotContours(id, vinflevels, idcentral);

% --> find resonant orbits
RES = findResonances(id, vinflevels, idcentral);

% --> plot resonances
plotResonances(IDS, RES, [], idcentral, 1);

nametosave = 'tisserand_graph_saturn_single_moon_resonances';
exportgraphics(gca, [pwd '/AUTOMATE/Images/' nametosave '.png'], 'Resolution', 800);
