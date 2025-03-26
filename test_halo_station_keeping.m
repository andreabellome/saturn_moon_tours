
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%% 

idcentral = 1; % --> Sun
idPlanet  = 3;  % --> Earth(+Moon)

strucNorm      = wrapNormCR3BP(idcentral, idPlanet);
mu             = strucNorm.normMu;
normDist       = strucNorm.normDist;
LagrangePoints = strucNorm.LagrangePoints;

%%

lpoint = 'L1';
Az     = 708768.47; % --> this must be in km!!

% --> generate Halo orbit
[ sv0, orb_period, Jc, tt, yy ] = wrap_halo_orbit_generator( Az, lpoint, strucNorm );
yy_ref = yy;

% --> compute the states and the STM along the trajectory 
[ ~, STM_tf, full_state, full_stm ] = propagateCR3BP_STM( sv0, orb_period, strucNorm );

% --> generate manifolds for the given orbit
manifolds     = generate_manifolds( sv0, orb_period, strucNorm, 100, 2, 1e-5, 'unstable' );
delta_sv_unst = manifolds.delta_sv_us_s;

pars.mu = mu;
[ LagrPoint, gamma, vec ] = lagrange_point_and_gamma( strucNorm, lpoint );
for index = 1:size(delta_sv_unst,1)
%     A                    = A_matrix_stability( full_state(index,:), pars );
%     theta_unst(index,:)  = unstable_dir_linear_theory( A, vec );

    unstable_eigenvector = delta_sv_unst(index,:);
    theta_unst(index,:)  = acos( dot( unstable_eigenvector(4:6), vec )/( norm(unstable_eigenvector( 4:6 ))*norm(vec) ) );

end

% unst            = manifolds.delta_sv_us_s;
% theta_unstable  = atan2d(unst(:,5), unst(:,4));

figure( 'Color', [1 1 1] );
plot( rad2deg(theta_unst) );


close all; clc;
figure( 'Color', [1 1 1] );

subplot(2,1,1);

xlabel( 'x [km]' ); ylabel( 'y [km]' ); zlabel( 'z [km]' );
hold on; grid on;
plot3( yy(:,1).*normDist, yy(:,2).*normDist, yy(:,3).*normDist, ...
    'LineStyle', '-', ...
    'LineWidth', 2, ...
    'DisplayName','Reference');

plot3( LagrangePoints(1,1).*normDist, 0, 0, 'o', ...
    'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', 'Yellow', ...
    'DisplayName', 'Lagrange point' );

plot3( strucNorm.x2.*normDist, 0, 0, 'o', ...
    'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', 'Cyan', ...
    'DisplayName', 'Secondary body' );

lgd = legend( 'Location', 'best' );
view( [-2 18] );

subplot(2,1,2);
xlabel( 'x [km]' ); ylabel( 'y [km]' );

hold on; grid on;
plot( yy(:,1).*normDist, yy(:,2).*normDist, ...
    'LineStyle', '-', ...
    'LineWidth', 2, ...
    'DisplayName','Reference');

plot( LagrangePoints(1,1).*normDist, 0, 'o', ...
    'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', 'Yellow', ...
    'DisplayName', 'Lagrange point' );

plot( strucNorm.x2.*normDist, 0, 'o', ...
    'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', 'Cyan', ...
    'DisplayName', 'Secondary body' );

lgd = legend( 'Location', 'best' );

%%

graycolor = [ 0.6, 0.6, 0.6 ];
min_x_ref = min( yy_ref(:,1) );
max_x_ref = max( yy_ref(:,1) );
avg       = 0.5*( max_x_ref - min_x_ref );
min_x_ref_bound = min_x_ref - 5/100*avg;
max_x_ref_bound = max_x_ref + 5/100*avg;

% --> apply a small perturbation
sv0_dim = from_nondim_to_dim( sv0, strucNorm );

pos_pert_km   = 20;   % --> km
vel_pert_km_s = 1e-5; % --> km/s (1 cm/s)
% sv0_dim_pert  = apply_perturbation_dimensional( sv0_dim, pos_pert_km, vel_pert_km_s );

[ sv0_dim_pert, pos_pert_km_sigma, vel_pert_km_s_sigma ] = apply_perturbation_dimensional( sv0_dim, pos_pert_km, vel_pert_km_s );
sv0_pert      = from_dim_to_nondim( sv0_dim_pert, strucNorm );

pos_pert_km_sigma
vel_pert_km_s_sigma

num_periods = 1;
tt          = linspace(0, num_periods*orb_period, 1e3);
pars.mu     = strucNorm.normMu;
opt         = odeset('RelTol', 3e-13, 'AbsTol', 1e-13 );
[tt, yy]    = ode113( @(t, x) f_CR3BP(x, pars), tt, sv0_pert, opt );

subplot(2,1,1);

plot3( yy(:,1).*normDist, yy(:,2).*normDist, yy(:,3).*normDist, ...
    'LineStyle', '--', ...
    'Color', graycolor,...
    'LineWidth', 2, ...
    'HandleVisibility','off');

subplot(2,1,2);
plot( yy(:,1).*normDist, yy(:,2).*normDist, ...
    'LineStyle', '--', ...
    'Color', graycolor,...
    'LineWidth', 2, ...
    'HandleVisibility','off');

vline( min_x_ref_bound.*strucNorm.normDist, 'r--' );
vline( max_x_ref_bound.*strucNorm.normDist, 'r--' );

legend( 'Location', 'Best' );
