function [ halo_orbits, fig ] = wrap_halo_family( Az_vect, lpoint, strucNorm, holdon, colors )

% Az_vect should be given in km!!!!

if nargin == 3
    holdon = 0;
    colors = cool(2);
elseif nargin == 4
    if isempty(holdon)
        holdon = 0;
    end
    colors = cool(2);
end

normDist  = strucNorm.normDist;
LagrPoint = lagrange_point_and_gamma( strucNorm, lpoint );

halo_orbits = struct( 'Ax', cell(1, length(Az_vect)), 'Ay', cell(1, length(Az_vect)), 'Az', cell( 1, length(Az_vect) ), ...
                      'sv0', cell(1,length(Az_vect)), ...
                    'orb_period', cell(1,length(Az_vect)), 'Jc', cell(1,length(Az_vect)), ...
                    'tt', cell(1,length(Az_vect)), ...
                    'yy', cell(1,length(Az_vect)) );
for indz = 1:length( Az_vect )

    fprintf( 'Computing Halo at %.2f/100 ... \n', indz/length(Az_vect)*100 );
    
    Az = Az_vect( indz );

    % --> generate Halo orbit
    [ sv0, orb_period, Jc, tt, yy ] = wrap_halo_orbit_generator( Az, lpoint, strucNorm );
       
    % --> shift to Lagrange point
    yy_lagr      = yy;
    yy_lagr(:,1) = yy_lagr(:,1) - LagrPoint(1);

    Ax = (max(yy_lagr(:,1)) - min(yy_lagr(:,1))) / 2 * strucNorm.normDist;
    Ay = (max(yy_lagr(:,2)) - min(yy_lagr(:,2))) / 2 * strucNorm.normDist;

    halo_orbits(indz).Ax  = Ax;
    halo_orbits(indz).Ay  = Ay;
    halo_orbits(indz).Az  = Az;
    halo_orbits(indz).sv0 = sv0;
    
    halo_orbits(indz).orb_period = orb_period;
    halo_orbits(indz).norm_plot  = orb_period;

    halo_orbits(indz).Jc = Jc;
    halo_orbits(indz).tt = tt;
    halo_orbits(indz).yy = yy;

end

if nargout == 2
    
    if holdon == 0
        fig = figure( 'Color', [1 1 1] );
    else
        fig       = gcf;
        fig.Color = [ 1 1 1 ];
    end
    hold on; grid on;
    xlabel( 'x [km]' ); ylabel( 'y [km]' ); zlabel( 'z [km]' );
    
    count_south = 0;
    count_north = 0;
    for indhalo = 1:length(halo_orbits)
        Az = halo_orbits( indhalo ).Az;
        yy = halo_orbits( indhalo ).yy;

        if Az < 0
            color = colors(1,:);
            name = [lpoint ' - south family'];
            count_south = count_south + 1;
        else
            color = colors(2,:);
            name = [lpoint ' - north family'];
            count_north = count_north + 1;
        end
        
        if count_south == 1
            plot3( yy(:,1).*normDist, yy(:,2).*normDist, yy(:,3).*normDist, 'color', color, 'LineWidth', 2, 'DisplayName', name );
        elseif count_north == 1
            plot3( yy(:,1).*normDist, yy(:,2).*normDist, yy(:,3).*normDist, 'color', color, 'LineWidth', 2, 'DisplayName', name );
        else
            plot3( yy(:,1).*normDist, yy(:,2).*normDist, yy(:,3).*normDist, 'color', color, 'LineWidth', 2, 'HandleVisibility', 'off' );
        end
    end

    view( [-2 18] );

    labelsDim = 12;
    axesDim   = 12;
    set(findall(fig,'-property','FontSize'), 'FontSize',labelsDim)
    h = findall(fig, 'type', 'text');
    set(h, 'fontsize', axesDim);
    ax          = gca; 
    ax.FontSize = axesDim; 

    legend( 'Location', 'Best' );

end

end
