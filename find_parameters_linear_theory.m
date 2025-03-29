function [ LagrPoint, gamma, k, c2, omp, omv, lambda, period_in_plane, period_out_of_plane ] = find_parameters_linear_theory( strucNorm, lpoint )

% DESCRIPTION
% This function computes key parameters associated with the linearized 
% dynamics around a given Lagrange point (L1 or L2) in the Circular 
% Restricted Three-Body Problem (CR3BP). It determines the location of 
% the Lagrange point, characteristic distances, stability parameters, 
% and oscillation periods in the in-plane and out-of-plane directions. 
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
% - LagrPoint          : coordinates of the selected Lagrange point
% - gamma              : distance between the secondary body and Lagrange point
% - k                  : stability parameter
% - c2                 : second-order coefficient of the potential expansion
% - omp                : frequency of in-plane oscillations
% - omv                : frequency of out-of-plane oscillations
% - lambda             : instability parameter
% - period_in_plane    : period of in-plane oscillations
% - period_out_of_plane: period of out-of-plane oscillations
%
% -------------------------------------------------------------------------


mu             = strucNorm.normMu;
normDist       = strucNorm.normDist;
x2             = strucNorm.x2;
xx2            = [ x2 0 0 ];                            % --> secondary position
LagrangePoints = strucNorm.LagrangePoints;
Gammas         = vecnorm( [LagrangePoints - xx2]' )';   % --> distance between the secondary and the L-points

if strcmpi(lpoint, 'L1')
    LagrPoint = LagrangePoints(1,:);
    gamma     = Gammas(1);
elseif strcmpi(lpoint, 'L2')
    LagrPoint = LagrangePoints(2,:);
    gamma     = Gammas(2);
end

% --> find the c-parameter
cn = c_parameter( mu, gamma, lpoint );
c2 = cn(1);

omp_squared   = ( 2 - c2 + sqrt( 9*c2^2 - 8*c2 ) )/2;
omp           = sqrt( omp_squared );
omv_squared   = c2;
omv           = sqrt(omv_squared);
k             = ( omp_squared + 1 + 2*c2 )/( 2*omp );

lambda_squared = ( c2 - 2 + sqrt( 9*c2^2 - 8*c2 ) )/2;
lambda         = sqrt(lambda_squared);

period_in_plane     = ( 2*pi )/omp;
period_out_of_plane = ( 2*pi )/omv;

end
