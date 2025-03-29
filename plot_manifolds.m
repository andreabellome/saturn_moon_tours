function fig = plot_manifolds( full_state_orbit, man_prop, strucNorm, colors, holdon )

normDist = strucNorm.normDist;

if nargin == 3
    colors        = 'red';
    holdon        = 0;
elseif nargin == 4
    if isempty(colors)
        colors = 'red';
    end
    holdon = 0;
elseif nargin == 5
    if isempty(colors)
        colors = 'red';
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

plot3( full_state_orbit(:,1).*normDist, ...
        full_state_orbit(:,2).*normDist, ...
        full_state_orbit(:,3).*normDist, ...
        'color', 'k', 'LineWidth', 3, 'HandleVisibility', 'Off' );

% --> plot un-stable manifold
for indez = 1:length(man_prop)
                                
    yy1 = man_prop(indez).yy;
    if ~isempty(yy1)
        if indez == 1
            plot3( yy1(:,1).*normDist, yy1(:,2).*normDist, yy1(:,3).*normDist, 'Color', colors, 'DisplayName', 'Unstable manifold' );
        else
            plot3( yy1(:,1).*normDist, yy1(:,2).*normDist, yy1(:,3).*normDist, 'Color', colors, 'HandleVisibility', 'Off' );
            plot3( yy1(end,1).*normDist, yy1(end,2).*normDist, yy1(end,3).*normDist, 'o', 'MarkerFaceColor', 'blue', 'HandleVisibility', 'Off' );
        end
    end

end

view( [27 32] );

end


