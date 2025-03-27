function fig = plot_manifolds( manifolds, strucNorm, manifold_plot, holdon )

normDist = strucNorm.normDist;

if nargin == 2
    manifold_plot = 'unstable';
    holdon        = 0;
elseif nargin == 3
    if isempty(manifold_plot)
        manifold_plot = 'unstable';
    end
    holdon = 0;
elseif nargin == 4
    if isempty(manifold_plot)
        manifold_plot = 'unstable';
    end
    if isempty(holdon)
        holdon = 0;
    end
end

if holdon == 0
    fig = figure( 'Color', [1 1 1] );
    hold on; grid on;
else
    fig       = gcf;
    fig.Color = [ 1 1 1 ];
    hold on; grid on;
end
xlabel( 'x [km]' ); ylabel( 'y [km]' ); zlabel( 'z [km]' );

full_state = manifolds.full_state_orbit; % --> state along the nominal orbit

plot3( full_state(:,1).*normDist, ...
        full_state(:,2).*normDist, ...
        full_state(:,3).*normDist, ...
        'color', 'k', 'LineWidth', 3, 'HandleVisibility', 'Off' );

% --> these are the manifolds
if strcmpi(manifold_plot, 'unstable') || strcmpi(manifold_plot, 'un')

    % --> plot un-stable manifold
    unst_man_prop = manifolds.unst_man_prop;
    sv0_us        = manifolds.sv0_us;
    for indez = 1:size(sv0_us, 1)
                                    
        yy1 = unst_man_prop(indez).yy;
        if ~isempty(yy1)
            if indez == 1
                plot3( yy1(:,1).*normDist, yy1(:,2).*normDist, yy1(:,3).*normDist, 'red', 'DisplayName', 'Unstable manifold' );
            else
                plot3( yy1(:,1).*normDist, yy1(:,2).*normDist, yy1(:,3).*normDist, 'red', 'HandleVisibility', 'Off' );
            end
        end
    
    end
    
    view( [27 32] );

elseif strcmpi(manifold_plot, 'stable') || strcmpi(manifold_plot, 'st')

    % --> plot stable manifold --> THIS IS PROPAGATED BACKWARDS !!!
    st_man_prop = manifolds.st_man_prop;
    sv0_st      = manifolds.sv0_st;
    for indez = 1:size(sv0_st, 1)
                                    
        yy1 = st_man_prop(indez).yy;
        if ~isempty(yy1)
            if indez == 1
                plot3( yy1(:,1).*normDist, yy1(:,2).*normDist, yy1(:,3).*normDist, 'green', 'DisplayName', 'Stable manifold' );
            else
                plot3( yy1(:,1).*normDist, yy1(:,2).*normDist, yy1(:,3).*normDist, 'green', 'HandleVisibility', 'Off' );
            end
        end
    
    end

    view( [27 32] );
end

end


