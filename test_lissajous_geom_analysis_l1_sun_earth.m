
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%% 

idcentral = 1; % --> Sun
idPlanet  = 3;  % --> Earth(+Moon)

strucNorm = wrapNormCR3BP(idcentral, idPlanet);
mu        = strucNorm.normMu;
normDist  = strucNorm.normDist;

colors      = cool(4);

sev_min_deg = 5;
sev_max_deg = 35;

%%

lpoint      = 'L1';
orbit_type  = 'liss';

m           = 3;
phi         = 0;
num_periods = 2*5.2;

Az = 50e3;
Ay = Az;
Ax = Ay/3.2292680962;

% --> generate linearised Lissajous orbits
% [tt, xx_liss, period_in_plane, period_out_of_plane, LagrPoint] = ...
%     linearised_lissajous( Ax, Az, m, phi, num_periods, strucNorm, lpoint );

Az_south = [ -50e3:-50e3:-850e3 ];
Az_north = [ 50e3:50e3:850e3 ];

lissajous_south = wrap_lissajous_family( Az_south, Az_south, m, phi, num_periods, strucNorm, lpoint );  % --> generate the orbits
lissajous_south = wrap_sev_angle( lissajous_south, strucNorm );                                         % --> compute SEV
lissajous_south = wrap_dist_to_secondary( lissajous_south, strucNorm );                                 % --> compute distance to Earth

lissajous_north = wrap_lissajous_family( Az_north, Az_north, m, phi, num_periods, strucNorm, lpoint );  % --> generate the orbits
lissajous_north = wrap_sev_angle( lissajous_north, strucNorm );                                         % --> compute SEV
lissajous_north = wrap_dist_to_secondary( lissajous_north, strucNorm );                                 % --> compute distance to Earth

%% --> SOUTH ORBITS

close all; clc;

% --> START: plot SEV
fig_sev_south = plot_sev_angle_amplitude( lissajous_south, strucNorm, 0, cool(length(lissajous_south)) );
xlabel( 'time [years]' );
hline( sev_min_deg, 'r-' );
hline( sev_max_deg, 'r-' );

