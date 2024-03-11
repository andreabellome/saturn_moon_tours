%% --> select the INPUT

clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%%

idcentral = 5; % --> central body (Jupiter in this case)
idmoon    = 4; % --> flyby body (Callisto in this case)
muCentral = constants(idcentral, idmoon);

% --> select the options for the pseudo-resonant transfer
vinf = 2.5;
N    = 2;
M    = 1;

RES = findResonances(idmoon, vinf, idcentral);

%%

close all; clc;

epoch = 0; % --> initial epoch (MJD2000)

% --> compute pseudo-resonant transfer
type  = 18;
[vinf1, alpha1, crank1, vinf2, alpha2, crank2, tof1] = pseudoResTransf( type, N, M, vinf, idmoon, idcentral );

[vinfCAR, rr1, vv1, vvga] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank1, epoch, idmoon, idcentral);
[tt, yy]                  = propagateKepler_tof(rr1, vv1, tof1, muCentral);

% --> compute pseudo-resonant transfer
type  = 81;
[vinf1, alpha1, crank1, vinf2, alpha2, crank2, tof2] = pseudoResTransf( type, N, M, vinf, idmoon, idcentral );

[vinfCAR, rr1, vv1, vvga] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank1, epoch, idmoon, idcentral);
[tt, yy2]                  = propagateKepler_tof(rr1, vv1, tof2, muCentral);

fig = plotMoons(idmoon, idcentral);
axis equal;

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
