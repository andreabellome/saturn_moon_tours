
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%% --> Step 1) Plot the Tisserand-Poincare Graph

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

% % --> plot here the Tisserand graph contours (uncomment to use it)
% vinflevels = [ 3:0.05:5 ];
% plotContours(1, vinflevels, idcentral, 1, 1, [],  strucNorm.normDist);
% % --> adjust the axes accordingly
% ylim( [0 0.8] );
% xlim( [0 1.5] );
% % --> adjust the axes accordingly
% ylim( [0.5 1.07] );
% xlim( [0.9 1.2] );

%% --> Step 2) Plot some points from Task 2 solutions at Enceladus

% --> load the Task 2 solution
load([pwd '/Solutions/PATHph_noOpCon.mat']);

% --> Enceladus phase
tour   = PATHph(end).path;
idMoon = tour(1,1);

% --> convert the tour into apoapsis-periapsis and apply the CR3BP scaling (Saturn-Enceladus)
alphaAfterDSM            = tour( :,9 );
vinfAfterDSM             = tour( :,10 );
[raAfterDSM, rpAfterDSM] = alphaVinf2raRp(alphaAfterDSM, vinfAfterDSM, idMoon, idcentral);
raAfterDSMAdim           = raAfterDSM./strucNorm.normDist;
rpAfterDSMAdim           = rpAfterDSM./strucNorm.normDist;

alphaBeforeDSM             = tour( 2:end,9 );
vinfBeforeDSM              = tour( 2:end,10 );
[raBeforeDSM, rpBeforeDSM] = alphaVinf2raRp(alphaBeforeDSM, vinfBeforeDSM, idMoon, idcentral);
raBeforeDSM                = raBeforeDSM./strucNorm.normDist;
rpBeforeDSM                = rpBeforeDSM./strucNorm.normDist;

% --> plot the orbits on the Tisserand-Poincare graph
hold on;
plot( raAfterDSMAdim, rpAfterDSMAdim, 'o', 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Yellow', 'HandleVisibility', 'off' );
plot( raBeforeDSM, rpBeforeDSM, 'o', 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Yellow', 'HandleVisibility', 'off' );
plot( raBeforeDSM(1), rpBeforeDSM(1), 'o', 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Yellow', 'DisplayName', 'Enceladus tour' );

% --> adjust the axes accordingly
xlim( [0.95 1.35] );
ylim( [0.9 1.02] );

% --> save the file
name = [pwd '/AUTOMATE/Images/tisseran_poincare_enceladus.png'];
exportgraphics(fig2, name, 'Resolution', 1200);
