%% --> CLEAR ALL AND ADD AUTOMATE TO THE PATH

clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

warning off

%% --> Pareto fronts

close all; clc;

load('C:\Users\andre\Documents\GitHub\saturn_moon_tours\Solutions\outputParetoFront_noOpCon.mat')
outputParetoFront_noOpCon = outputParetoFront;

load('C:\Users\andre\Documents\GitHub\saturn_moon_tours\Solutions\outputParetoFront_yesOpCon.mat')
outputParetoFront_yesOpCon = outputParetoFront;

clear outputParetoFront;

colors = cool(4);

campag   = [ 0.445 997 ];
strange  = [ 0.734 745 ];

dvtot_noOpCon  = [ outputParetoFront_noOpCon.dvtot ]' + [ outputParetoFront_noOpCon.dvOI ]';
toftot_noOpCon = [ outputParetoFront_noOpCon.toftot ]';

dvtot_yesOpCon  = [ outputParetoFront_yesOpCon.dvtot ]' + [ outputParetoFront_yesOpCon.dvOI ]';
toftot_yesOpCon = [ outputParetoFront_yesOpCon.toftot ]';

% --> START: plot Pareto fronts
fig_pareto = figure('Color', [1 1 1]);
hold on; grid on;
ylabel('TOF [days]'); xlabel('\Deltav [m/s]');
plot( dvtot_noOpCon.*1000, toftot_noOpCon, 'o', 'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', colors(1,:), ...
    'MarkerSize', 10, ...
    'DisplayName', 'MODP - without \newline operational constraints' );

plot( dvtot_yesOpCon.*1000, toftot_yesOpCon, 'o', 'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', colors(2,:), ...
    'MarkerSize', 10, ...
    'DisplayName', 'MODP - with \newline operational constraints'  );

plot( campag(1)*1000, campag(2), 's', 'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', colors(3,:), 'MarkerSize', 10, ...
    'DisplayName', 'Campagnola et al. 2010' );

plot( strange(1)*1000, strange(2), 'd', 'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', colors(4,:), 'MarkerSize', 10, ...
    'DisplayName', 'Strange et al. 2009' );

plotFontSizeAxesDim(12, 12, fig_pareto);

lgd             = legend( 'Location', 'best' );
lgd.NumColumns  = 1;

name_fig_0 = ['/paper_figures/pareto_fronts'];
exportgraphics(fig_pareto, [pwd name_fig_0 '.png' ], 'Resolution', 1200);
savefig([pwd name_fig_0 '.fig' ]);
% --> END: plot Pareto fronts

%% --> Tisserand contours

% --> set-up the system (Saturn in this case)
idcentral  = 6;             % --> Saturn is the central body (see constants.m)
IDS        = [ 1 2 3 4 5 ]; % --> Saturn moon IDs (see constants.m)
vinflevels = 0.1:0.1:3;     % --> infinity velocity levels [km/s]

% --> START: plot the Tisserand contours and add legend
nametosave = 'tisserand_saturn';
fig_contours = plotContours(IDS, vinflevels, idcentral, 0, 1, 1);

plotFontSizeAxesDim(12, 12, fig_pareto);

lgd             = legend( 'Location', 'northoutside' );
lgd.NumColumns  = 5;

name_fig_0 = ['/paper_figures/' nametosave];
exportgraphics(fig_contours, [pwd name_fig_0 '.png' ], 'Resolution', 1200);
savefig([pwd name_fig_0 '.fig' ]);
% --> END: plot the Tisserand contours and add legend

%% --> number of solutions per leg

close all; clc;

clear number_of_sols_noOpCon number_of_sols_yesOpCon

number_of_sols_yesOpCon(1).moon = 'Titan';
number_of_sols_yesOpCon(2).moon = 'Rhea';
number_of_sols_yesOpCon(3).moon = 'Dione';
number_of_sols_yesOpCon(4).moon = 'Thetys';
number_of_sols_yesOpCon(5).moon = 'Enceladus';

number_of_sols_yesOpCon(1).before_modp = [34 217 596];
number_of_sols_yesOpCon(1).after_modp  = [33 151 164];

