
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%% 

idcentral = 1;  % --> Sun
idPlanet  = 3;  % --> Earth(+Moon)

strucNorm = wrapNormCR3BP(idcentral, idPlanet);
mu        = strucNorm.normMu;
normDist  = strucNorm.normDist;
normTime  = strucNorm.normTime;

% --> compute Halos (north)
lpoint               = 'L1';
Az_vect              = 50e3:50e3:850e3;
[halo_orbits_l1, f1] = wrap_halo_family( Az_vect, lpoint, strucNorm );

%%

close all; clc;

Ax = zeros( length(Az_vect),1 );
for indz = 1:length(Az_vect)
    [ xx0, orb_period_ini, Ax(indz,1) ] = halo_initial_guess( Az_vect(indz), 0, lpoint, strucNorm );
end
Ax_dim = Ax.*normDist;

indz = 3; % --> similar to ACE (Az approx. 150e3)

% --> this is to have similar initial conditions to the 'full' Halo
phiH         = pi;    % --> in-plane-phase (phiH = pi to be the similar to the 'full' Halo)
mH           = 2;       % --> out-of-plane phase : psi = phi + m*pi/2 --> psi = pi 
num_periods  = 0.5;
phi          = phiH;
m            = mH;

% phi         = 0;
% m           = 1;
% num_periods = 1;

dv_1 = zeros( length(Az_vect), 1 );
for indz = 1:length(Az_vect)

    Az = Az_vect(indz);
    
    % AyL          = 264e3; % --> ACE
    
    halo_linear = linearised_halo_v2( Az, mH, phiH, 4, strucNorm, lpoint );
    AyH          = halo_linear.Ay; Ay = AyH; AyL = AyH;
    
    % phi       = pi/2;
    % m         = 2;
    
    lissajous = linearised_lissajous_v2( AyL, Az, m, phi, 3, strucNorm, lpoint );
    
    sv0_liss             = lissajous.sv0;
    sv0_halo_linear      = halo_linear.sv0;
    sv0_halo_third_order = halo_linear.sv0_third_order;
    sv0_halo             = halo_orbits_l1(indz).sv0;
    
    if norm(sv0_liss(1,1:3) - sv0_halo_linear(1,1:3)) <= 1e-6
        dv_1(indz,1) = norm( sv0_liss(1,4:6) - sv0_halo_linear(1,4:6) ).*normDist./normTime;
        fprintf( '\n Cost from Halo to Lissajous: %.3f m/s \n', dv_1(indz,1)*1e3 );
    else
        fprintf( '\n Initial ositions are not the same \n' );
    end

end

%%

% --> this is to have similar initial conditions to the 'full' Halo
phiH         = pi/2;    % --> in-plane-phase (phiH = pi to be the similar to the 'full' Halo)
mH           = 2;       % --> out-of-plane phase : psi = phi + m*pi/2 --> psi = pi 
num_periods  = 0.5;
phi          = phiH;
m            = mH;

% phi         = 0;
% m           = 1;
% num_periods = 1;

dv_2 = zeros( length(Az_vect), 1 );
for indz = 1:length(Az_vect)

    Az = Az_vect(indz);
    
    % AyL          = 264e3; % --> ACE
    
    halo_linear = linearised_halo_v2( Az, mH, phiH, 4, strucNorm, lpoint );
    AyH          = halo_linear.Ay; Ay = AyH; AyL = AyH;
    
    % phi       = pi/2;
    % m         = 2;
    
    lissajous = linearised_lissajous_v2( AyL, Az, m, phi, 3, strucNorm, lpoint );
    
    sv0_liss             = lissajous.sv0;
    sv0_halo_linear      = halo_linear.sv0;
    sv0_halo_third_order = halo_linear.sv0_third_order;
    sv0_halo             = halo_orbits_l1(indz).sv0;
    
    if norm(sv0_liss(1,1:3) - sv0_halo_linear(1,1:3)) <= 1e-6
        dv_2(indz,1) = norm( sv0_liss(1,4:6) - sv0_halo_linear(1,4:6) ).*normDist./normTime;
        fprintf( '\n Cost from Halo to Lissajous: %.3f m/s \n', dv_2(indz,1)*1e3 );
    else
        fprintf( '\n Initial ositions are not the same \n' );
    end

