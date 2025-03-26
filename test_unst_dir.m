
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%% 

clc;

% Define the mass ratio for the Sun-Earth system

idcentral = 1; % --> Sun
idPlanet  = 3;  % --> Earth(+Moon)
strucNorm = wrapNormCR3BP(idcentral, idPlanet);
mu        = strucNorm.normMu;

lpoint                    = 'L2';
[ LagrPoint, gamma, vec ] = lagrange_point_and_gamma( strucNorm, lpoint );
xx                        = LagrPoint;

pars.mu                             = mu;
A                                   = A_matrix_stability( xx, pars );
[theta_unst, unstable_eigenvector]  = unstable_dir_linear_theory( A, vec );

% Display results
fprintf('Unstable direction angle: %.2f degrees\n', rad2deg(theta_unst));

%% --> another approach

close all; clc;

[ LagrPoint, gamma, k, c2, omp, omv, lambda ] = find_parameters_linear_theory( strucNorm, lpoint );

c     = (lambda^2 - 1 - 2*c2)/(2*lambda);

d1 = c*lambda + k*omp;
d2 = c*omp - k*lambda;

unst_vec = [ -k/d2, 1/d1 ];
stab_vec = [ 1/d1, k/d2 ];

unst_dir = atan2( 1/d1, -k/d2 );
stab_dir = atan2( k/d2, 1/d1 );

fprintf('Unstable direction angle : %.2f degrees\n', rad2deg(unst_dir));
fprintf('Stable direction angle   : %.2f degrees\n', rad2deg(stab_dir));

%% --> DV to change amplitude

close all; clc;

Ayf          = 250e3;
Ayi          = 600e3;
Delta_Ay_ACE = abs( Ayf - Ayi );

Delta_Ay = 50e3:50e3:850e3;
Delta_Az = Delta_Ay;

dv_y_l1 = Delta_Ay.* 3.7134e-7;  % --> km/s
dv_y_l2 = Delta_Ay.* 3.64800e-7; % --> km/s

dv_z_l1 = Delta_Az.* 4.0123e-7; % --> km/s
dv_z_l2 = Delta_Az.* 3.9523e-7; % --> km/s

dv_y_l1_ACE = Delta_Ay_ACE.* 3.7134e-7;  % --> km/s

% --> START: plot Delta-v to change amplitude
fig_delta_amplitude = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel( '\DeltaA [x10^3 km]' ); ylabel( '\Deltav [m/s]' );

plot( Delta_Ay./1e3, dv_y_l1*1e3, 'LineWidth', 2, 'DisplayName', 'A_y variation' );
plot( Delta_Az./1e3, dv_z_l1*1e3, 'LineWidth', 2, 'DisplayName', 'A_z variation' );

% plot( Delta_Ay_ACE./1e3, dv_y_l1_ACE*1e3, 'o', 'MarkerEdgeColor', 'black', ...
%     'MarkerFaceColor', 'green', 'DisplayName', 'ACE-like ' );

% --> increase the fontsize
plotFontSizeAxesDim(12, 12, fig_delta_amplitude)

lgd = legend( 'Location', 'Best');
lgd.NumColumns = 2;

name_fig_0 = ['\north_' 'amplitude_reduction'];
exportgraphics(fig_delta_amplitude, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig([pwd name_fig_0 '_' lpoint '.fig' ]);
% --> END: plot Delta-v to change amplitude

