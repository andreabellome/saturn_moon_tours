function [fig] = plotFullPathTraj_tisserand(PATHph, INPUT)

% DESCRIPTION
% This function plots the trajectory of un-phased solution on Tisserand
% graph. On the intersections, it plots the corresponding orbits and
% assumes the minimum time-of-flight.
%
% INPUT
% - PATHph : structure where each row is a tour for a different moon phase.
%            It has the following fields:
%            - path : matrix with tour on specific phase. 
%            - dvPhase : DV total for the given phase [km/s]
%            - tofPhase : time of flight for the given phase [days]
%            - dvOI     : DV for orbit insertion only valid for the last
%            phase (see also orbitInsertion.m)
% INPUT : structure with the following mandatory fields:
%         - t0 : initial tour epoch
%         - idcentral : ID of the central body (see constants.m)
% 
% -------------------------------------------------------------------------

% --> post process the path
path = cell2mat( { PATHph.path }' );
path = unique( path, 'rows', 'stable' );
indxs = find( path(:,2) == 0 );
path(indxs, 6) = 0;
path = unique( path, 'rows', 'stable' );
indxs = find( path(:,2) == 0 );
path(indxs, 6) = NaN;

t0             = INPUT.t0;
idcentral      = INPUT.idcentral;
IDS            = unique(path(2:end,1));
mu_planet      = constants(idcentral, 1);

fig = figure( 'Color', [1 1 1] );
hold on;

plotMoons(IDS, idcentral, 1);

% --> start: plot initial orbit
moon    = path(1,1);
alphain = path(1,9);
vinfin  = path(1,10);
type    = path(1,2);
crankin = type2Crank(type);

[~, rrin, vvin] = vinfAlphaCrank_to_VinfCART(vinfin, alphain, crankin, t0, moon, idcentral);
kepin   = car2kep( [rrin, vvin], mu_planet );
tof     = 2*pi*sqrt(kepin(1)^3/mu_planet);
[~, yy] = propagateKepler_tof(rrin, vvin, -tof, mu_planet);                               % --> propagate

plot3( yy(:,1), yy(:,2), yy(:,3), 'Color', 'Magenta', 'LineWidth', 1.5, 'DisplayName', 'Initial orbit'  );
% --> end: plot initial orbit

greyCol  = [0.800000011920929 0.800000011920929 0.800000011920929];
greyCol2 = [0.50,0.50,0.50];

inddsm = 0;
for indr = 2:size(path,1)

    pathrow        = path(indr,:);

    if isnan(pathrow(6)) % --> intersection orbit

        typeprev = path(indr-1,2);

        if indr+1 <= size(path,1)
            typenext = path(indr+1,2);
            
            if typeprev == 81 || typeprev == 11
                if typenext == 88 || typenext == 81
                    type   = 18;
                    indtof = 3;
                else
                    type   = 11;
                    indtof = 4;
                end
            else
    
                if typenext == 88 || typenext == 81
                    type   = 88;
                    indtof = 1;
                else
                    type   = 81;
                    indtof = 2;
                end
    
            end

        else

            if typeprev == 81 || typeprev == 88
                type   = 88;
                indtof = 1;
            else
                type   = 11;
                indtof = 4;
    
            end

        end
        crank1 = type2Crank(type);
      
        pl1    = pathrow( 3 );
        pl2    = pathrow( 1 );
        alpha1 = pathrow( 7 );
        vinf1  = pathrow( 8 );
        
        [ra, rp] = alphaVinf2raRp(alpha1, vinf1, pl1, idcentral);
        ecc      = (ra-rp)/(ra+rp);
        sma      = 0.5*( ra+rp );
        kep      = [ sma ecc, 0, 0, 0, 0 ];
        period   = 2*pi*sqrt( sma^3/mu_planet );

        % --> time of flight on the intersection
        TOFs = timeOfFlight_INTER(kep, pl1, pl2, idcentral);

        % --> propagate and plot the trajectory on the intersection
        [~, rr1, vv1] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank1, t0, pl1, idcentral); % --> find cartesian elements
        [~, yy]       = propagateKepler_tof(rr1, vv1, period, mu_planet);                               % --> propagate
        plot3( yy(:,1), yy(:,2), yy(:,3), 'Color', 'blu', 'HandleVisibility', 'Off'  );

        [~, yy]       = propagateKepler_tof(rr1, vv1, TOFs(indtof), mu_planet);                               % --> propagate

        if indr == 1
            plot3( yy(end,1), yy(end,2), yy(end,3),...
                    'o', 'MarkerEdgeColor', 'Black', ...
                    'MarkerFaceColor', greyCol, ...
                    'DisplayName', 'Fly-by');
        else
            plot3( yy(end,1), yy(end,2), yy(end,3),...
                'o', 'MarkerEdgeColor', 'Black',...
                'MarkerFaceColor', greyCol,...
                'HandleVisibility', 'off');
        end

        % --> update the epochs
        t2 = t0 + TOFs(indtof)/86400.0;
        t0 = t2;

    else

        [pathrow, tof1, tof2] = computeTof1Tof2AndRefine(pathrow, idcentral);
        [~, ~, t0, t2, tof, dv, rr1, vvd,...
            rr2, vva, ~, ~, ~, ~] = patRowVILTtoState(pathrow, t0, idcentral);
        if tof2 >= 1e99
            tof2 = 0;
        end

        % --> plot sc traj. 1
        tt      = linspace( 0, tof1*86400, 1000 );
        [~,yy1] = propagateKepler(rr1, vvd, tt, mu_planet);
        plot3( yy1(:,1), yy1(:,2), yy1(:,3), 'Color', 'blu', 'HandleVisibility', 'off');
        
        if tof2 < Inf
            % --> plot sc traj. 2
            tt      = linspace( 0, -tof2*86400, 1000 );
            [~,yy2] = propagateKepler(rr2, vva, tt, mu_planet);
            plot3( yy2(:,1), yy2(:,2), yy2(:,3), 'Color', 'blu', 'HandleVisibility', 'off');
            
            if dv > 1e-6
                if inddsm == 0
                    plot3( yy2(end,1), yy2(end,2), yy2(end,3), 'X', 'LineWidth', 3,...
                    'MarkerSize', 10, ...
                    'MarkerEdgeColor', 'Black', ...
                    'MarkerFaceColor', 'Black', ...
                    'DisplayName', 'DSM' );
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

end

legend( 'Location', 'Best' );

end
