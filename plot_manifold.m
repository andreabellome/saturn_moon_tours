function [  ] = plot_manifold(  )

normDist = strucNorm.normDist;

fprintf( 'Plotting requested. Propagating the manifold... \n' );

% --> time-propagation
t_prop = 1.5*orbital_period;

fig = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel( 'x [km]' ); ylabel( 'y [km]' ); zlabel( 'z [km]' );

% --> this is the orbit
plot3( full_state(:,1).*normDist, full_state(:,2).*normDist, full_state(:,3).*normDist, 'color', 'k', 'LineWidth', 3, 'HandleVisibility', 'Off' );

% --> plot the secondary
plot3( strucNorm.x2.*normDist, 0, 0, 'o', 'MarkerEdgeColor', 'k', ...
'MarkerFaceColor', 'blue', 'MarkerSize', 8, ...
'DisplayName', 'Secondary body' );

% --> plot the L-points
plot3( strucNorm.LagrangePoints(1).*normDist, 0, 0, 'o', 'MarkerEdgeColor', 'k', ...
    'MarkerFaceColor', 'red', 'MarkerSize', 8, ...
    'DisplayName', 'L1' );

plot3( strucNorm.LagrangePoints(2).*normDist, 0, 0, 'o', 'MarkerEdgeColor', 'k', ...
    'MarkerFaceColor', 'cyan', 'MarkerSize', 8, ...
    'DisplayName', 'L2' );

% --> these are the manifolds
if strcmpi(manifold_plot, 'unstable') || strcmpi(manifold_plot, 'un')

    % --> plot un-stable manifold
    for indez = 1:size(sv0_us, 1)
        
        tt = linspace( 0, t_prop, 2000 );
    
        sv0_ini = sv0_us( indez,: );
    
        pars.mu   = strucNorm.normMu;
        opt       = odeset('RelTol', 1e-13, 'AbsTol', 1e-13 );
        [~, yy1] = ode113( @(t, x) f_CR3BP(x, pars), tt, sv0_ini, opt );
        
        if indez == 1
            plot3( yy1(:,1).*normDist, yy1(:,2).*normDist, yy1(:,3).*normDist, 'cyan', 'DisplayName', 'Unstable manifold' );
        else
            plot3( yy1(:,1).*normDist, yy1(:,2).*normDist, yy1(:,3).*normDist, 'cyan', 'HandleVisibility', 'Off' );
        end
    
    end
    
    view( [27 32] );

elseif strcmpi(manifold_plot, 'stable') || strcmpi(manifold_plot, 'st')

    % --> plot stable manifold
    for indez = 1:size(sv0_us, 1)
        
        tt = linspace( 0, t_prop, 2000 );
    
        sv0_ini = sv0_st( indez,: );
    
        pars.mu   = strucNorm.normMu;
        opt       = odeset('RelTol', 1e-13, 'AbsTol', 1e-13 );
        [~, yy1] = ode113( @(t, x) f_CR3BP(x, pars), tt, sv0_ini, opt );
        
        if indez == 1
            plot3( yy1(:,1).*normDist, yy1(:,2).*normDist, yy1(:,3).*normDist, 'green', 'DisplayName', 'Stable manifold' );
        else
            plot3( yy1(:,1).*normDist, yy1(:,2).*normDist, yy1(:,3).*normDist, 'green', 'HandleVisibility', 'Off' );
        end
    
    end

    view( [27 32] );

end

labelsDim = 12;
axesDim   = 12;
set(findall(fig,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(fig, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

legend( 'Location', 'Best' );

fprintf( 'Done! \n' );


end