number_of_sols_yesOpCon(2).before_modp = [1156 2189 15029 52038 79320 133017 195517 441077 1099199 1708858 2455530 3280201 4168836 5073637 5940041 6949267 7966061];
number_of_sols_yesOpCon(2).after_modp  = [217 872 2585 4382 7582 10464 19163 35658 55627 76971 102377 130975 159388 186171 214849 245686 271724];

number_of_sols_yesOpCon(3).before_modp = [23909 49399 184486 695168 1192806 1552488 1981194 2275166 2376656 2527920 2659691 2687569 2677669];
number_of_sols_yesOpCon(3).after_modp  = [3914 10004 23290 37995 48305 61578 72667 77917 82725 87960 89898 90860 90609];

number_of_sols_yesOpCon(4).before_modp = [36174 21926 50791 175639 575036 1122609 1408011 1705435 1730345 1701486 1658406 1588415 1523315];
number_of_sols_yesOpCon(4).after_modp  = [3217 5537 11200 23723 39464 47525 58768 61640 62185 62104 61188 58906 56462];

number_of_sols_yesOpCon(5).before_modp = [55823 45319 161719 422034 915471 2087547 3289225 3549106 3663130 3794379 3761441 3640151 3548029 3389968 3215113];
number_of_sols_yesOpCon(5).after_modp  = [3706 9818  20259 36065 59721 87749 92610 92826 94394 92976 90090 87399 84340 80071 74773];

number_of_sols_yesOpCon(1).solObtainedOnLeg = 2;
number_of_sols_yesOpCon(2).solObtainedOnLeg = 11;
number_of_sols_yesOpCon(3).solObtainedOnLeg = 7;
number_of_sols_yesOpCon(4).solObtainedOnLeg = 10;
number_of_sols_yesOpCon(5).solObtainedOnLeg = 6;

number_of_sols_yesOpCon(1).ratio = ( number_of_sols_yesOpCon(1).before_modp -  number_of_sols_yesOpCon(1).after_modp )./number_of_sols_yesOpCon(1).before_modp.*100;
number_of_sols_yesOpCon(2).ratio = ( number_of_sols_yesOpCon(2).before_modp -  number_of_sols_yesOpCon(2).after_modp )./number_of_sols_yesOpCon(2).before_modp.*100;
number_of_sols_yesOpCon(3).ratio = ( number_of_sols_yesOpCon(3).before_modp -  number_of_sols_yesOpCon(3).after_modp )./number_of_sols_yesOpCon(3).before_modp.*100;
number_of_sols_yesOpCon(4).ratio = ( number_of_sols_yesOpCon(4).before_modp -  number_of_sols_yesOpCon(4).after_modp )./number_of_sols_yesOpCon(4).before_modp.*100;
number_of_sols_yesOpCon(5).ratio = ( number_of_sols_yesOpCon(5).before_modp -  number_of_sols_yesOpCon(5).after_modp )./number_of_sols_yesOpCon(5).before_modp.*100;


number_of_sols_noOpCon(1).moon = 'Titan';
number_of_sols_noOpCon(2).moon = 'Rhea';
number_of_sols_noOpCon(3).moon = 'Dione';
number_of_sols_noOpCon(4).moon = 'Thetys';
number_of_sols_noOpCon(5).moon = 'Enceladus';

number_of_sols_noOpCon(1).before_modp = [44 365 876];
number_of_sols_noOpCon(1).after_modp  = [43 183 190];

number_of_sols_noOpCon(2).before_modp = [302 440 3432 9899 18185 29139 42469 74439 290353 895091 1457661 2019332 2646117 3124590 3508550 3933577 4444728];
number_of_sols_noOpCon(2).after_modp  = [53 287 935 1751 2812 3871 5631  10546 25170 40824 57232 76217 92097 104377 117647 131793 146613];

number_of_sols_noOpCon(3).before_modp = [6704 6543 21099 210132 679635 1130772 1382377 1504101 1633869 1676015 1734818 1736612 1741281];
number_of_sols_noOpCon(3).after_modp  = [995 1951 6662 19989 31696 41163 46557 52138 54155 56374 56926 57958 59691];

