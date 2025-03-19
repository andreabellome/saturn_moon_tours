
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%% 

idcentral = 1; % --> Sun
idPlanet  = 3;  % --> Earth(+Moon)

strucNorm = wrapNormCR3BP(idcentral, idPlanet);
mu        = strucNorm.normMu;
normDist  = strucNorm.normDist;

%%

lpoint      = 'L1';
Az          = 1.2e6; % --> this must be in km!!

% --> generate Halo orbit
[ sv0, orb_period, Jc, tt, yy ] = wrap_halo_orbit_generator( Az, lpoint, strucNorm );
[ tof_dim, tof_dim_days ]       = from_time_nondim_to_dim( orb_period, strucNorm );
tof_dim_days

sev_angle = sun_earth_vehicle_angle( tt, yy, strucNorm );

close all; clc;
figure( 'Color', [1 1 1] );
xlabel( 'x [km]' ); ylabel( 'y [km]' ); zlabel( 'z [km]' );
hold on; grid on;
plot3( yy(:,1).*normDist, yy(:,2).*normDist, yy(:,3).*normDist, 'LineWidth', 2 );
view( [-2 18] );

figure( 'Color', [1 1 1] );
xlabel( 'time' ); ylabel( 'SEV [deg]' );
hold on; grid on;
plot( tt, rad2deg(sev_angle) );


%%

close all; clc;

Az_south = [ -10e3:-50e3:-1e6 ];
Az_north = [ 10e3:50e3:1e6 ];

Az_vect = [ Az_north Az_south ];

colors = cool(4);

% --> generate the solution
[ halo_orbits_l1, ~ ]   = wrap_halo_family( Az_vect, 'L1', strucNorm, 0, colors(1:2,:) );
[ halo_orbits_l2, fig ] = wrap_halo_family( Az_vect, 'L2', strucNorm, 1, colors(3:4,:) );

hold on;
plot3( strucNorm.x2.*normDist, 0, 0, 'o', 'MarkerEdgeColor', 'k', ...
    'MarkerFaceColor', 'blue', 'MarkerSize', 8, ...
    'HandleVisibility', 'off' );

hold on;
plot3( strucNorm.LagrangePoints(1).*normDist, 0, 0, 'o', 'MarkerEdgeColor', 'k', ...
    'MarkerFaceColor', 'red', 'MarkerSize', 8, ...
    'HandleVisibility', 'off' );

plot3( strucNorm.LagrangePoints(2).*normDist, 0, 0, 'o', 'MarkerEdgeColor', 'k', ...
    'MarkerFaceColor', 'cyan', 'MarkerSize', 8, ...
    'HandleVisibility', 'off' );

plotSingleAxis( [strucNorm.x2.*normDist, 0, 0], [1.49e8, 0, 0] );

legend( 'Location', 'Best' ); 
lgd = legend;
lgd.NumColumns = 2;

name_fig_1 = '\halo_amplitudes';
exportgraphics(gcf, [pwd name_fig_1 '_' 'L1_L2' '.png' ], 'Resolution', 1200);
savefig([pwd name_fig_1 '_' 'L1_L2' '.fig' ]); % Save the figure as a .fig file

Az_l1                  = [ halo_orbits_l1.Az ]';
orb_period_l1          = [ halo_orbits_l1.orb_period ]';
[ ~, tof_dim_days_l1 ] = from_time_nondim_to_dim( orb_period_l1, strucNorm );
indxs1 = Az_l1 >0;
indxs2 = Az_l1 <0;

Az_l2                  = [ halo_orbits_l2.Az ]';
orb_period_l2          = [ halo_orbits_l2.orb_period ]';
[ ~, tof_dim_days_l2 ] = from_time_nondim_to_dim( orb_period_l2, strucNorm );
indxs3 = Az_l2 >0;
indxs4 = Az_l2 <0;

figure( 'Color', [1 1 1] );
hold on; grid on; 
xlabel('A_z [x10^3 km]'); ylabel( 'Period [months]' ); 

plot( Az_l1(indxs2)./1e3, tof_dim_days_l1(indxs2)/30, 'LineWidth', 2, 'Color', colors(1,:), 'DisplayName', 'L1 - south family' );
plot( Az_l1(indxs1)./1e3, tof_dim_days_l1(indxs1)/30, 'LineWidth', 2, 'Color', colors(2,:), 'DisplayName', 'L1 - north family' );

plot( Az_l2(indxs2)./1e3, tof_dim_days_l2(indxs2)/30, 'LineWidth', 2, 'Color', colors(3,:), 'DisplayName', 'L2 - south family' );
plot( Az_l2(indxs1)./1e3, tof_dim_days_l2(indxs1)/30, 'LineWidth', 2, 'Color', colors(4,:), 'DisplayName', 'L2 - north family' );

labelsDim = 12;
axesDim   = 12;
set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(gcf, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

legend( 'Location', 'Best' );

legend( 'Location', 'Best' ); 
lgd = legend;
lgd.NumColumns = 2;

name_fig_0 = '\halo_period';
exportgraphics(gcf, [pwd name_fig_0 '_' 'L1_L2' '.png' ], 'Resolution', 1200);
savefig([pwd name_fig_0 '_' 'L1_L2' '.fig' ]); % Save the figure as a .fig file

%%

close all; clc;

ind_orb = 1;

Az_vect = 203601.4;
epsilon = 0.0001;

% --> generate the halo orbit
[ halo_orbits ]     = wrap_halo_family( Az_vect, 'L1', strucNorm, 0, 'red' );
sv0                 = halo_orbits(ind_orb).sv0;
orbital_period      = halo_orbits(ind_orb).orb_period;

[ svtf, full_state ] = propagateCR3BP( sv0, orbital_period*4, strucNorm, 5e3 );

figure( 'Color', [1 1 1] );
plot3( full_state(:,1), full_state(:,2), full_state(:,3) );

% --> generate manifolds for the given orbit
[ manifolds, fig ] = generate_manifolds( sv0, orbital_period, strucNorm, 100, 2, 1e-5, 'stable' );
unst = manifolds.delta_sv_us_s;
theta_unstable = atan2(unst(:,5), unst(:,4)) * (180 / pi);

figure( 'Color', [1 1 1] );
plot( theta_unstable );
