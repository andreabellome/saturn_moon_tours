function [tt, xx_liss, Period, LagrPoint, c2, k, omp_squared, omv_squared, lambda_squared] = ...
    linearised_lissajous(  Ax, Az, m, phi, num_periods, mu, normDist, normTime, lpoint, LagrangePoints, Gammas )

% Ax and Az are given in km!!!!

if strcmpi(lpoint, 'L1')
    LagrPoint = LagrangePoints(1,:);
    gamma     = Gammas(1);
elseif strcmpi(lpoint, 'L2')
    LagrPoint = LagrangePoints(2,:);
    gamma     = Gammas(2);
end

% if m ~= 1 && m ~= 3
%     fprintf( 'm must be either 1 or 3 \n' );
%     
%     tt             = NaN;
%     xx_liss        = NaN;
%     Period         = NaN;
%     LagrPoint      = NaN;
%     c2             = NaN;
%     k              = NaN;
%     omp_squared    = NaN;
%     omv_squared    = NaN;
%     lambda_squared = NaN;
% 
% else
%     
    % --> phase angle for z motion
    psi = phi + m*pi/2;
    
    % --> find the c-parameter
    cn = c_parameter( mu, gamma, lpoint );
    c2 = cn(1);
    
    omp_squared   = ( 2 - c2 + sqrt( 9*c2^2 - 8*c2 ) )/2;
    omp           = sqrt( omp_squared );
    omv_squared   = c2;
    omv           = sqrt(omv_squared);
    k             = ( omp_squared + 1 + 2*c2 )/( 2*omp )
    
    lambda_squared = ( c2 - 2 + sqrt( 9*c2^2 - 8*c2 ) )/2;
    lambda         = sqrt(lambda_squared);
    
    Period = ( 2*pi - phi )/omp;

    tt = linspace( 0, num_periods*Period, 5e3 );

    Ax = Ax/normDist;
    Az = Az/normDist;
    
    x = -Ax.*cos( omp.*tt + phi );
    y = k.*Ax.*sin( omp.*tt + phi );
    z = Az.*sin( omv.*tt + psi );
    
    x_dot = Ax.*omp.*sin( omp.*tt + phi );
    y_dot = k.*Ax.*omp.*cos( omp.*tt + phi );
    z_dot = Az.*omv.*cos( omv.*tt + psi );

    xx_liss = [ x', y', z', x_dot', y_dot', z_dot' ];

% end

end
