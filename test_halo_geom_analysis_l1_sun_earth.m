
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%% 

idcentral = 1; % --> Sun
idPlanet  = 3;  % --> Earth(+Moon)

strucNorm = wrapNormCR3BP(idcentral, idPlanet);
mu        = strucNorm.normMu;
normDist  = strucNorm.normDist;

colors = cool(4);

sev_min_deg = 5;
sev_max_deg = 35;

%% --> SOUTH ORBITS

close all; clc;

lpoint      = 'L1';
Az_south    = [ -50e3:-50e3:-850e3 ];

Az_vect                    = Az_south;
[ halo_orbits_l1_south ]   = wrap_halo_family( Az_vect, lpoint, strucNorm );

% --> compute SEV angle and distance to Earth
halo_orbits_l1_south = wrap_sev_angle( halo_orbits_l1_south, strucNorm );
halo_orbits_l1_south = wrap_dist_to_secondary( halo_orbits_l1_south, strucNorm );

% --> START: plot Ax/Ay/Az
fig_ax_ay_az_south = figure( 'Color', [1 1 1] );
hold on; grid on;

yyaxis left;
xlabel( 'A_z [x10^5 km]' ); ylabel( 'A_x [x10^5 km]' ); 
plot( [ halo_orbits_l1_south.Az ]'./1e5, [ halo_orbits_l1_south.Ax ]'./1e5, 'LineWidth', 2 );

yyaxis right;
xlabel( 'A_z [x10^5 km]' ); ylabel( 'A_y [x10^5 km]' ); 
plot( [ halo_orbits_l1_south.Az ]'./1e5, [ halo_orbits_l1_south.Ay ]'./1e5, 'LineWidth', 2 );

