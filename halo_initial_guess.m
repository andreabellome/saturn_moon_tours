function [ xx0, orb_period_ini ] = halo_initial_guess( Az, t, lpoint, strucNorm )

% Az is given in km!!!

mu       = strucNorm.normMu;
normDist = strucNorm.normDist;
normTime = strucNorm.normTime;

x1 = strucNorm.x1;
x2 = strucNorm.x2;

xx1 = [ x1 0 0 ]; % --> primary position
xx2 = [ x2 0 0 ]; % --> secondary position

LagrangePoints = strucNorm.LagrangePoints;
Gammas         = vecnorm( [LagrangePoints - xx2]' )'; % --> distance between the secondary and the L-points

if strcmpi(lpoint, 'L1')
    LagrPoint = LagrangePoints(1,:);    % --> L-point
    gamma     = Gammas(1);              % --> distance between L-point and the secondary
elseif strcmpi(lpoint, 'L2')
    LagrPoint = LagrangePoints(2,:);    % --> L-point
    gamma     = Gammas(2);              % --> distance between L-point and the secondary
end

Az_ad = Az/normDist/gamma;

cn = c_parameter( mu, gamma, lpoint );
c2 = cn(1);
c3 = cn(2);
c4 = cn(3);

lambdaL = sqrt((-c2 + 2.0 + sqrt(9.0 * c2^2 - 8.0 * c2)) / 2.0);
k       = 2.0 * lambdaL/(lambdaL^2 + 1.0 - c2);

delta = lambdaL^2 - c2;
d1 = 16.0 * lambdaL^4 + 4.0 * lambdaL^2 * (c2 - 2.0) - 2.0 * c2^2 + c2 + 1.0;
d2 = 81.0 * lambdaL^4 + 9.0 * lambdaL^2 * (c2 - 2.0) - 2.0 * c2^2 + c2 + 1.0;
d3 = 2.0 * lambdaL * (lambdaL * (1.0 + k^2) - 2.0 * k);
a21 = 3.0 * c3 * (k^2 - 2.0) / 4.0 / (1.0 + 2.0 * c2);
a23 = -3.0 * lambdaL * c3 * (3.0 * k^3 * lambdaL - 6.0 * k * (k - lambdaL) + 4.0) / 4.0 / k / d1;
b21 = -3.0 * c3 * lambdaL * (3.0 * lambdaL * k - 4.0) / 2.0 / d1;
s1 = ((3.0 / 2.0) * c3 * (2.0 * a21 * (k^2 - 2.0) - a23 * (k^2 + 2.0)- 2.0 * k * b21) - (3.0 / 8.0) * c4 * (3.0 * k^4 - 8.0 * k^2 + 8.0)) / d3;
a22 = 3.0 * c3 / 4.0 / (1.0 + 2.0 * c2);
a24 = -3.0 * c3 * lambdaL * (2.0 + 3.0 * lambdaL * k) / 4.0 / k / d1;
b22 = 3.0 * lambdaL * c3 / d1;
d21 = -c3 / 2.0 / lambdaL^2;
s2 = ((3.0 / 2.0) * c3 * (2.0 * a22 * (k^2 - 2.0) + a24 * (k^2 + 2.0) + 2.0 * k * b22 + 5.0 * d21) + (3.0 / 8.0) * c4 * (12.0 - k^2)) / d3;
a1 = -(3.0 / 2.0) * c3 * (2.0 * a21 + a23 + 5.0 * d21) - (3.0 / 8.0) * c4 * (12.0 - k^2);
a2 = (3.0 / 2.0) * c3 * (a24 - 2.0 * a22) + (9.0 / 8.0) * c4;
l1 = 2.0 * s1 * lambdaL^2 + a1;
l2 = 2.0 * s2 * lambdaL^2 + a2;

az_sqr = Az_ad^2;

if abs( l1 ) > 0
    term = (-l2 * az_sqr - delta) / l1;
else
    fprintf("Divide by zero!! \n");
    
    xx0            = NaN.*ones( 1, 6 );
    orb_period_ini = NaN;
    return
end

ax = sqrt(term);
ax_sqr = ax^2;

w = 1.0 + s1 * ax_sqr + s2 * az_sqr;

a31 = (-9.0 * lambdaL * (c3 * (k * a23 - b21) + k * c4 * (1.0 + (1.0 / 4.0) * k^2)) / d2 + (9.0 * lambdaL^2 + 1.0 - c2) * (3.0 * c3 * (2.0 * a23 - k * b21) + c4 * (2.0 + 3.0 * k^2)) / 2.0 / d2);

a32 = (-9.0 * lambdaL * (4.0 * c3 * (k * a24 - b22) + k * c4) / 4.0 / d2 - 3.0 * (9.0 * lambdaL^2 + 1.0 - c2) * (c3 * (k * b22 + d21 - 2.0 * a24) - c4) / 2.0 / d2);

b31 = (3.0 * lambdaL * (3.0 * c3 * (k * b21 - 2.0 * a23) - c4 * (2.0 + 3.0 * k^2)) + (9.0 * lambdaL^2 + 1.0 + 2.0 * c2) * (12.0 * c3 * (k * a23 - b21) + 3.0 * k * c4 * (4.0 + k^2)) / 8.0) / d2;

b32 = ((3.0 * lambdaL * (3.0 * c3 * (k * b22 + d21 - 2.0 * a24) - 3.0 * c4) + (9.0 * lambdaL^2 + 1.0 + 2.0 * c2) * (12.0 * c3 * (k * a24 - b22) +  3.0 * c4 * k) / 8.0) / d2);

d31 = 3.0 * (4.0 * c3 * a24 + c4) / 64.0 / lambdaL^2;
d32 = 3.0 * (4.0 * c3 * (a23 - d21) + c4 * (4.0 + k^2)) / 64.0 / lambdaL^2;

hclass = 1;
delta_n = 2 - hclass;

r_halo_x = (a21 * ax_sqr + a22 * az_sqr - ax * cos(t) + (a23 * ax_sqr - a24 * az_sqr) * cos(2.0 * t) + (a31 * ax^3 - a32 * ax * az_sqr) * cos(3.0 * t));
r_halo_y = (k * ax * sin(t) + (b21 * ax_sqr - b22 * az_sqr) * sin(2.0 * t) + (b31 * ax^3 - b32 * ax * az_sqr) * sin(3.0 * t));
r_halo_z = (delta_n * (Az_ad * cos(t) + d21 * ax * Az_ad * (cos(2.0 * t) - 3.0) + (d32 * Az_ad * ax_sqr - d31 * Az_ad^3) * cos(3.0 * t)));

v_halo_x = (ax * sin(t) - (a23 * ax_sqr - a24 * az_sqr) * sin(2.0 * t) * 2.0 - (a31 * ax^3 - a32 * ax * az_sqr) * sin(3.0 * t) * 3.0);
v_halo_y = (k * ax * cos(t) + (b21 * ax_sqr - b22 * az_sqr) * cos(2.0 * t) * 2.0 + (b31 * ax^3 - b32 * ax * az_sqr) * cos(3.0 * t) * 3.0);
v_halo_z = (delta_n * (-Az_ad * sin(t) + d21 * ax * Az_ad * (-sin(2.0 * t) * 2.0) - (d32 * Az_ad * ax_sqr - d31 * Az_ad^3) * sin(3.0 * t) * 3.0));

r_crtbp_x = r_halo_x * gamma;
r_crtbp_y = r_halo_y * gamma;
r_crtbp_z = r_halo_z * gamma;
v_crtbp_x = v_halo_x * gamma * (lambdaL * w);
v_crtbp_y = v_halo_y * gamma * (lambdaL * w);          
v_crtbp_z = v_halo_z * gamma * (lambdaL * w);

r_crtbp_x = r_crtbp_x + LagrPoint(1);

xx0            = [ r_crtbp_x, r_crtbp_y, r_crtbp_z, v_crtbp_x, v_crtbp_y, v_crtbp_z ];
orb_period_ini = 2.0 * pi / (lambdaL * w);

end