
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%%

idcentral = 7;                            % --> central body (Saturn in this case)
idmoon    = 5;                            % --> flyby body (Titan in this case)
muCentral = constants(idcentral, idmoon); % --> gravitational constant of the central body [km3/s2]
epoch     = 0;                            % --> initial epoch [MJD2000]
vinf_norm = 2.5;                          % --> infinity velocity [km/s]

%% --> Test full-resonant transfer

% --> resonant ratio
N = 1; % --> moon revs.
M = 1; % --> SC revs.

crank1 = pi; % --> crank angle

[vinf1, alpha1, crank1, vinf2, alpha2, crank2, tof] = ...   
    wrap_fullResTransf(N, M, vinf_norm, crank1, idmoon, idcentral);                           % --> find the full-resonant transfer
[~, rr1, vv1] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank1, epoch, idmoon, idcentral); % --> find cartesian elements
[~, yy]       = propagateKepler_tof(rr1, vv1, tof, muCentral);                               % --> propagate

crank = 0; 
[vinf1, alpha1, crank, vinf2, alpha2, crank2, tof] = ...   
    wrap_fullResTransf(N, M, vinf_norm, crank, idmoon, idcentral);                           % --> find the full-resonant transfer
[~, rr1, vv1] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank, epoch, idmoon, idcentral); % --> find cartesian elements
[~, yy2]       = propagateKepler_tof(rr1, vv1, tof, muCentral);                               % --> propagate

% --> plot moon's orbit and add the trajectory
fig = plotMoons(idmoon, idcentral);

plot3( yy(:,1), yy(:,2), yy(:,3), 'LineWidth', 2, 'DisplayName', 'II'  );
plot3( yy2(:,1), yy2(:,2), yy2(:,3), 'LineWidth', 2, 'DisplayName', 'OO' );

plot3( yy(1,1), yy(1,2), yy(1,3), 'o',...
    'MarkerEdgeColor', 'Black',...
    'MarkerFaceColor', 'Green',...
    'DisplayName', 'Fly-by' );

legend( 'Location', 'Best' );

name = [pwd '/AUTOMATE/Images/transfer1_fullRes.png'];
exportgraphics(fig, name, 'Resolution', 1200);

%% --> Test pseudo-resonant transfer

% --> resonant ratio
N = 2; % --> moon revs.
M = 1; % --> SC revs.

type = 18; % --> Inbound-Outbound
[vinf1, alpha1, crank1, vinf2, alpha2, crank2, tof] = ...
    wrap_pseudoResTransf( type, N, M, vinf_norm, idmoon, idcentral, +1 );                    % --> find the pseudo-resonant transfer
[~, rr1, vv1] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank1, epoch, idmoon, idcentral); % --> find cartesian elements
[~, yy]       = propagateKepler_tof(rr1, vv1, tof, muCentral);                               % --> propagate

type = 81; % --> Outbound-Inbound
[vinf1, alpha1, crank1, vinf2, alpha2, crank2, tof] = ...
    wrap_pseudoResTransf( type, N, M, vinf_norm, idmoon, idcentral, +1 );                    % --> find the pseudo-resonant transfer
[~, rr1, vv1] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank1, epoch, idmoon, idcentral); % --> find cartesian elements
[~, yy2]       = propagateKepler_tof(rr1, vv1, tof, muCentral);                              % --> propagate

% --> plot moon's orbit and add the trajectory
fig100 = plotMoons(idmoon, idcentral);

nameRes = [ num2str(N) ':' num2str(M) ];
plot3( yy(:,1), yy(:,2), yy(:,3), 'LineWidth', 2, 'DisplayName', 'IO' );
plot3( yy2(:,1), yy2(:,2), yy2(:,3), 'LineWidth', 2, 'DisplayName', 'OI' );

plot3( yy(1,1), yy(1,2), yy(1,3), 'o',...
    'MarkerEdgeColor', 'Black',...
    'MarkerFaceColor', 'Green',...
    'DisplayName', 'Start' );

plot3( yy(end,1), yy(end,2), yy(end,3), 'o',...
    'MarkerEdgeColor', 'Black',...
    'MarkerFaceColor', 'Red',...
    'DisplayName', 'End' );

plot3( yy2(end,1), yy2(end,2), yy2(end,3), 'o',...
    'MarkerEdgeColor', 'Black',...
    'MarkerFaceColor', 'Red',...
    'HandleVisibility', 'Off' );

legend( 'Location', 'Best' );

name = [pwd '/AUTOMATE/Images/transfer4_pseudoRes_2_1.png'];
exportgraphics(fig100, name, 'Resolution', 1200);

%% Test backflip transfer (revolutions = 0)

revolutions     = 0; % --> number of revolutions

% --> case 1: ABOVE
side                 = +1; % --> 1.ABOVE, -1.BELOW
[ vinf1, alpha1, crank1, vinf2, alpha2, crank2, tof] = ...
    wrap_backFlipTransfer( idcentral, idmoon, epoch, vinf_norm, ...
    revolutions, side, 1, 1 );                                                               % --> find the backflip transfer
[~, rr1, vv1] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank1, epoch, idmoon, idcentral); % --> find cartesian elements
[~, yy]       = propagateKepler_tof(rr1, vv1, tof, muCentral);                               % --> propagate

