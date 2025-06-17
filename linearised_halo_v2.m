function halo_linear = linearised_halo_v2( Az, m, phi, num_periods, strucNorm, lpoint, Ay )

% !!! This uses another formulation for the Lissajous with respect to the
% one of Ross book (the two formulations are equivalent, but they are
% shifted in phases)

LagrangePoints = strucNorm.LagrangePoints;
normDist       = strucNorm.normDist;
x2             = strucNorm.x2;
xx2            = [ x2 0 0 ];                            % --> secondary position
Gammas         = vecnorm( [LagrangePoints - xx2]' )';   % --> distance between the secondary and the L-points

if strcmpi(lpoint, 'L1')
    LagrPoint = LagrangePoints(1,:);
    gamma     = Gammas(1);
elseif strcmpi(lpoint, 'L2')
    LagrPoint = LagrangePoints(2,:);
    gamma     = Gammas(2);
end

[ xx0_initial_guess, orb_period, Ax, k ] = halo_initial_guess( Az, 0, lpoint, strucNorm );
Az                                       = Az./strucNorm.normDist;

if nargin == 6
    Ay = Ax.*k;
elseif nargin == 7 % --> Ay is specified --> is not a 'pure' Halo
    Ay = Ay/strucNorm.normDist;
    Ax = Ay/k;
end

tt = linspace( 0, num_periods*orb_period, 5e3 );

om = 2*pi/orb_period;

% --> phase angle for z motion
psi = phi + m*pi/2;
rad2deg(psi)

% --> this is centered in the primary-secondary barycenter
x = Ax.*cos( om.*tt + phi ) + LagrPoint(1);
y = -Ay.*sin( om.*tt + phi );
z = Az.*cos( om.*tt + psi );

x_dot = -Ax.*om.*sin( om.*tt + phi );
y_dot = -Ay.*om.*cos( om.*tt + phi );
z_dot = -Az.*om.*sin( om.*tt + psi );

% --> put the states togeter
xx_halo = [ x', y', z', x_dot', y_dot', z_dot' ];
tt      = tt';

halo_linear.Ax  = Ax*normDist;
halo_linear.Ay  = Ay*normDist;
halo_linear.Az  = Az*normDist;
halo_linear.sv0 = xx_halo(1,:);

halo_linear.sv0_third_order = xx0_initial_guess;

halo_linear.norm_plot      = orb_period;

halo_linear.orb_period     = orb_period;

halo_linear.Jc = NaN;
halo_linear.tt  = tt;
halo_linear.yy  = xx_halo;

end

