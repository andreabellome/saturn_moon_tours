
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%% 

idcentral = 1;
idPlanet  = 3;

strucNorm = wrapNormCR3BP(idcentral, idPlanet);

mu       = strucNorm.normMu;
normDist = strucNorm.normDist;
normTime = strucNorm.normTime;

%%

xx0       = [ 0.9890039, 0, 0.00378038, 0,  0.01070311, 0 ];
dvPert    = 0*10e-6*rand(1,3)*( normTime/normDist );
xx0(4:6)  = xx0(4:6) + dvPert;

opt       = odeset('RelTol', 3e-13, 'AbsTol', 1e-13 );
opt.Events = @stopconditions;
pars.mu   = mu;
[tt, yy1] = ode113( @(t, x) f_CR3BP(x, pars), linspace(0, 6.05, 15e3), xx0, opt );

yy1_rot      = yy1;
yy1_rot(:,1) = yy1(:,1) - ( 1 - mu );

yy1_rot(end,:)

%%

clc;

useParallel = false;

tol                                         = 1e-13;
param.fsolveoptions                         = optimoptions('fsolve','Display','iter');
param.fsolveoptions.FunctionTolerance       = tol; 
param.fsolveoptions.StepTolerance           = tol;
param.fsolveoptions.OptimalityTolerance     = tol;
param.fsolveoptions.MaxFunctionEvaluations  = 100e3;
param.fsolveoptions.MaxIterations           = 100e3;
param.fsolveoptions.UseParallel             = useParallel;
param.odeoptions                            = odeset('RelTol', tol,'AbsTol',tol);
param.bvpoptions                            = bvpset('Stats','on','AbsTol', tol, 'RelTol', tol);

close all; clc;

figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel( 'x' ); ylabel( 'y' );  zlabel( 'x' ); 

for ind = 1:30

%     [dv0_sol, Fsol, flag] = fmincon( @(dv0) obj_func(dv0), 0.0, [], [], [], [], [], [], ...
%         @(dv0) propagate_perturbed_fmincon(dv0, xx0, pars) );

    [dv0_sol, Fsol, flag]  = fsolve(@(dv0) propagate_perturbed( dv0, xx0, pars ), ...
                                zeros(1), ...
                                param.fsolveoptions);
    
    [Fval, tt, yy1, yy1_rot] = propagate_perturbed( dv0_sol, xx0, pars );
    
    dvv0_sol_dim = dv0_sol*normDist/normTime;
    dv0_sol_dim(ind)  = norm(dvv0_sol_dim);
    
    xx0 = yy1(end,:);

    plot3( yy1(:,1), yy1(:,2), yy1(:,3), 'LineWidth', 2 );

    st = 1;

end

dv0_sol_dim_cum_sum = cumsum(dv0_sol_dim);

figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel( 'x' ); ylabel( 'Delta-v [m/s]' );
plot( dv0_sol_dim_cum_sum.*1e3 );

%%

close all; clc;

figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel( 'x' ); ylabel( 'y' );  zlabel( 'x' ); 

plot3( yy1(1,1), yy1(1,2), yy1(1,3), 'o', ...
    'MarkerEdgeColor', 'black', ...
    'MarkerFaceColor', 'red');

plot3( yy1(:,1), yy1(:,2), yy1(:,3), 'LineWidth', 2 );

%%

figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel( 'x' ); ylabel( 'y' );  zlabel( 'x' ); 

plot3( yy1_rot(1,1), yy1_rot(1,2), yy1_rot(1,3), 'o', ...
    'MarkerEdgeColor', 'black', ...
    'MarkerFaceColor', 'red');

plot3( yy1_rot(:,1), yy1_rot(:,2), yy1_rot(:,3), 'LineWidth', 2 );


