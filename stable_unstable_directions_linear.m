function [ unst_vec, stab_vec, unst_dir, stab_dir ] = stable_unstable_directions_linear( strucNorm, lpoint )

% DESCRIPTION
% This function computes the stable and unstable directions associated 
% with the linearized dynamics around a given Lagrange point (L1 or L2) 
% in the Circular Restricted Three-Body Problem (CR3BP). It determines 
% the corresponding eigenvectors and their respective angular directions.
% The parameter Az represents the amplitude of the orbit.
% 
% INPUT
% - strucNorm : structure containing normalized parameters of the system, 
%               including:
%               * normMu          - normalized gravitational parameter
%               * normDist        - normalized distance between primaries
%               * x2              - secondary body x-position
%               * LagrangePoints  - coordinates of Lagrange points
% - lpoint    : string specifying the Lagrange point ('L1' or 'L2')
% 
% OUTPUT
% - unst_vec  : unstable eigenvector components
% - stab_vec  : stable eigenvector components
% - unst_dir  : angular direction of the unstable eigenvector (radians)
% - stab_dir  : angular direction of the stable eigenvector (radians)
%
% -------------------------------------------------------------------------


% --> find the parameters of the problem
[ ~, ~, k, c2, omp, ~, lambda ] = find_parameters_linear_theory( strucNorm, lpoint );

% --> find stable and unstable vectors
c     = (lambda^2 - 1 - 2*c2)/(2*lambda);

d1 = c*lambda + k*omp;
d2 = c*omp - k*lambda;

unst_vec = [ -k/d2, 1/d1 ];
stab_vec = [ 1/d1, k/d2 ];

% --> find stable and unstable directions
unst_dir = atan2( 1/d1, -k/d2 );
stab_dir = atan2( k/d2, 1/d1 );

end