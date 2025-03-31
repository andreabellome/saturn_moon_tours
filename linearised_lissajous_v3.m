function lissajous = linearised_lissajous_v3( Ay, Az, m, phi, tt, strucNorm, lpoint )

% !!! This uses another formulation for the Lissajous with respect to the
% one of Ross book (the two formulations are equivalent, but they are
% shifted in phases)

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

% --> phase angle for z motion
psi = phi + m*pi/2;

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

% --> non-dimensional units
Ay = Ay/normDist;
Az = Az/normDist;
Ax = Ay/k;

% --> this is centered in the primary-secondary barycenter
x = Ax.*cos( omp.*tt + phi ) + LagrPoint(1);
y = -Ay.*sin( omp.*tt + phi );
z = Az.*cos( omv.*tt + psi );

x_dot = -Ax.*omp.*sin( omp.*tt + phi );
y_dot = -Ay.*omp.*cos( omp.*tt + phi );
z_dot = -Az.*omv.*sin( omv.*tt + psi );

% --> put the states togeter
xx_liss = [ x', y', z', x_dot', y_dot', z_dot' ];
tt      = tt';

lissajous.Ax  = Ax*normDist;
lissajous.Ay  = Ay*normDist;
lissajous.Az  = Az*normDist;
lissajous.sv0 = xx_liss(1,:);

lissajous.norm_plot               = 86400 * 365.25 / strucNorm.normTime;

lissajous.orb_period_in_plane     = period_in_plane;
lissajous.orb_period_out_of_plane = period_out_of_plane;

lissajous.Jc  = NaN;
lissajous.tt  = tt;
lissajous.yy  = xx_liss;

lissajous.phi = phi;
lissajous.psi = psi;
lissajous.m   = m;

end

