
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%%

idcentral = 6;                            % --> central body (Saturn in this case)
idmoon    = 5;                            % --> flyby body (Titan in this case)
muCentral = constants(idcentral, idmoon); % --> gravitational constant of the central body [km3/s2]
epoch     = 0;                            % --> initial epoch [MJD2000]
vinf_norm = 1.5;                          % --> infinity velocity [km/s]

%% --> Test full-resonant transfer

% --> resonant ratio
N = 2; % --> moon revs.
M = 1; % --> SC revs.

crank = pi; % --> crank angle

[vinf1, alpha1, crank1, vinf2, alpha2, crank2, tof] = ...   
    wrap_fullResTransf(N, M, vinf_norm, crank, idmoon, idcentral);                           % --> find the full-resonant transfer
[~, rr1, vv1] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank1, epoch, idmoon, idcentral); % --> find cartesian elements
[~, yy]       = propagateKepler_tof(rr1, vv1, tof, muCentral);                               % --> propagate

% --> plot moon's orbit and add the trajectory
fig = plotMoons(idmoon, idcentral);

plot3( yy(:,1), yy(:,2), yy(:,3), 'LineWidth', 2, 'DisplayName', 'Prograde' );

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
axis normal;

nameRes = [ num2str(N) ':' num2str(M) ];
plot3( yy(:,1), yy(:,2), yy(:,3), 'LineWidth', 2, 'DisplayName', [nameRes '^+'] );
plot3( yy2(:,1), yy2(:,2), yy2(:,3), 'LineWidth', 2, 'DisplayName', [nameRes '^-'] );

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

plot3( yy(:,1), yy(:,2), yy(:,3), 'LineWidth', 2, 'DisplayName', 'above' );
plot3( yy2(:,1), yy2(:,2), yy2(:,3), 'LineWidth', 2, 'DisplayName', 'below' );

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
[~, yy]       = propagateKepler_tof(rr1, vv1, tof, muCentral); % --> propagate

% --> case 1: BELOW
side                 = -1; % --> 1.ABOVE, -1.BELOW
[ vinf1, alpha1, crank1, vinf2, alpha2, crank2, tof] = ...
    wrap_backFlipTransfer( idcentral, idmoon, epoch, vinf_norm, ...
    revolutions, side, 1, 1 );

[~, rr1, vv1] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank1, epoch, idmoon, idcentral); % --> find cartesian elements
[~, yy2]       = propagateKepler_tof(rr1, vv1, tof, muCentral); % --> propagate

% --> plot moon's orbit and add the trajectory
fig2 = plotMoons(idmoon, idcentral);
axis normal;

plot3( yy(:,1), yy(:,2), yy(:,3), 'LineWidth', 2, 'DisplayName', 'Prograde' );
plot3( yy2(:,1), yy2(:,2), yy2(:,3), 'LineWidth', 2, 'DisplayName', 'Retrograde' );

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
