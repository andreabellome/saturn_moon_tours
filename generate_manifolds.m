function [ manifolds, fig ] = generate_manifolds( sv0, orbital_period, strucNorm, n_points, num_periods, epsilon, manifold_plot )

if nargin == 3
    n_points = 500;
    num_periods = 1;
    epsilon = 0.00001;
    manifold_plot = 'unstable';
elseif nargin == 4
    num_periods = 1;
    epsilon  = 0.00001;
    manifold_plot = 'unstable';
elseif nargin == 5
    epsilon  = 0.00001;
    manifold_plot = 'unstable';
elseif nargin == 6
    manifold_plot = 'unstable';
end

% sv0 and orbital periods are given in ADIMENSIONAL UNITS

% --> compute the states and the STM along the trajectory 
[ ~, STM_tf, full_state, full_stm ] = propagateCR3BP_STM( sv0, orbital_period, strucNorm, n_points );

% --> find eigenvectors and eigenvalues
[eigenvectors, eigenvalues] = eig(STM_tf);
eigenvalues                 = diag(eigenvalues);

indxs_real = find( imag(eigenvalues) == 0 );
indxs_imag = find( imag(eigenvalues) ~= 0 );

real_eigenval = eigenvalues(indxs_real); % --> real eigenvalues
imag_eigenval = eigenvalues(indxs_imag); % --> complex conjugate eigenvalues

real_eigenvector = eigenvectors(:,indxs_real);
imag_eigenvector = eigenvectors(:,indxs_imag);

[~, index_max] = max(real_eigenval); % --> max. eigenvalue --> gives the unstable direction
[~, index_min] = min(real_eigenval); % --> min. eigenvalue --> gives the stable direction

eigvector_us = real_eigenvector(:,index_max)';
eigvector_st = real_eigenvector(:,index_min)';

delta_sv_us_s = zeros( size(full_state,1), 6 );
delta_sv_st_s = zeros( size(full_state,1), 6 );

for index = 1:size(full_state,1)
    
    % --> get the STM for the given state
    stm  = reshape(full_stm(index,:),6,6)';
    
    % --> un-stable manifold
    delta_sv_us_s(index,:) = [ stm*eigvector_us' ]';
    delta_sv_us_s(index,:) = delta_sv_us_s(index,:)./norm( delta_sv_us_s(index,:) );
    
    % --> stable manifold
    delta_sv_st_s(index,:) = [ stm*eigvector_st' ]';
    delta_sv_st_s(index,:) = delta_sv_st_s(index,:)./norm( delta_sv_st_s(index,:) );

end

% --> apply perturbation to initial state
sv0_us = full_state + epsilon.*delta_sv_us_s;
sv0_st = full_state + epsilon.*delta_sv_st_s;

% --> save the manifold structure
manifolds.full_state        = full_state;
manifolds.full_stm          = full_stm;

manifolds.sv0_us            = sv0_us;
manifolds.sv0_st            = sv0_st;

manifolds.delta_sv_us_s     = delta_sv_us_s;
manifolds.delta_sv_st_s     = delta_sv_st_s;

manifolds.real_eigenvector  = real_eigenvector;
manifolds.imag_eigenvector  = imag_eigenvector;

manifolds.real_eigenval     = real_eigenval;
manifolds.imag_eigenval     = imag_eigenval;

if nargout == 2

    normDist = strucNorm.normDist;

    fprintf( 'Plot requested. Propagating the manifold... \n' );
    
    % --> time-propagation
    t_prop = num_periods*orbital_period;
    
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

end
