clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%% 

clc;

% Define the mass ratio for the Sun-Earth system

idcentral = 30; % --> Sun
idPlanet  = 1;  % --> Earth(+Moon)
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
