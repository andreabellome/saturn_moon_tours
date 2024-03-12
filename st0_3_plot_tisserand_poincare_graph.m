
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%%

% --> set the constants
idcentral  = 6; % --> central body (Saturn in this case)
idMoon     = 1; % --> flyby body (Enceladus in this case)

% --> norm. var. CR3BP
strucNorm = wrapNormCR3BP(idcentral, idMoon);

% --> plot the Tisserand-Poincarè graph
vinfLevDIM = [ 0.2:0.1:1.5 ]; % --> infinity velocity contours [km/s]
ramaxAdim  = 4;               % --> max. adimensional apoapsis (default: 5)
npoints    = 1e3;             % --> number of points to plot contours

% --> plot the Tisserand-Poincare graph
fig2 = plot_tp_graph(idcentral, idMoon, vinfLevDIM, ramaxAdim, npoints);

% --> adjust the axes accordingly
ylim( [0.5 1.07] );
xlim( [0.9 1.2] );

