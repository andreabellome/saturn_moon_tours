function [ LagrPoint, gamma, k, c2, omp, omv, lambda, period_in_plane, period_out_of_plane ] = find_parameters_linear_theory( strucNorm, lpoint )

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
