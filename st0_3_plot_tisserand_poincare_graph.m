
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%%

% --> set the constants
idcentral  = 6; % --> central body (Saturn in this case)
idMoon     = 5; % --> flyby body (Enceladus in this case)

% --> norm. var. CR3BP
strucNorm = wrapNormCR3BP(idcentral, idMoon);

% --> plot the Tisserand-Poincarè graph
vinfLevDIM = [ 0.2:0.1:1 ];
ramaxAdim  = 4;
npoints    = 5e3;

% --> plot the Tisserand-Poincare graph
fig2 = plot_tp_graph(idcentral, idMoon, vinfLevDIM, ramaxAdim, npoints);

ylim( [0.15 1.3] );
xlim( [0.4 2.3] );
