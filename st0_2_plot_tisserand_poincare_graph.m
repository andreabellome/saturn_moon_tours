
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%%

% --> set the constants
idcentral  = 6; % --> central body (Saturn in this case)
idMoon     = 5; % --> flyby body (Enceladus in this case)

% --> norm. var. CR3BP
strucNorm = wrapNormCR3BP(idcentral, idMoon);

% --> plot the Tisserand-Poincarè graph
vinfLevDIM = [ 0.2:0.1:1.5 ]; % --> infinity velocity contours [km/s]
ramaxAdim  = 4;               % --> max. adimensional apoapsis (default: 5)
npoints    = 1e3;             % --> number of points to plot contours

% --> plot the Tisserand-Poincare graph
fig2 = plot_tp_graph(idcentral, idMoon, vinfLevDIM, ramaxAdim, npoints);

% --> plot here the Tisserand graph contours (uncomment to use it)
% vinflevels = [ 3:0.05:5 ];
% plotContours(1, vinflevels, idcentral, 1, 1, [],  strucNorm.normDist);

% --> adjust the axes accordingly
ylim( [0 0.8] );
xlim( [0 1.5] );

% --> plot some points from Task 2 solutions at Enceladus on TP Graph (...)

% --> adjust the axes accordingly
ylim( [0.5 1.07] );
xlim( [0.9 1.2] );

name = [pwd '/AUTOMATE/Images/tisseran_poincare_enceladus.png'];
exportgraphics(fig2, name, 'Resolution', 1200);