% --> case 1: BELOW
side                 = -1; % --> 1.ABOVE, -1.BELOW
[ vinf1, alpha1, crank1, vinf2, alpha2, crank2, tof] = ...
    wrap_backFlipTransfer( idcentral, idmoon, epoch, vinf_norm, ...
    revolutions, side, 1, 1 );                                                               % --> find the backflip transfer
[~, rr1, vv1] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank1, epoch, idmoon, idcentral); % --> find cartesian elements
[~, yy2]       = propagateKepler_tof(rr1, vv1, tof, muCentral);                              % --> propagate

% --> plot moon's orbit and add the trajectory
fig1 = plotMoons(idmoon, idcentral);
axis normal;

plot3( yy(:,1), yy(:,2), yy(:,3), 'LineWidth', 2, 'DisplayName', 'Above' );
plot3( yy2(:,1), yy2(:,2), yy2(:,3), 'LineWidth', 2, 'DisplayName', 'Below' );

plot3( yy(1,1), yy(1,2), yy(1,3), 'o',...
    'MarkerEdgeColor', 'Black',...
    'MarkerFaceColor', 'Green',...
    'DisplayName', 'Start' );

plot3( yy(end,1), yy(end,2), yy(end,3), 'o',...
    'MarkerEdgeColor', 'Black',...
    'MarkerFaceColor', 'Red',...
    'DisplayName', 'End' );

view([-36 15]);

legend( 'Location', 'Best' );

name = [pwd '/AUTOMATE/Images/transfer2_backFlip_0rev.png'];
exportgraphics(fig1, name, 'Resolution', 1200);

%% --> Test backflip transfer (revolutions > 0)

revolutions     = 3; % --> number of revolutions

% --> case 1: ABOVE
side                 = +1; % --> 1.ABOVE, -1.BELOW
[ vinf1, alpha1, crank1, vinf2, alpha2, crank2, tof] = ...
    wrap_backFlipTransfer( idcentral, idmoon, epoch, vinf_norm, ...
    revolutions, side, 1, 1 );

[~, rr1, vv1] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank1, epoch, idmoon, idcentral); % --> find cartesian elements
[~, yy]       = propagateKepler_tof(rr1, vv1, tof, muCentral);                               % --> propagate

% --> case 1: BELOW
side                 = -1; % --> 1.ABOVE, -1.BELOW
[ vinf1, alpha1, crank1, vinf2, alpha2, crank2, tof] = ...
    wrap_backFlipTransfer( idcentral, idmoon, epoch, vinf_norm, ...
    revolutions, side, 1, 1 );

[~, rr1, vv1] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank1, epoch, idmoon, idcentral); % --> find cartesian elements
[~, yy2]       = propagateKepler_tof(rr1, vv1, tof, muCentral);                              % --> propagate

% --> plot moon's orbit and add the trajectory
fig2 = plotMoons(idmoon, idcentral);
axis normal;

plot3( yy(:,1), yy(:,2), yy(:,3), 'LineWidth', 2, 'DisplayName', 'Above' );
plot3( yy2(:,1), yy2(:,2), yy2(:,3), 'LineWidth', 2, 'DisplayName', 'Below' );

plot3( yy(1,1), yy(1,2), yy(1,3), 'o',...
    'MarkerEdgeColor', 'Black',...
    'MarkerFaceColor', 'Green',...
    'DisplayName', 'Start' );

plot3( yy(end,1), yy(end,2), yy(end,3), 'o',...
    'MarkerEdgeColor', 'Black',...
    'MarkerFaceColor', 'Red',...
    'DisplayName', 'End' );

view([-36 15]);

legend( 'Location', 'Best' );

name = [pwd '/AUTOMATE/Images/transfer3_backFlip_3rev.png'];
exportgraphics(fig2, name, 'Resolution', 1200);

%% --> Test VILTs

% --> select the VILT anatomy
N     = 3;
M     = 1;
L     = 0;
type  = 88;  % --> 1.INBOUND, 8.OUTBOUND
kei   = -1;  % --> +1 for manoeuvre at APOAPSIS, -1 for manoeuvre at PERIAPSIS
vinf1 = 2.5;
vinf2 = 2.55;

% --> solve the VILT
[vinf1, alpha1, crank1, vinf2, alpha2, crank2, DV, tof1, tof2] = ...
    wrap_vInfinityLeveraging(type, N, M, L, kei, vinf1, vinf2, idmoon, idcentral, +1);
toftot = tof1 + tof2; % --> total time of flight

% nodeToAdd               = [idmoon [type kei N M L] [alpha1 vinf1] [alpha2 vinf2] [DV (tof1 + tof2)/86400]];
% 
% [nodeToAdd, tof1, tof2] = computeTof1Tof2AndRefine(nodeToAdd, idcentral);
% tof1 = tof1 * 86400;
% tof2 = tof2 * 86400;
% 
% tof1/86400
% tof2/86400
% 
% alpha1 = nodeToAdd( 7 );
% alpha2 = nodeToAdd( 9 );

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

name = [pwd '/AUTOMATE/Images/transfer3_vilt_2_1_periapsis.png'];
exportgraphics(fig2, name, 'Resolution', 1200);