labelsDim = 12;
axesDim   = 12;
set(findall(fig_ax_ay_az_south,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(fig_ax_ay_az_south, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

name_fig_0 = '\south_halo_ax_ay_az_angle';
exportgraphics(fig_ax_ay_az_south, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig(fig_ax_ay_az_south, [pwd name_fig_0 '_' lpoint '.fig' ]); % Save the figure as a .fig file
% --> END: plot Ax/Ay/Az

% --> START: plot SEV
fig_sev_south = plot_sev_angle_amplitude( halo_orbits_l1_south, strucNorm, 0, cool(length(halo_orbits_l1_south)) );
hline( sev_min_deg, 'r-' );
hline( sev_max_deg, 'r-' );

name_fig_0 = '\south_halo_sev_angle';
exportgraphics(fig_sev_south, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig(fig_sev_south, [pwd name_fig_0 '_' lpoint '.fig' ]); % Save the figure as a .fig file
% --> END: plot SEV

% --> START: plot MAX/MIN SEV
max_sev_south = [ halo_orbits_l1_south.max_sev_angle ]';
min_sev_south = [ halo_orbits_l1_south.min_sev_angle ]';

fig_max_min_sev_south = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel('A_z [x10^3 km]'); ylabel( 'SEV angle [deg]' );
plot( Az_vect./1e3, rad2deg(max_sev_south), 'LineWidth', 2, 'DisplayName', 'Max. SEV angle' );
plot( Az_vect./1e3, rad2deg(min_sev_south), 'LineWidth', 2, 'DisplayName', 'Min. SEV angle' );

labelsDim = 12;
axesDim   = 12;
set(findall(fig_max_min_sev_south,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(fig_max_min_sev_south, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

hline( sev_min_deg, 'r-' );
hline( sev_max_deg, 'r-' );

lgd = legend( 'Location', 'northeast' );

name_fig_0 = '\south_halo_max_min_sev';
exportgraphics(fig_max_min_sev_south, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig(fig_max_min_sev_south, [pwd name_fig_0 '_' lpoint '.fig' ]); % Save the figure as a .fig file
% --> END: plot MAX/MIN SEV

% --> START: plot DIST
fig_dist_south = plot_distance_to_secondary( halo_orbits_l1_south, strucNorm, 0, cool(length(halo_orbits_l1_south)) );

name_fig_0 = '\south_halo_dist';
exportgraphics(fig_dist_south, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig(fig_dist_south, [pwd name_fig_0 '_' lpoint '.fig' ]); % Save the figure as a .fig file
% --> END: plot DIST

% --> START: plot MAX/MIN DIST
max_dist_south = [ halo_orbits_l1_south.max_dist_to_secondary ]';
min_dist_south = [ halo_orbits_l1_south.min_dist_to_secondary ]';

fig_max_min_dist_south = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel('A_z [x10^3 km]'); ylabel( 'Distance [km]' );
plot( Az_vect./1e3, max_dist_south.*strucNorm.normDist, 'LineWidth', 2, 'DisplayName', 'Max. distance from Earth' );
plot( Az_vect./1e3, min_dist_south.*strucNorm.normDist, 'LineWidth', 2, 'DisplayName', 'Min. distance from Earth' );

labelsDim = 12;
axesDim   = 12;
set(findall(fig_max_min_dist_south,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(fig_max_min_dist_south, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

lgd = legend( 'Location', 'northeast' );

name_fig_0 = '\south_halo_max_min_dist';
exportgraphics(fig_max_min_dist_south, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig(fig_max_min_dist_south, [pwd name_fig_0 '_' lpoint '.fig' ]); % Save the figure as a .fig file
% --> END: plot MAX/MIN DIST

%% --> NORTH ORBITS

lpoint      = 'L1';
Az_north    = [ 50e3:50e3:850e3 ];

Az_vect                    = Az_north;
[ halo_orbits_l1_north ]   = wrap_halo_family( Az_vect, lpoint, strucNorm );

% --> compute SEV angle and distance to Earth
halo_orbits_l1_north = wrap_sev_angle( halo_orbits_l1_north, strucNorm );
halo_orbits_l1_north = wrap_dist_to_secondary( halo_orbits_l1_north, strucNorm );

% --> START: plot Ax/Ay/Az
fig_ax_ay_az_north = figure( 'Color', [1 1 1] );
hold on; grid on;

yyaxis left;
xlabel( 'A_z [x10^5 km]' ); ylabel( 'A_x [x10^5 km]' ); 
plot( [ halo_orbits_l1_north.Az ]'./1e5, [ halo_orbits_l1_north.Ax ]'./1e5, 'LineWidth', 2 );

yyaxis right;
xlabel( 'A_z [x10^5 km]' ); ylabel( 'A_y [x10^5 km]' ); 
plot( [ halo_orbits_l1_north.Az ]'./1e5, [ halo_orbits_l1_north.Ay ]'./1e5, 'LineWidth', 2 );

labelsDim = 12;
axesDim   = 12;
set(findall(fig_ax_ay_az_north,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(fig_ax_ay_az_north, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

name_fig_0 = '\north_halo_ax_ay_az_angle';
exportgraphics(fig_ax_ay_az_north, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig(fig_ax_ay_az_north, [pwd name_fig_0 '_' lpoint '.fig' ]); % Save the figure as a .fig file
% --> END: plot Ax/Ay/Az

% --> START: plot SEV
fig_sev_north = plot_sev_angle_amplitude( halo_orbits_l1_north, strucNorm, 0, cool(length(halo_orbits_l1_south)) );
hline( sev_min_deg, 'r-' );
hline( sev_max_deg, 'r-' );

name_fig_0 = '\north_halo_sev_angle';
exportgraphics(fig_sev_north, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig(fig_sev_north, [pwd name_fig_0 '_' lpoint '.fig' ]); % Save the figure as a .fig file
% --> END: plot SEV

% --> START: plot MAX/MIN SEV
max_sev_north = [ halo_orbits_l1_north.max_sev_angle ]';
min_sev_north = [ halo_orbits_l1_north.min_sev_angle ]';

fig_max_min_sev_north = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel('A_z [x10^3 km]'); ylabel( 'SEV angle [deg]' );
plot( Az_vect./1e3, rad2deg(max_sev_north), 'LineWidth', 2, 'DisplayName', 'Max. SEV angle' );
plot( Az_vect./1e3, rad2deg(min_sev_north), 'LineWidth', 2, 'DisplayName', 'Min. SEV angle' );

labelsDim = 12;
axesDim   = 12;
set(findall(fig_max_min_sev_north,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(fig_max_min_sev_north, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

hline( sev_min_deg, 'r-' );
hline( sev_max_deg, 'r-' );

lgd = legend( 'Location', 'northwest' );

name_fig_0 = '\north_halo_max_min_sev';
exportgraphics(fig_max_min_sev_north, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig(fig_max_min_sev_north, [pwd name_fig_0 '_' lpoint '.fig' ]); % Save the figure as a .fig file
% --> END: plot MAX/MIN SEV

% --> START: plot DIST
fig_dist_north = plot_distance_to_secondary( halo_orbits_l1_north, strucNorm, 0, cool(length(halo_orbits_l1_north)) );

name_fig_0 = '\north_halo_dist';
exportgraphics(fig_dist_north, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig(fig_dist_north, [pwd name_fig_0 '_' lpoint '.fig' ]); % Save the figure as a .fig file
% --> END: plot DIST

% --> START: plot MAX/MIN DIST
max_dist_north = [ halo_orbits_l1_north.max_dist_to_secondary ]';
min_dist_north = [ halo_orbits_l1_north.min_dist_to_secondary ]';

fig_max_min_dist_north = figure( 'Color', [1 1 1] );
hold on; grid on; 
xlabel( 'A_z [x10^3 km]' ); ylabel('Distance [km]'); 
plot( Az_vect./1e3, max_dist_north.*strucNorm.normDist, 'LineWidth', 2, 'DisplayName', 'Max. distance from Earth' );
plot( Az_vect./1e3, min_dist_north.*strucNorm.normDist, 'LineWidth', 2, 'DisplayName', 'Min. distance from Earth' );

labelsDim = 12;
axesDim   = 12;
set(findall(fig_max_min_dist_north,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(fig_max_min_dist_north, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

lgd = legend( 'Location', 'southwest' );

name_fig_0 = '\north_halo_max_min_dist';
exportgraphics(fig_max_min_dist_north, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig(fig_max_min_dist_north, [pwd name_fig_0 '_' lpoint '.fig' ]); % Save the figure as a .fig file
% --> END: plot MAX/MIN DIST

%% --> determine max. and min. admissible amplitudes for SEV exclusion zone

xx1 = [ halo_orbits_l1_south.Az ]';
yy1 = rad2deg([halo_orbits_l1_south.min_sev_angle]');

xx2 = xx1;
yy2 = sev_min_deg.*ones( length(xx2), 1 );

P_min = InterX([xx1'; yy1'], [xx2'; yy2']);

xx1 = [ halo_orbits_l1_south.Az ]';
yy1 = rad2deg([halo_orbits_l1_south.max_sev_angle]');

xx2 = xx1;
yy2 = sev_max_deg.*ones( length(xx2), 1 );

P_max = InterX([xx1'; yy1'], [xx2'; yy2']);

%%

clc;

min(rad2deg([ halo_orbits_l1_south.max_sev_angle ]'))
max(rad2deg([ halo_orbits_l1_south.max_sev_angle ]'))

min(rad2deg([ halo_orbits_l1_south.min_sev_angle ]'))
max(rad2deg([ halo_orbits_l1_south.min_sev_angle ]'))


