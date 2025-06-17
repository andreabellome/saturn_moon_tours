
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%% --> Step 1) Plot the Tisserand-Poincare Graph

% --> set the constants
idcentral  = 6; % --> central body (Saturn in this case)
idMoon     = 1; % --> flyby body (Enceladus in this case)

% --> norm. var. CR3BP
strucNorm = wrapNormCR3BP(idcentral, idMoon);

% --> plot the Tisserand-Poincarè graph
vinfLevDIM = [ 0.2:0.05:1.6 ]; % --> infinity velocity contours [km/s]
ramaxAdim  = 4;               % --> max. adimensional apoapsis (default: 5)
npoints    = 1e3;             % --> number of points to plot contours

% % --> plot the Tisserand-Poincare graph
fig2 = plot_tp_graph(idcentral, idMoon, vinfLevDIM, ramaxAdim, npoints);

% --> plot here the Tisserand graph contours (uncomment to use it)
plotContours(1, vinfLevDIM, idcentral, 1, 1, [],  strucNorm.normDist);
% % --> adjust the axes accordingly
% ylim( [0 0.8] );
% xlim( [0 1.5] );
% --> adjust the axes accordingly
ylim( [0.5 1.07] );
xlim( [0.9 1.2] );

%% --> Step 2) Plot some points from Task 2 solutions at Enceladus

% --> load the Task 2 solution
load([pwd '/Solutions/PATHph_noOpCon.mat']);

INPUT.idcentral = 6;
INPUT.t0        = 0;

% [fig, dvc] = plotFullPathTraj_tiss(PATHph, INPUT, 1);

% --> Enceladus phase
tour       = PATHph(5).path;
idMoon     = tour(1,1);
TOUR_struc = process_tour(tour, INPUT.t0, INPUT);


% --> convert the tour into apoapsis-periapsis and apply the CR3BP scaling (Saturn-Enceladus)
alphaAfterDSM            = tour( :,9 );
vinfAfterDSM             = tour( :,10 );
[raAfterDSM, rpAfterDSM] = alphaVinf2raRp(alphaAfterDSM, vinfAfterDSM, idMoon, idcentral);
raAfterDSMAdim           = raAfterDSM./strucNorm.normDist;
rpAfterDSMAdim           = rpAfterDSM./strucNorm.normDist;

alphaBeforeDSM             = tour( 2:end,9 );
vinfBeforeDSM              = tour( 2:end,10 );
[raBeforeDSM, rpBeforeDSM] = alphaVinf2raRp(alphaBeforeDSM, vinfBeforeDSM, idMoon, idcentral);
raBeforeDSM                = raBeforeDSM./strucNorm.normDist;
rpBeforeDSM                = rpBeforeDSM./strucNorm.normDist;