end


%%

close all; 

% --> START: delta-v from Halo to Lissajous
fig_dv_halo_liss = figure( 'Color', [1 1 1] );
hold on; grid on;

xlabel( 'A_z [x10^3 km]' ); ylabel( '\Deltav [m/s]' );

plot( Az_vect./1e3, dv_1*1e3, 'LineWidth', 2, 'DisplayName', '\phi=\pi and \psi=0' );
plot( Az_vect./1e3, dv_2*1e3, 'LineWidth', 2, 'DisplayName', '\phi=\pi/2 and \psi=3\pi/2' );

% --> increase the fontsize
plotFontSizeAxesDim(12, 12, fig_dv_halo_liss);

lgd = legend( 'Location', 'Best');
lgd.NumColumns = 2;

name_fig_0 = ['\north_' 'dv_halo_to_liss'];
exportgraphics(fig_dv_halo_liss, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig([pwd name_fig_0 '_' lpoint '.fig' ]);
% --> END: delta-v from Halo to Lissajous

%%

close all;

% --> START: linear halo plot
yy_linear = halo_linear.yy;
yy_full   = halo_orbits_l1(indz).yy;
yy_liss   = lissajous.yy;

fig_linear_halo = figure( 'Color', [1 1 1], 'WindowState', 'maximized' );
hold on; grid on;

plot3( strucNorm.x2, 0, 0, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'cyan', 'HandleVisibility', 'off' );
plot3( strucNorm.LagrangePoints(1,1), 0, 0, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'blue', 'HandleVisibility', 'off' );

plot3( yy_full(1,1), yy_full(1,2), yy_full(1,3), 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'red', 'DisplayName', 'Halo initial conditions' );
plot3( yy_linear(1,1), yy_linear(1,2), yy_linear(1,3), 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'magenta', 'DisplayName', 'Halo/Lissajous initial conditions (linear)' );
plot3( yy_liss(1,1), yy_liss(1,2), yy_liss(1,3), 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'magenta', 'HandleVisibility', 'off' );

plot3( yy_linear(:,1), yy_linear(:,2), yy_linear(:,3), 'LineWidth', 2, 'Color', 'magenta', 'DisplayName', 'Halo - linear theory' );
plot3( yy_liss(:,1), yy_liss(:,2), yy_liss(:,3), '--', 'LineWidth', 2, 'Color', 'black', 'DisplayName', 'Lissajous - linear theory' );

plot3( yy_full(:,1), yy_full(:,2), yy_full(:,3), 'LineWidth', 2, 'color', 'red', 'DisplayName', 'Halo orbit' );

lgd            = legend( 'Location', 'best' );
lgd.NumColumns = 2;

view( [20 22] );

labelsDim = 12;
axesDim   = 12;
set(findall(fig_linear_halo,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(fig_linear_halo, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 
% --> END: linear halo plot

%%

% --> START: plot Ax/Ay/Az
fig_ax_ay_az = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel( 'A_z [x10^3 km]' ); ylabel( 'A_x [x10^3 km]' ); 

plot( [ halo_orbits_l1.Az ]'./1e3, [ halo_orbits_l1.Ax ]'./1e3, 'LineWidth', 2 );
% --> END: plot Ax/Ay/Az

% --> START: plot period
fig_period = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel( 'A_z [x10^3 km]' ); ylabel( 'A_x [x10^3 km]' ); 

plot( [ halo_orbits_l1.Az ]'./1e3, [ halo_orbits_l1.orb_period ]'.*normTime./86400, 'LineWidth', 2 );
% --> END: plot Ax/Ay/Az

