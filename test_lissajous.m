
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%% 

idcentral = 30; % --> Sun
idPlanet  = 1; % --> Earth(+Moon)

strucNorm = wrapNormCR3BP(idcentral, idPlanet);

mu       = strucNorm.normMu;
normDist = strucNorm.normDist;
normTime = strucNorm.normTime;

x1 = strucNorm.x1;
x2 = strucNorm.x2;

xx1 = [ x1 0 0 ]; % --> primary position
xx2 = [ x2 0 0 ]; % --> secondary position

LagrangePoints = strucNorm.LagrangePoints;
Gammas         = vecnorm( [LagrangePoints - xx2]' )'; % --> distance between the secondary and the L-points

Ax = 1e3;
Az = 500;

lpoint      = 'L2';
m           = 1;
phi         = 0;
num_periods = 1;

% --> generate linearised Lissajous orbits
[tt, xx_liss, Period, LagrPoint, c2, k, omp_squared, omv_squared, lambda_squared] = ...
    linearised_lissajous(  Ax, Az, m, phi, num_periods, ...
                          mu, normDist, normTime, lpoint, LagrangePoints, Gammas );

xx_liss_dim        = xx_liss;
xx_liss_dim(:,1:3) = xx_liss_dim(:,1:3).*normDist;
xx_liss_dim(:,4:6) = xx_liss_dim(:,4:6).*normDist./normTime;

xx_L_centered      = xx_liss;
xx_L_centered(:,1) = xx_liss(:,1) - LagrPoint(1);
xx_L_centered_dim(:,1:3)  = xx_L_centered(:,1:3).*normDist;
xx_L_centered_dim(:,4:6)  = xx_L_centered(:,4:6).*normDist./normTime;

close all; clc;

% --> plot centered in L1 - XY
figure( 'Color', [1 1 1] );
hold on; grid on; axis('equal');
xlabel( 'x [km]' ); ylabel( 'y [km]' );

plot3( LagrPoint(1).*normDist - LagrPoint(1).*normDist, LagrPoint(2).*normDist, LagrPoint(3).*normDist, ...
    'o', ...
    'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', 'Red' );

plot( xx_liss(:,1).*normDist, xx_liss(:,2).*normDist, ...
    'LineWidth', 2 );

title( ['Centered in ' num2str(lpoint)] );

%%

% --> plot centered in L1 - XZ
figure( 'Color', [1 1 1] );
hold on; grid on; axis('equal');
xlabel( 'x [km]' ); ylabel( 'z [km]' );

plot3( LagrPoint(1).*normDist - LagrPoint(1).*normDist, LagrPoint(2).*normDist, LagrPoint(3).*normDist, ...
    'o', ...
    'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', 'Red' );

plot( xx_liss(:,1).*normDist, xx_liss(:,3).*normDist, ...
    'LineWidth', 2 );

title( ['Centered in ' num2str(lpoint)] );

% --> plot centered in L1
figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel( 'x [km]' ); ylabel( 'y [km]' );  zlabel( 'z [km]' ); 

plot3( LagrPoint(1).*normDist - LagrPoint(1).*normDist, LagrPoint(2).*normDist, LagrPoint(3).*normDist, ...
    'o', ...
    'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', 'Red' );

plot3( xx_liss(:,1).*normDist, xx_liss(:,2).*normDist, xx_liss(:,3).*normDist, ...
    'LineWidth', 2 );

title( ['Centered in ' num2str(lpoint)] );

view( [124 9] );
% view( [-180 0] );

%%

close all; clc;

Az = linspace( 0, 500e3, 1000 );
Ax = fromAz_toAx_halo_sun_earth_l1(Az, normDist);

figure( 'Color', [1 1 1] );
hold on; grid on; 
xlabel( 'Az [km]' ); ylabel( 'Ax [km]' );
plot( Az, Ax, 'LineWidth', 2 );

%%

Ax = -3e3/normDist;
% Ay = -210e3/normDist;
Az = -3e3/normDist;

lpoint = 'L1';

if strcmpi(lpoint, 'L2')
    Txy       = 177.655*24*3600;
    Tz        = 184.0*24*3600;
    LagrPoint = strucNorm.LagrangePoints(2,:);
elseif strcmpi(lpoint, 'L1')
    Txy       = 174.938133009*24*3600;
    Tz        = 181.122661775*24*3600;
    LagrPoint = strucNorm.LagrangePoints(1,:);
end

Ay = Ax * 3.1872293;
% Ax = Ay/3.1872293;

Wxy = 2*pi/Txy;
Wz  = 2*pi/Tz;

Pxy = 0;
Pz  = 270*pi/180;

tt = linspace( 0, 10*180*86400, 1e3 );

x = Ax.*cos( Wxy.*tt + Pxy ) + LagrPoint(1);
y = -Ay.*sin( Wxy.*tt + Pxy );
z = Az.*cos( Wz.*tt + Pz );

x_dot = -Ax.*Wxy.*sin( Wxy.*tt + Pxy );
y_dot = -Ay.*Wxy.*cos( Wxy.*tt + Pxy );
z_dot = -Az.*Wz.*sin( Wz.*tt + Pz );

xx0     = [ x(1) y(1) z(1) ];
xx0_dot = [ x_dot(1) y_dot(1) z_dot(1) ];

xx0_Earth_centered = xx0;
xx0_Earth_centered(1) = xx0(1) - x2;  % Shift the x position by Earth's location

xx                     = [ x', y', z' ];
xx_Earth_centered      = xx;
xx_Earth_centered(:,1) = xx(:,1) - x2;
xx_Earth_centered_dim  = xx_Earth_centered.*normDist;

xx_L_centered      = xx;
xx_L_centered(:,1) = xx(:,1) - LagrPoint(1);
xx_L_centered_dim  = xx_L_centered.*normDist;

%%

% --> plot centered in L1
figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel( 'x' ); ylabel( 'y' );  zlabel( 'z' ); 

plot3( LagrPoint(1).*normDist - LagrPoint(1).*normDist, LagrPoint(2).*normDist, LagrPoint(3).*normDist, ...
    'o', ...
    'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', 'Red' );

plot3( xx_L_centered_dim(:,1), xx_L_centered_dim(:,2), xx_L_centered_dim(:,3), 'LineWidth', 2 );

title( ['Centered in ' num2str(lpoint)] );

view( [124 9] );
view( [-180 0] );

%%

close all;

figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel( 'x' ); ylabel( 'y' );  zlabel( 'z' ); 

plot3( LagrPoint(1).*normDist, LagrPoint(2).*normDist, LagrPoint(3).*normDist, ...
    'o', ...
    'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', 'Red' );

plot3( x(1).*normDist, y(1).*normDist, z(1).*normDist, ...
    'o', ...
    'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', 'Blue');

plot3( x.*normDist, y.*normDist, z.*normDist, 'LineWidth', 2 );

view( [124 9] );

%%

figure( 'Color', [1 1 1] );
hold on; grid on;

plot( tt, xx_L_centered_dim(:,1), 'LineWidth', 2, 'DisplayName', 'X' );
plot( tt, xx_L_centered_dim(:,2), 'LineWidth', 2, 'DisplayName', 'Y' );
plot( tt, xx_L_centered_dim(:,3), 'LineWidth', 2, 'DisplayName', 'Z' );

legend( 'Location', 'Best' );