% % --> plot the orbits on the Tisserand-Poincare graph
hold on;
plot( raAfterDSMAdim, rpAfterDSMAdim, 'o', 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Yellow', 'HandleVisibility', 'off' );
plot( raBeforeDSM, rpBeforeDSM, 'o', 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Yellow', 'HandleVisibility', 'off' );
plot( raBeforeDSM(1), rpBeforeDSM(1), 'o', 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Yellow', 'DisplayName', 'Enceladus tour' );

% % --> adjust the axes accordingly
% xlim( [0.95 1.35] );
% ylim( [0.9 1.02] );

% % --> save the file
% name = [pwd '/AUTOMATE/Images/tisseran_poincare_enceladus.png'];
% exportgraphics(fig2, name, 'Resolution', 1200);

%% --> plot a tour on a TP graph

close all; clc;

% --> load the Task 2 solution
load([pwd '/Solutions/PATHph_noOpCon.mat']);
load([pwd '/crossing_data.mat']);

% --> Enceladus phase
tour       = PATHph(end).path;
idMoon     = tour(1,1);
TOUR_struc = process_tour(tour, t0, INPUT);

kep_end = TOUR_struc(end).kep2;
ra_end  = kep_end(1)*(1 + kep_end(2))
rp_end  = kep_end(1)*(1 - kep_end(2))

INPUT.vinflevels = vinfLevDIM;
INPUT.idcentral  = idcentral;

% --> add all the contours
idcentral  = 6; % --> central body (Saturn in this case)

IDS = [ 1 2 ];

param.adim = 0;
vinfLevDIM = 0.2:0.05:0.8;     % --> infinity velocity levels [km/s]

% --> plot bits
fig3       = plot_tp_graph(idcentral, idMoon, vinfLevDIM, ramaxAdim, npoints, param); % --> plot TP graph
plotContours( idMoon, vinfLevDIM, idcentral, 1 );                                     % --> plot v-infinity graph
plotContours( 2, 0.8, idcentral, 1 );                                                 % --> plot v-infinity graph

processLabelPlots( idcentral, idMoon );                                               % --> adjust the lables and scaling
plotPath_tiss(tour, INPUT, 'b', [], [], [], [], 1);                                   % --> plot the tour

% --> plot the Poincarè-crossing orbits
if idcentral == 1
    AU = 149597870.7;
else
    [~, AU] = planetConstants(idcentral);
end
plot( RA_CROSSING_DIM./AU, RP_CROSSING_DIM./AU, 'o', 'MarkerSize', 5, 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'yellow' );

%%

close all; clc;

[mu_planet, plot_scale] = planetConstants(INPUT.idcentral);

fig = figure( 'Color', [1 1 1] );
hold on;

inddsm = 0;

greyCol  = [0.800000011920929 0.800000011920929 0.800000011920929];
greyCol2 = [0.82,0.82,0.82];

for indp = 1:length(TOUR_struc)

    dv = TOUR_struc(indp).dv;

    rr1 = TOUR_struc(indp).rr1;
    vv1 = TOUR_struc(indp).vvd;

    rr2 = TOUR_struc(indp).rr2;
    vv2 = TOUR_struc(indp).vva;

    tof1 = TOUR_struc(indp).tof1 * 86400;
    tof2 = TOUR_struc(indp).tof2 * 86400;
    
    [~, yy1] = propagateKepler_tof(rr1, vv1, tof1, mu_planet);    
    [~, yy2] = propagateKepler_tof(rr2, vv2, -tof2, mu_planet);   
    
    plot3( yy1(:,1)./plot_scale, yy1(:,2)./plot_scale, yy1(:,3)./plot_scale, 'Color', greyCol2, 'HandleVisibility', 'Off' );
    plot3( yy2(:,1)./plot_scale, yy2(:,2)./plot_scale, yy2(:,3)./plot_scale, 'Color', greyCol2, 'HandleVisibility', 'Off' );

end

plotMoons(1, INPUT.idcentral, 1, plot_scale);

for indp = 1:length(TOUR_struc)
    rr1 = TOUR_struc(indp).rr1;
    vv1 = TOUR_struc(indp).vvd;

    rr2 = TOUR_struc(indp).rr2;
    vv2 = TOUR_struc(indp).vva;
    
    dv = TOUR_struc(indp).dv;

    if indp == 1
        plot3( rr1(:,1)./plot_scale, rr1(:,2)./plot_scale, rr1(:,3)./plot_scale,...
            'o', 'MarkerEdgeColor', 'Black',...
            'MarkerFaceColor', greyCol,...
            'DisplayName', 'Fly-by');
    end

    plot3( rr1(:,1)./plot_scale, rr1(:,2)./plot_scale, rr1(:,3)./plot_scale,...
            'o', 'MarkerEdgeColor', 'Black',...
            'MarkerFaceColor', greyCol,...
            'HandleVisibility', 'off');

    plot3( rr2(:,1)./plot_scale, rr2(:,2)./plot_scale, rr2(:,3)./plot_scale,...
        'o', 'MarkerEdgeColor', 'Black',...
        'MarkerFaceColor', greyCol,...
        'HandleVisibility', 'off');

    rr1 = TOUR_struc(indp).rr1;
    vv1 = TOUR_struc(indp).vvd;

    rr2 = TOUR_struc(indp).rr2;
    vv2 = TOUR_struc(indp).vva;

    tof1 = TOUR_struc(indp).tof1 * 86400;
    tof2 = TOUR_struc(indp).tof2 * 86400;
    
    [~, yy1] = propagateKepler_tof(rr1, vv1, tof1, mu_planet);    
    [~, yy2] = propagateKepler_tof(rr2, vv2, -tof2, mu_planet);  

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
end

indp = 1;
rr1 = TOUR_struc(indp).rr1;
plot3( rr1(:,1)./plot_scale, rr1(:,2)./plot_scale, rr1(:,3)./plot_scale,...
        's', 'MarkerEdgeColor', 'Black', ...
        'MarkerFaceColor', 'red', ...
        'DisplayName', 'Departure');

indp = length(TOUR_struc);
rr2 = TOUR_struc(indp).rr2;
plot3( rr2(:,1)./plot_scale, rr2(:,2)./plot_scale, rr2(:,3)./plot_scale,...
            'd', 'MarkerEdgeColor', 'Black',...
            'MarkerFaceColor', 'green',...
            'DisplayName', 'Arrival');

xlabel('x [R_S]'); ylabel('y [R_S]');

lgd = legend( 'Location', 'northoutside' );
lgd.NumColumns = 4;
