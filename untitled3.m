
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%%

idcentral = 1;                            % --> central body (Saturn in this case)
idmoon    = 3;                            % --> flyby body (Titan in this case)
muCentral = constants(idcentral, idmoon); % --> gravitational constant of the central body [km3/s2]
epoch     = 0;                            % --> initial epoch [MJD2000]
vinf_norm = 4;                            % --> infinity velocity [km/s]

[~, ~, ~, ~, ~, Tpl] = constants(idcentral, idmoon);
Tpl_years = Tpl/( 86400*365.25 );

%% --> Test VILTs

% --> select the VILT anatomy
N     = 2;
M     = 1;
L     = 0;
type  = 81;  % --> 1.INBOUND, 8.OUTBOUND
kei   = +1;  % --> +1 for manoeuvre at APOAPSIS, -1 for manoeuvre at PERIAPSIS
vinf1 = 3;
vinf2 = 3.5;

% --> solve the VILT
[vinf1, alpha1, crank1, vinf2, alpha2, crank2, DV, tof1, tof2] = ...
    wrap_vInfinityLeveraging(type, N, M, L, kei, vinf1, vinf2, idmoon, idcentral, 1);
toftot       = tof1 + tof2; % --> total time of flight

toftot_years = toftot/( 86400*365.25 );
toftot_years/Tpl_years

% --> propagate forward to the DSM
[~, rr1, vv1] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank1, epoch, idmoon, idcentral); % --> find cartesian elements
[~, yy1]      = propagateKepler_tof(rr1, vv1, tof1, muCentral);                              % --> propagate

% --> propagate backward from end point to DSM
[~, rr2, vv2] = vinfAlphaCrank_to_VinfCART(vinf2, alpha2, crank2, epoch+toftot/86400, idmoon, idcentral); % --> find cartesian elements
[~, yy2]      = propagateKepler_tof(rr2, vv2, -tof2, muCentral);                                    % --> propagate

abs( norm(yy2(end,4:6) - yy1(end,4:6)) - DV )

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

lgd = legend('Location', 'northoutside'); 
lgd.NumColumns = 3;

