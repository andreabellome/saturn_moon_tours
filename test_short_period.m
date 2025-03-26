
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%%

idcentral = 1; % --> Sun
idPlanet  = 3;  % --> Earth(+Moon)

strucNorm = wrapNormCR3BP(idcentral, idPlanet);

lpoint = 'L1';

[ LagrPoint, gamma ] = lagrange_point_and_gamma( strucNorm, lpoint );

% --> initial guess (the farther from the Lagrange point, the smaller the period...?)
% xx0 = [ 0.99 0 0 0 1e-4 0 ];  % --> THIS DOES NOT END...

% --> right to L1
% xx0 = [ 0.9899 0 0 0 1e-4 0 ];  % --> 136.53 days -- 12.25 m/s
% xx0 = [ 0.98988 0 0 0 1e-4 0 ]; % --> 126.10558 days -- 15.86 m/s
xx0 = [ 0.98987 0 0 0 1e-4 0 ]; % --> 120.94 days -- 17.68 m/s 

% --> left to L1
% xx0 = [ 0.98986 0 0 0 1e-4 0 ]; % --> 105.47 days -- 20.05 m/s 
xx0 = [ 0.98984 0 0 0 1e-4 0 ]; % --> 87.70 days -- 23.87 m/s
% xx0 = [ 0.98983 0 0 0 1e-4 0 ]; % --> 82.78 days -- 25.58 m/s

% xx0 = [ 0.97983 0 0 0 1e-4 0 ]; % --> XXXXX -- XXXXX

three_dim         = 1;
orb_period_ini    = 90 * 86400 / strucNorm.normTime;

useParallel = true;
tol                                         = 1e-13;
param.fsolveoptions                         = optimoptions('fsolve','Display','iter');
param.fsolveoptions.FunctionTolerance       = tol; 
param.fsolveoptions.StepTolerance           = tol;
param.fsolveoptions.OptimalityTolerance     = tol;
param.fsolveoptions.MaxFunctionEvaluations  = 500;
param.fsolveoptions.MaxIterations           = 500;
param.fsolveoptions.UseParallel             = useParallel;
param.odeoptions                            = odeset('RelTol', tol,'AbsTol',tol);
param.bvpoptions                            = bvpset('Stats','on','AbsTol', tol, 'RelTol', tol);

[dv0_sol, Fsol, flag]  = fsolve( @(dv0) prop_state( dv0, xx0, strucNorm, orb_period_ini, three_dim ), zeros(1,3), param.fsolveoptions);

% --> update the xx0 and propagate for the full period
xx0(4:6)                 = xx0(4:6) + dv0_sol;
xx0_original             = xx0;
[ svtf, full_state, tt ] = propagateCR3BP( xx0, orb_period_ini, strucNorm, 1e3, 1 );

STATES = full_state;

figure('Color', [1 1 1]);
hold on; grid on; 
xlabel('x [km]'); ylabel( 'y [km]' ); zlabel( 'z [km]' );
plot( LagrPoint(1)*strucNorm.normDist, 0, 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'cyan', 'DisplayName', lpoint );

plot3( full_state(1,1)*strucNorm.normDist, full_state(1,2)*strucNorm.normDist, full_state(1,3)*strucNorm.normDist, 's', 'HandleVisibility', 'off' );
plot3( full_state(:,1).*strucNorm.normDist, full_state(:,2).*strucNorm.normDist, full_state(:,3).*strucNorm.normDist, 'LineWidth', 2, 'HandleVisibility', 'off' );

[ svtf, full_state, tt ] = propagateCR3BP( svtf,  tt(end,:), strucNorm, 1e3 );      
dv_km_s                  = norm( xx0_original(:,4:6) - svtf(:,4:6) ) * strucNorm.normVel;

hold on; grid on; 
plot3( full_state(:,1).*strucNorm.normDist, full_state(:,2).*strucNorm.normDist, full_state(:,3).*strucNorm.normDist, 'LineWidth', 2, 'HandleVisibility', 'off' );

legend( 'Location', 'southwest' );

orbital_period_days = tt(end,:) * strucNorm.normTime / 86400 * 2;

if three_dim == 1
    view( [ -17 33 ] );
    legend( 'Location', 'Best' );
end

labelsDim = 12;
axesDim   = 12;
set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(gcf, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

name_fig_0 = ['\strange_orbit_period_' num2str(round(orbital_period_days)) '_three_dim'];

exportgraphics(gcf, [pwd name_fig_0 '_' lpoint '.png' ], 'Resolution', 1200);
savefig([pwd name_fig_0 '_' lpoint '.fig' ]); % Save the figure as a .fig file

fprintf( '\n Orbital period is : %.2f days \n', orbital_period_days );
fprintf( ' Delta-v is        : %.2f m/s \n', dv_km_s*1e3 );

STATES = [STATES; full_state];

%%

figure('Color', [1 1 1]);
hold on; grid on; 
xlabel('x [AU]'); ylabel( 'y [AU]' );
plot( LagrPoint(1), 0, 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'cyan', 'DisplayName', lpoint );

plot3( STATES(:,1), STATES(:,2), STATES(:,3), 'LineWidth', 2, 'HandleVisibility', 'off' );