number_of_sols_noOpCon(4).before_modp = [7082 2506 4507 16620 145774 677327 1097331 1525912 1644112 1652541 1630330 1587600 1513830];
number_of_sols_noOpCon(4).after_modp  = [730 991 1792 5223 19711 30417 44299 50928 53147 54030 54072 52821 51422];

number_of_sols_noOpCon(5).before_modp = [13088 10849 30136 73739 154257 318459 608476 725332 777420 790013 790535 781097 757495 757495 728262];
number_of_sols_noOpCon(5).after_modp  = [1657 3543 6980 12068 18507 29889 36965 39838 40219 40246 39446 38561 37862 36805 35137];

number_of_sols_noOpCon(1).solObtainedOnLeg = 2;
number_of_sols_noOpCon(2).solObtainedOnLeg = 11;
number_of_sols_noOpCon(3).solObtainedOnLeg = 7;
number_of_sols_noOpCon(4).solObtainedOnLeg = 10;
number_of_sols_noOpCon(5).solObtainedOnLeg = 6;

number_of_sols_noOpCon(1).ratio = ( number_of_sols_noOpCon(1).before_modp -  number_of_sols_noOpCon(1).after_modp )./number_of_sols_noOpCon(1).before_modp.*100;
number_of_sols_noOpCon(2).ratio = ( number_of_sols_noOpCon(2).before_modp -  number_of_sols_noOpCon(2).after_modp )./number_of_sols_noOpCon(2).before_modp.*100;
number_of_sols_noOpCon(3).ratio = ( number_of_sols_noOpCon(3).before_modp -  number_of_sols_noOpCon(3).after_modp )./number_of_sols_noOpCon(3).before_modp.*100;
number_of_sols_noOpCon(4).ratio = ( number_of_sols_noOpCon(4).before_modp -  number_of_sols_noOpCon(4).after_modp )./number_of_sols_noOpCon(4).before_modp.*100;
number_of_sols_noOpCon(5).ratio = ( number_of_sols_noOpCon(5).before_modp -  number_of_sols_noOpCon(5).after_modp )./number_of_sols_noOpCon(5).before_modp.*100;

% colors = cool(length(number_of_sols_noOpCon));
% fig_num_sols = figure( 'Color', [1 1 1] );
% hold on; grid on; 
% xlabel( 'Leg number' ); ylabel( 'Number of solutions [log scale]' );
% for indn = 1:length(number_of_sols_noOpCon)
%     
%     before_modp = number_of_sols_noOpCon(indn).before_modp;
%     after_modp  = number_of_sols_noOpCon(indn).after_modp;
%     xx          = [ 1:1:length(before_modp) ]; 
% 
%     plot( xx, log(before_modp), 'o--', 'LineWidth', 2, 'Color', colors(indn,:) );
%     plot( xx, log(after_modp), 'o--', 'LineWidth', 2, 'Color', colors(indn,:) );
% 
% end

fig_num_sols_noOpCon = figure( 'Color', [1 1 1] );

for indn = 1:length(number_of_sols_noOpCon)
    
    if indn == 1
        subplot(3,2,[indn, indn+1]);
    else
        subplot(3,2, indn+1);
    end

%     if indn == length(number_of_sols_noOpCon)
%         subplot(3,2,[indn, indn+1]);
%     else
%         subplot(3,2,indn);
%     end

    hold on;
    xlabel_name = [ 'Tree depth - ' number_of_sols_noOpCon(indn).moon ];
    xlabel( xlabel_name); ylabel( 'log(N_s)' );

    before_modp = number_of_sols_noOpCon(indn).before_modp;
    after_modp  = number_of_sols_noOpCon(indn).after_modp;
    xx          = [ 1:1:length(before_modp) ]; 

    if indn == 1

        plot( xx, log(before_modp), 'o--', 'Color', 'k', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'black', 'LineWidth', 1, 'DisplayName', 'Before MODP' );
        plot( xx, log(after_modp), 'd--', 'Color', 'k', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'black', 'LineWidth', 1, 'DisplayName', 'After MODP' );
        xticks(xx);
    else

        plot( xx, log(before_modp), 'o--', 'Color', 'k', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'black', 'LineWidth', 1, 'HandleVisibility', 'Off' );
        plot( xx, log(after_modp), 'd--', 'Color', 'k', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'black', 'LineWidth', 1, 'HandleVisibility', 'Off' );
