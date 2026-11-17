function [fig, dvc] = plotFullPathTraj_tisserand_colored(PATHph, INPUT)

% DESCRIPTION
% This function plots the trajectory of un-phased solution on Tisserand
% graph. On the intersections, it plots the corresponding orbits and
% assumes the minimum time-of-flight. The trajectory is colour-coded with
% the elapsed time of flight from the tour start (colormap: cool).
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
path            = cell2mat( { PATHph.path }' );
path            = unique( path, 'rows', 'stable' );
indxs           = find( path(:,2) == 0 );
path(indxs, 6)  = 0;
path            = unique( path, 'rows', 'stable' );
indxs           = find( path(:,2) == 0 );
path(indxs, 6)  = NaN;

t0             = INPUT.t0;
tStart         = INPUT.t0;              % --> reference epoch for the colour scale [days]
idcentral      = INPUT.idcentral;
IDS            = unique(path(2:end,1));
mu_planet      = constants(idcentral, 1);

nPts           = 1000;                  % --> points per propagated arc
dvc            = zeros(size(path,1), 1);

if isfield(INPUT, 'plot_scale')
    if isempty(INPUT.plot_scale)
        plot_scale = 1;
    else
        plot_scale = INPUT.plot_scale;
    end
else
    plot_scale = 1;
end

fig = figure( 'Color', [1 1 1] );
hold on;

blackCol = [0, 0, 0];
whiteCol = [1, 1, 1];
greyCol  = [0.800000011920929 0.800000011920929 0.800000011920929];
greyCol2 = [0.50,0.50,0.50];

plotMoons(IDS, idcentral, 1, blackCol.*ones(length(IDS), 3), plot_scale);

if isfield(INPUT, 'plot_initial_orbit')
    if isempty(INPUT.plot_initial_orbit)
        plot_initial_orbit = 0;
    else
        plot_initial_orbit = INPUT.plot_initial_orbit;
    end
else
    plot_initial_orbit = 0;
end

if plot_initial_orbit == 1
    % --> start: plot initial orbit (black dashed, so it does not clash with the colormap)
    moon    = path(1,1);
    alphain = path(1,9);
    vinfin  = path(1,10);
    type    = path(1,2);
    crankin = type2Crank(type);
    
    [~, rrin, vvin] = vinfAlphaCrank_to_VinfCART(vinfin, alphain, crankin, t0, moon, idcentral);
    kepin           = car2kep( [rrin, vvin], mu_planet );
    tof             = 2*pi*sqrt(kepin(1)^3/mu_planet);
    [~, yy]         = propagateKepler_tof(rrin, vvin, -tof, mu_planet);                               % --> propagate
    
    plot3( yy(:,1)./plot_scale, yy(:,2)./plot_scale, yy(:,3)./plot_scale, '--', 'Color', 'Black', 'LineWidth', 1.5, 'DisplayName', 'Initial orbit' );
    % --> end: plot initial orbit
end

inddsm  = 0;
firstFB = true;
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

        % --> find cartesian elements
        [~, rr1, vv1] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank1, t0, pl1, idcentral);

        % --> full intersection orbit as faint context line
        [~, yy] = propagateKepler_tof(rr1, vv1, period, mu_planet);
        plot3( yy(:,1)./plot_scale, yy(:,2)./plot_scale, yy(:,3)./plot_scale, 'Color', greyCol, 'LineWidth', 0.5, 'HandleVisibility', 'Off'  );

        % --> flown portion of the intersection, colour-coded with TOF
        tt      = linspace( 0, TOFs(indtof), nPts );
        [~, yy] = propagateKepler(rr1, vv1, tt, mu_planet);
        plotColoredArc( yy./plot_scale, (t0 - tStart) + tt(:)/86400 );

        if firstFB
            plot3( yy(end,1)./plot_scale, yy(end,2)./plot_scale, yy(end,3)./plot_scale,...
                    'o', 'MarkerEdgeColor', 'Black', ...
                    'MarkerFaceColor', greyCol, ...
                    'DisplayName', 'Fly-by');
            firstFB = false;
        else
            plot3( yy(end,1)./plot_scale, yy(end,2)./plot_scale, yy(end,3)./plot_scale,...
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

        % --> plot sc traj. 1 (forward from departure fly-by)
        tt      = linspace( 0, tof1*86400, nPts );
        [~,yy1] = propagateKepler(rr1, vvd, tt, mu_planet);
        plotColoredArc( yy1./plot_scale, (t0 - tStart) + tt(:)/86400 );

        if tof2 < Inf
            % --> plot sc traj. 2 (backward from arrival fly-by)
            tt      = linspace( 0, -tof2*86400, nPts );
            [~,yy2] = propagateKepler(rr2, vva, tt, mu_planet);
            plotColoredArc( yy2./plot_scale, (t2 - tStart) + tt(:)/86400 );

            if dv > 1e-6
                if inddsm == 0
                    plot3( yy2(end,1)./plot_scale, yy2(end,2)./plot_scale, yy2(end,3)./plot_scale, 'X', 'LineWidth', 3,...
                    'MarkerSize', 10, ...
                    'MarkerEdgeColor', 'Black', ...
                    'MarkerFaceColor', 'Black', ...
                    'DisplayName', 'DSM' );
                    inddsm = inddsm + 1;
                else
                    plot3( yy2(end,1)./plot_scale, yy2(end,2)./plot_scale, yy2(end,3)./plot_scale, 'X', 'LineWidth', 3,...
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

        if firstFB
            plot3( rr1(:,1)./plot_scale, rr1(:,2)./plot_scale, rr1(:,3)./plot_scale,...
                    'o', 'MarkerEdgeColor', 'Black', ...
                    'MarkerFaceColor', greyCol, ...
                    'DisplayName', 'Fly-by');
            firstFB = false;
        else
            plot3( rr1(:,1)./plot_scale, rr1(:,2)./plot_scale, rr1(:,3)./plot_scale,...
                'o', 'MarkerEdgeColor', 'Black',...
                'MarkerFaceColor', greyCol,...
                'HandleVisibility', 'off');
        end
        plot3( rr2(:,1)./plot_scale, rr2(:,2)./plot_scale, rr2(:,3)./plot_scale,...
            'o', 'MarkerEdgeColor', 'Black',...
            'MarkerFaceColor', greyCol,...
            'HandleVisibility', 'off');

        t0 = t2;

    end

end

% --> colour scale on elapsed time of flight
tofTot = t0 - tStart;
cmap   = cool(256);
colormap( gca, cmap );
if tofTot > 0
    caxis( [0 tofTot] );
end

% --> assign a solid colour to each trajectory segment from its mean TOF
hArcs = findall( gca, 'Type', 'Line', 'Tag', 'tofArc' );   % --> findall: arcs have HandleVisibility off
for k = 1:numel(hArcs)
    tmid = hArcs(k).UserData;
    if tofTot > 0
        idx = 1 + round( (size(cmap,1)-1) * min(max(tmid/tofTot, 0), 1) );
    else
        idx = 1;
    end
    hArcs(k).Color = cmap(idx,:);
end

cb = colorbar;
cb.Label.String = 'Time of flight [days]';

legend( 'Location', 'Best' );

end

% -------------------------------------------------------------------------
function plotColoredArc(yy, tdays)

% DESCRIPTION
% Plots a 3D arc colour-coded with the elapsed time tdays (column vector,
% same number of rows as yy). The arc is split into nSeg plain line
% objects, each storing its mean elapsed time in UserData; the actual
% colour is assigned at the end of the main function, once the total TOF
% (and thus the colour scale) is known. Plain lines export cleanly to
% vector formats (PDF/SVG), unlike interpolated patches.

nSeg = 20;                                   % --> colour steps per arc

np   = size(yy,1);
if np < 2, return; end
nSeg = min(nSeg, np-1);
idx  = round( linspace(1, np, nSeg+1) );

for s = 1:nSeg
    ii = idx(s):idx(s+1);                    % --> shared end points: no gaps
    line( yy(ii,1), yy(ii,2), yy(ii,3), ...
        'LineWidth', 1.5, ...
        'Color', [0 0 0], ...
        'Tag', 'tofArc', ...
        'UserData', mean( tdays(ii) ), ...
        'HandleVisibility', 'off' );
end

end