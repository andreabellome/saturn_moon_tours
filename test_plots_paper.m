%% --> CLEAR ALL AND ADD AUTOMATE TO THE PATH

clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

warning off

%%

close all; clc;

load('C:\Users\andre\Documents\GitHub\saturn_moon_tours\Solutions\outputParetoFront_noOpCon.mat')
outputParetoFront_noOpCon = outputParetoFront;

load('C:\Users\andre\Documents\GitHub\saturn_moon_tours\Solutions\outputParetoFront_yesOpCon.mat')
outputParetoFront_yesOpCon = outputParetoFront;

clear outputParetoFront;

colors = cool(4);

campag   = [ 0.445 997 ];
strange  = [ 0.734 745 ];

dvtot_noOpCon  = [ outputParetoFront_noOpCon.dvtot ]' + [ outputParetoFront_noOpCon.dvOI ]';
toftot_noOpCon = [ outputParetoFront_noOpCon.toftot ]';

dvtot_yesOpCon  = [ outputParetoFront_yesOpCon.dvtot ]' + [ outputParetoFront_yesOpCon.dvOI ]';
toftot_yesOpCon = [ outputParetoFront_yesOpCon.toftot ]';

fig1 = figure('Color', [1 1 1]);
hold on; grid on;
ylabel('TOF [days]'); xlabel('\Deltav [m/s]');
plot( dvtot_noOpCon.*1000, toftot_noOpCon, 'o', 'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', colors(1,:), ...
    'MarkerSize', 10, ...
    'DisplayName', 'MODP - without operational constraints' );

plot( dvtot_yesOpCon.*1000, toftot_yesOpCon, 'o', 'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', colors(2,:), ...
    'MarkerSize', 10, ...
    'DisplayName', 'MODP - with operational constraints' );

plot( campag(1)*1000, campag(2), 's', 'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', colors(3,:), 'MarkerSize', 10, ...
    'DisplayName', 'Campagnola et al. 2010' );

plot( strange(1)*1000, strange(2), 'd', 'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', colors(4,:), 'MarkerSize', 10, ...
    'DisplayName', 'Strange et al. 2009' );

lgd             = legend( 'Location', 'best' );
lgd.NumColumns  = 1;