%         xticks(xx);
        xticks( [1 5 10 15] );
    end
    
    vline( number_of_sols_noOpCon(indn).solObtainedOnLeg, 'k-' );
    
end

indn = 1;
subplot(3,2,[indn, indn+1]);
lgd = legend( 'Location', 'northoutside' );
lgd.NumColumns = 2;

plotFontSizeAxesDim(12.5, 12.5, fig_num_sols_noOpCon);

set(fig_num_sols_noOpCon, 'Position', [1000, 733, 812, 605]);

% nametosave = 'noOpCon_numberSols';
% name_fig_0 = ['/paper_figures/' nametosave];
% exportgraphics(fig_num_sols_noOpCon, [pwd name_fig_0 '.png' ], 'Resolution', 1200);
% savefig([pwd name_fig_0 '.fig' ]);


fig_num_sols_yesOpCon = figure( 'Color', [1 1 1] );

for indn = 1:length(number_of_sols_yesOpCon)
    
    if indn == 1
        subplot(3,2,[indn, indn+1]);
    else
        subplot(3,2, indn+1);
    end

%     if indn == length(number_of_sols_noOpCon)
%         subplot(3,2,[indn, indn+1]);
%     else
%         subplot(3,2,indn);
%     end

    hold on;
    xlabel_name = [ 'Tree depth - ' number_of_sols_yesOpCon(indn).moon ];
    xlabel( xlabel_name); ylabel( 'log(N_s)' );

    before_modp = number_of_sols_yesOpCon(indn).before_modp;
    after_modp  = number_of_sols_yesOpCon(indn).after_modp;
    xx          = [ 1:1:length(before_modp) ]; 

    if indn == 1

        plot( xx, log(before_modp), 'o--', 'Color', 'k', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'black', 'LineWidth', 1, 'DisplayName', 'Before MODP' );
        plot( xx, log(after_modp), 'd--', 'Color', 'k', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'black', 'LineWidth', 1, 'DisplayName', 'After MODP' );
        xticks(xx);
    else

        plot( xx, log(before_modp), 'o--', 'Color', 'k', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'black', 'LineWidth', 1, 'HandleVisibility', 'Off' );
        plot( xx, log(after_modp), 'd--', 'Color', 'k', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'black', 'LineWidth', 1, 'HandleVisibility', 'Off' );
%         xticks(xx);
        xticks( [1 5 10 15] );
    end

    vline( number_of_sols_yesOpCon(indn).solObtainedOnLeg, 'k-' );

end

indn = 1;
subplot(3,2,[indn, indn+1]);
lgd = legend( 'Location', 'northoutside' );
lgd.NumColumns = 2;

plotFontSizeAxesDim(12, 12, fig_num_sols_yesOpCon);

set(fig_num_sols_yesOpCon, 'Position', [1000, 733, 812, 605]);

% nametosave = 'yesOpCon_numberSols';
% name_fig_0 = ['/paper_figures/' nametosave];
% exportgraphics(fig_num_sols_yesOpCon, [pwd name_fig_0 '.png' ], 'Resolution', 1200);
% savefig([pwd name_fig_0 '.fig' ]);


fig_perc_reduction = figure( 'Color', [1 1 1] );
subplot( 2, 1, 1 );
hold on; 

colors = cool( length(number_of_sols_noOpCon) );
for indn = 1:length(number_of_sols_noOpCon)
    
    perc_red = number_of_sols_noOpCon(indn).ratio;
    xx       = [ 1:1:length(perc_red) ];

    plot( xx, perc_red, 'o--', ...
        'Color', colors(indn,:), ...
        'MarkerEdgeColor', 'black', ...
        'MarkerFaceColor', colors(indn,:), ...
        'DisplayName', number_of_sols_noOpCon(indn).moon);

end

lgd = legend( 'Location', 'northoutside' );
lgd.NumColumns = 5;

xlabel( 'Tree depth' ); ylabel( 'Reduction [%]' );

plotFontSizeAxesDim(12, 12, fig_num_sols_yesOpCon);

subplot( 2, 1, 2 );
hold on; 

