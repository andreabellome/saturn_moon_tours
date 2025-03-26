function [fig, dvc] = plotFullPathTraj_tiss(PATHph, INPUT, idMoon)

if nargin == 2
    idMoon = NaN;
end

path = cell2mat( { PATHph.path }' );
path = unique( path, 'rows', 'stable' );

path(isnan(path(:,6)),:) = [];
path(1,:)                = [];

if ~isnan(idMoon) % --> a specific moon phase should be plotted
    path = path( path(:,1) == idMoon,: );
end

t0             = INPUT.t0;
idcentral      = INPUT.idcentral;
IDS            = unique(path(:,1));
mu_planet      = constants(idcentral, 1);

greyCol  = [0.800000011920929 0.800000011920929 0.800000011920929];
greyCol2 = [0.50,0.50,0.50];

fig = figure( 'Color', [1 1 1] );
hold on; grid off; axis off;

plotMoons(IDS, idcentral, 1);

inddsm = 0;
for indr = 1:size(path,1)
    
    pathrow               = path(indr,:);
    
    idmoon = pathrow(1);
    kei    = pathrow(3);
    N      = pathrow(4);
    M      = pathrow(5);
    L      = pathrow(6);
    vinf1  = pathrow(8);
    vinf2  = pathrow(10);

    % --> solve the VILT
    [vinf1, alpha1, crank1, vinf2, alpha2, crank2, dv, tof1, tof2] = ...
        wrap_vInfinityLeveraging(pathrow(2), N, M, L, kei, vinf1, vinf2, idmoon, idcentral, 0);
    
    tof1 = tof1/86400;
    tof2 = tof2/86400;
    tof  = tof1 + tof2;
    t2   = t0+tof;

    [~, rr1, vvd] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank1, t0, idmoon, idcentral); % --> find cartesian elements
    [~, rr2, vva] = vinfAlphaCrank_to_VinfCART(vinf2, alpha2, crank2, t2, idmoon, idcentral); % --> find cartesian elements

    hold on; grid off; axis off;

    % --> plot sc traj. 1
    [~, yy1]      = propagateKepler_tof(rr1, vvd, tof1*86400, mu_planet);                              % --> propagate
    plot3( yy1(:,1), yy1(:,2), yy1(:,3), 'Color', greyCol2, 'HandleVisibility', 'off');

    if tof2 < Inf
        % --> plot sc traj. 2
        [~, yy2]      = propagateKepler_tof(rr2, vva, -tof2*86400, mu_planet);                                    % --> propagate
        plot3( yy2(:,1), yy2(:,2), yy2(:,3), 'Color', greyCol2, 'HandleVisibility', 'off');
        
        if dv > 1e-6
            if inddsm == 0
                plot3( yy2(end,1), yy2(end,2), yy2(end,3), 'X', 'LineWidth', 3,...
                'MarkerSize', 10, ...
                'MarkerEdgeColor', 'Black', ...
                'MarkerFaceColor', 'Black', ...
                'DisplayName', 'VILT' );
                inddsm = inddsm + 1;
            else
                plot3( yy2(end,1), yy2(end,2), yy2(end,3), 'X', 'LineWidth', 3,...
                'MarkerSize', 10, ...
                'MarkerEdgeColor', 'Black', ...
                'MarkerFaceColor', 'Black', ...
                'HandleVisibility', 'off' );
            end
        end

        % --> check the DV is correct
        dvc(indr,1) = abs( norm(yy2(end,4:6) - yy1(end,4:6)) - dv );
    else
        % --> check the DV is correct
        dvc(indr,1) = 0;
    end

    if indr == 1
        plot3( rr1(:,1), rr1(:,2), rr1(:,3),...
                'o', 'MarkerEdgeColor', 'Black', ...
                'MarkerFaceColor', greyCol, ...
                'DisplayName', 'Fly-by');
    else
        plot3( rr1(:,1), rr1(:,2), rr1(:,3),...
            'o', 'MarkerEdgeColor', 'Black',...
            'MarkerFaceColor', greyCol,...
            'HandleVisibility', 'off');
    end
    plot3( rr2(:,1), rr2(:,2), rr2(:,3),...
        'o', 'MarkerEdgeColor', 'Black',...
        'MarkerFaceColor', greyCol,...
        'HandleVisibility', 'off');

    t0 = t2;
    
end

legend('Location', 'Best');

labelsDim = 12;
axesDim   = 12;
set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(gcf, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

end
