
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%%

idcentral = 7;                            % --> central body (Uranus in this case)
idmoon    = 5;                            % --> flyby body (Oberon in this case)
epoch     = 0;                            % --> initial epoch [MJD2000]

[muCentral, mupl, rpl, radpl, hmin, Tpl] = constants(idcentral, idmoon);
TmoonDays = Tpl / 86400

%% --> Test VILTs

% --> select the VILT anatomy
N     = 3;
M     = 2;
L     = 1;
type  = 81;  % --> 1.INBOUND, 8.OUTBOUND
kei   = -1;  % --> +1 for manoeuvre at APOAPSIS, -1 for manoeuvre at PERIAPSIS
vinf1 = 2.5;
vinf2 = 2.55;

% --> solve the VILT
[vinf1, alpha1, crank1, vinf2, alpha2, crank2, DV, tof1, tof2] = ...
    wrap_vInfinityLeveraging(type, N, M, L, kei, vinf1, vinf2, idmoon, idcentral, +1);
toftot = tof1 + tof2; % --> total time of flight

nodeToAdd               = [idmoon [type kei N M L] [alpha1 vinf1] [alpha2 vinf2] [DV (tof1 + tof2)/86400]];

% [nodeToAdd, tof1, tof2] = computeTof1Tof2AndRefine(nodeToAdd, idcentral);
% tof1 = tof1 * 86400;
% tof2 = tof2 * 86400;
% 
% alpha1 = nodeToAdd( 7 );
% alpha2 = nodeToAdd( 9 );


tof1/86400
tof2/86400

%%

% --> propagate forward to the DSM
[~, rr1, vv1] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank1, epoch, idmoon, idcentral); % --> find cartesian elements
[~, yy1]      = propagateKepler_tof(rr1, vv1, tof1, muCentral);                              % --> propagate

% --> propagate backward from end point to DSM
[~, rr2, vv2] = vinfAlphaCrank_to_VinfCART(vinf2, alpha2, crank2, epoch+toftot/86400, idmoon, idcentral); % --> find cartesian elements
[~, yy2]      = propagateKepler_tof(rr2, vv2, -tof2, muCentral);                                    % --> propagate

% --> plot moon's orbit and add the trajectory
fig2 = plotMoons(idmoon, idcentral);

plot3( yy1(:,1), yy1(:,2), yy1(:,3), 'LineWidth', 2, 'HandleVisibility', 'off' );
plot3( yy2(:,1), yy2(:,2), yy2(:,3), 'LineWidth', 2, 'HandleVisibility', 'off' );

plot3( yy1(1,1), yy1(1,2), yy1(1,3), 'o',...
    'MarkerEdgeColor', 'Black',...
    'MarkerFaceColor', 'Green',...
    'DisplayName', 'Start' );

plot3( yy2(1,1), yy2(1,2), yy2(1,3), 'o',...
    'MarkerEdgeColor', 'Black',...
    'MarkerFaceColor', 'Red',...
    'DisplayName', 'End' );

plot3( yy1(end,1), yy2(end,2), yy2(end,3), 'X', 'LineWidth', 3,...
    'MarkerSize', 10, ...
    'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', 'Black', ...
    'DisplayName', 'DSM' );

legend('Location', 'Best'); 
