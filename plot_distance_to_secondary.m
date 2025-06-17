function [fig] = plot_distance_to_secondary( strucOrbit, strucNorm, holdon, colors )

if nargin == 2
    holdon = 0;
    colors = [0 0.5 0.8].*ones( length(strucOrbit),3 );
elseif nargin == 3
    if isempty( holdon )
        holdon = 0;
    end
    colors = [0 0.5 0.8].*ones( length(strucOrbit),3 );
end

if holdon == 0
    fig = figure( 'Color', [1 1 1] );
else
    fig       = gcf;
    fig.Color = [ 1 1 1 ];
end
xlabel( 'time/Period' ); ylabel( 'Distance [km]' );
hold on; grid on;

for index = 1:length(strucOrbit)
    plot( strucOrbit(index).tt./strucOrbit(index).norm_plot, strucOrbit(index).dist_to_secondary.*strucNorm.normDist, ...
        'Color', colors(index,:), ...
        'LineWidth', 2, ...
        'HandleVisibility', 'Off' );
end

if nargin == 4

    Az_values = [strucOrbit.Az]; 
    Az_min = min(Az_values);
    Az_max = max(Az_values);

    
    if length(strucOrbit) > 1
        c = colorbar;
        if Az_max <0
            colormap( flip(colors) );
        else
            colormap( (colors) );
        end
        caxis([Az_min/1e3 Az_max/1e3]);
        ylabel(c, 'A_z');
        
        c.Title.String = '[x10^3 km]';
        c.Ticks        = sort(Az_values)./ 1e3;
        c.TickLabels = arrayfun(@(x) sprintf('%.0f', x), sort(floor(Az_values / 1e3)), 'UniformOutput', false);
    end

end

labelsDim = 12;
axesDim   = 12;
set(findall(fig,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(fig, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

end