name_fig_0 = ['\south_' orbit_type '_sev'];
exportgraphics(fig_sev_south, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig([pwd name_fig_0 '_' lpoint '.fig' ]);
% --> END: plot SEV

% --> START: plot MAX/MIN SEV
max_sev_south = [ lissajous_south.max_sev_angle ]';
min_sev_south = [ lissajous_south.min_sev_angle ]';

fig_max_min_sev_south = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel('A_z [x10^3 km]'); ylabel( 'SEV angle [deg]' );
plot( Az_south./1e3, rad2deg(max_sev_south), 'LineWidth', 2, 'DisplayName', 'Max. SEV angle' );
plot( Az_south./1e3, rad2deg(min_sev_south), 'LineWidth', 2, 'DisplayName', 'Min. SEV angle' );

labelsDim = 12;
axesDim   = 12;
set(findall(fig_max_min_sev_south,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(fig_max_min_sev_south, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

hline( sev_min_deg, 'r-' );
hline( sev_max_deg, 'r-' );

lgd = legend( 'Location', 'best' );

name_fig_0 = ['\south_' orbit_type '_max_min_sev'];
exportgraphics(fig_max_min_sev_south, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig([pwd name_fig_0 '_' lpoint '.fig' ]);
% --> END: plot MAX/MIN SEV

% --> START: plot DIST
fig_dist_south = plot_distance_to_secondary( lissajous_south, strucNorm, 0, cool(length(lissajous_south)) );
xlabel( 'time [years]' );

name_fig_0 = ['\south_' orbit_type '_dist'];
exportgraphics(fig_dist_south, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig([pwd name_fig_0 '_' lpoint '.fig' ]);
% --> END: plot DIST

% --> START: plot MAX/MIN DIST
max_dist_south = [ lissajous_south.max_dist_to_secondary ]';
min_dist_south = [ lissajous_south.min_dist_to_secondary ]';

fig_max_min_dist_south = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel('A_z [x10^3 km]'); ylabel( 'Distance [km]' );
plot( Az_south./1e3, max_dist_south.*strucNorm.normDist, 'LineWidth', 2, 'DisplayName', 'Max. distance from Earth' );
plot( Az_south./1e3, min_dist_south.*strucNorm.normDist, 'LineWidth', 2, 'DisplayName', 'Min. distance from Earth' );

labelsDim = 12;
axesDim   = 12;
set(findall(fig_max_min_dist_south,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(fig_max_min_dist_south, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

lgd = legend( 'Location', 'best' );

name_fig_0 = ['\south_' orbit_type '_max_min_dist'];
exportgraphics(fig_max_min_dist_south, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig([pwd name_fig_0 '_' lpoint '.fig' ]);
% --> END: plot MAX/MIN DIST

%% --> NORTH ORBITS

% --> START: plot SEV
fig_sev_north = plot_sev_angle_amplitude( lissajous_north, strucNorm, 0, cool(length(lissajous_north)) );
xlabel( 'time [years]' );
hline( sev_min_deg, 'r-' );
hline( sev_max_deg, 'r-' );

name_fig_0 = ['\north_' orbit_type '_sev'];
exportgraphics(fig_sev_north, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig([pwd name_fig_0 '_' lpoint '.fig' ]);
% --> END: plot SEV

% --> START: plot MAX/MIN SEV
max_sev_north = [ lissajous_north.max_sev_angle ]';
min_sev_north = [ lissajous_north.min_sev_angle ]';

fig_max_min_sev_north = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel('A_z [x10^3 km]'); ylabel( 'SEV angle [deg]' );
plot( Az_north./1e3, rad2deg(max_sev_north), 'LineWidth', 2, 'DisplayName', 'Max. SEV angle' );
plot( Az_north./1e3, rad2deg(min_sev_north), 'LineWidth', 2, 'DisplayName', 'Min. SEV angle' );

labelsDim = 12;
axesDim   = 12;
set(findall(fig_max_min_sev_north,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(fig_max_min_sev_north, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

hline( sev_min_deg, 'r-' );
hline( sev_max_deg, 'r-' );

lgd = legend( 'Location', 'best' );

name_fig_0 = ['\north_' orbit_type '_max_min_sev'];
exportgraphics(fig_max_min_sev_north, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig([pwd name_fig_0 '_' lpoint '.fig' ]);
% --> END: plot MAX/MIN SEV

% --> START: plot DIST
fig_dist_north = plot_distance_to_secondary( lissajous_north, strucNorm, 0, cool(length(lissajous_north)) );
xlabel( 'time [years]' );

name_fig_0 = ['\north_' orbit_type '_dist'];
exportgraphics(fig_dist_north, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig([pwd name_fig_0 '_' lpoint '.fig' ]);
% --> END: plot DIST

% --> START: plot MAX/MIN DIST
max_dist_north = [ lissajous_north.max_dist_to_secondary ]';
min_dist_north = [ lissajous_north.min_dist_to_secondary ]';

fig_max_min_dist_north = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel('A_z [x10^3 km]'); ylabel( 'Distance [km]' );
plot( Az_north./1e3, max_dist_north.*strucNorm.normDist, 'LineWidth', 2, 'DisplayName', 'Max. distance from Earth' );
plot( Az_north./1e3, min_dist_north.*strucNorm.normDist, 'LineWidth', 2, 'DisplayName', 'Min. distance from Earth' );

labelsDim = 12;
axesDim   = 12;
set(findall(fig_max_min_dist_north,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(fig_max_min_dist_north, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

lgd = legend( 'Location', 'northwest' );

name_fig_0 = ['\north_' orbit_type '_max_min_dist'];
exportgraphics(fig_max_min_dist_north, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig([pwd name_fig_0 '_' lpoint '.fig' ]);
% --> END: plot MAX/MIN DIST

%% --> determine max. and min. admissible amplitudes for SEV exclusion zone

xx1 = [ lissajous_south.Az ]';
yy1 = rad2deg([lissajous_south.min_sev_angle]');

xx2 = xx1;
yy2 = sev_min_deg.*ones( length(xx2), 1 );

P_min = InterX([xx1'; yy1'], [xx2'; yy2']);

xx1 = [ lissajous_south.Az ]';
yy1 = rad2deg([lissajous_south.max_sev_angle]');

xx2 = xx1;
yy2 = sev_max_deg.*ones( length(xx2), 1 );

P_max = InterX([xx1'; yy1'], [xx2'; yy2']);

clc;

min(rad2deg([ lissajous_south.max_sev_angle ]'))
max(rad2deg([ lissajous_south.max_sev_angle ]'))

min(rad2deg([ lissajous_south.min_sev_angle ]'))
max(rad2deg([ lissajous_south.min_sev_angle ]'))


xx1 = [ lissajous_north.Az ]';
yy1 = rad2deg([lissajous_north.min_sev_angle]');

xx2 = xx1;
yy2 = sev_min_deg.*ones( length(xx2), 1 );

P_min = InterX([xx1'; yy1'], [xx2'; yy2']);

xx1 = [ lissajous_north.Az ]';
yy1 = rad2deg([lissajous_north.max_sev_angle]');

xx2 = xx1;
yy2 = sev_max_deg.*ones( length(xx2), 1 );

P_max = InterX([xx1'; yy1'], [xx2'; yy2']);

clc;

min(rad2deg([ lissajous_north.max_sev_angle ]'))
max(rad2deg([ lissajous_north.max_sev_angle ]'))

min(rad2deg([ lissajous_north.min_sev_angle ]'))
max(rad2deg([ lissajous_north.min_sev_angle ]'))

%%

d1 = max([lissajous_north.min_dist_to_secondary]')*strucNorm.normDist
d2 = min([lissajous_north.min_dist_to_secondary]')*strucNorm.normDist

d3 = max( [lissajous_south.min_dist_to_secondary]' )*strucNorm.normDist
d4 = min( [lissajous_south.min_dist_to_secondary]' )*strucNorm.normDist

max([d1, d3])
min([d2, d4])