colors = cool( length(number_of_sols_yesOpCon) );
for indn = 1:length(number_of_sols_yesOpCon)
    
    perc_red = number_of_sols_yesOpCon(indn).ratio;
    xx       = [ 1:1:length(perc_red) ];

    plot( xx, perc_red, 'o--', ...
        'Color', colors(indn,:), ...
        'MarkerEdgeColor', 'black', ...
        'MarkerFaceColor', colors(indn,:), ...
        'HandleVisibility', 'off');

end

xlabel( 'Tree depth' ); ylabel( 'Reduction [%]' );

plotFontSizeAxesDim(12, 12, fig_num_sols_yesOpCon);

nametosave = 'percReduction_numberSols';
name_fig_0 = ['/paper_figures/' nametosave];
exportgraphics(fig_perc_reduction, [pwd name_fig_0 '.png' ], 'Resolution', 1200);
savefig([pwd name_fig_0 '.fig' ]);

%% --> sensitivity analysis

load('C:\Users\andre\Documents\GitHub\saturn_moon_tours\Solutions\outputParetoFront_noOpCon.mat')
outputParetoFront_noOpCon_50_step_50_dv = outputParetoFront;

load('C:\Users\andre\Documents\GitHub\saturn_moon_tours\Solutions\outputParetoFront_noOpCon_100_step_100_dv.mat')
outputParetoFront_noOpCon_100_step_100_dv = outputParetoFront;

load('C:\Users\andre\Documents\GitHub\saturn_moon_tours\Solutions\outputParetoFront_noOpCon_150_step_150_dv.mat')
outputParetoFront_noOpCon_150_step_150_dv = outputParetoFront;

clear outputParetoFront;

dvtot_noOpCon_50_step_50_dv  = [ outputParetoFront_noOpCon_50_step_50_dv.dvtot ]' + [ outputParetoFront_noOpCon_50_step_50_dv.dvOI ]';
toftot_noOpCon_50_step_50_dv = [ outputParetoFront_noOpCon_50_step_50_dv.toftot ]';

dvtot_noOpCon_100_step_100_dv  = [ outputParetoFront_noOpCon_100_step_100_dv.dvtot ]' + [ outputParetoFront_noOpCon_100_step_100_dv.dvOI ]';
toftot_noOpCon_100_step_100_dv = [ outputParetoFront_noOpCon_100_step_100_dv.toftot ]';

dvtot_noOpCon_150_step_150_dv  = [ outputParetoFront_noOpCon_150_step_150_dv.dvtot ]' + [ outputParetoFront_noOpCon_150_step_150_dv.dvOI ]';
toftot_noOpCon_150_step_150_dv = [ outputParetoFront_noOpCon_150_step_150_dv.toftot ]';

% --> START: plot Pareto fronts

colors = cool(3);

fig_pareto = figure('Color', [1 1 1]);
hold on; grid on;
ylabel('TOF [days]'); xlabel('\Deltav [m/s]');
plot( dvtot_noOpCon_50_step_50_dv.*1000, toftot_noOpCon_50_step_50_dv, 'o', 'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', colors(1,:), ...
    'MarkerSize', 10, ...
    'DisplayName', 'v_\infty step: 50 m/s' );

plot( dvtot_noOpCon_100_step_100_dv.*1000, toftot_noOpCon_100_step_100_dv, 'd', 'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', colors(2,:), ...
    'MarkerSize', 10, ...
    'DisplayName', 'v_\infty step: 100 m/s'  );

plot( dvtot_noOpCon_150_step_150_dv.*1000, toftot_noOpCon_150_step_150_dv, 's', 'MarkerEdgeColor', 'Black', ...
    'MarkerFaceColor', colors(3,:), ...
    'MarkerSize', 10, ...
    'DisplayName', 'v_\infty step: 150 m/s' );

plotFontSizeAxesDim(12, 12, fig_pareto);

lgd             = legend( 'Location', 'northoutside' );
lgd.NumColumns  = 3;

name_fig_0 = ['/paper_figures/pareto_fronts_sensitivity'];
exportgraphics(fig_pareto, [pwd name_fig_0 '.png' ], 'Resolution', 1200);
savefig([pwd name_fig_0 '.fig' ]);
% --> END: plot Pareto fronts



