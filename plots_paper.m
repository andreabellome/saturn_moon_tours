
close all; clc;

load("C:\Users\Andrea\Documents\GitHub\saturn_moon_tours\Solutions\N_LEGS_BEFORE_AFTER_50_step_50_dv.mat");

moons = { 'Titan', 'Rhea', 'Dione', 'Thetys', 'Enceladus' };

n_sols_found = [ 2, 11, 7, 10, 6 ];

fig1 = figure( 'Color', [1 1 1] );
hold on; 

for indl = 1:length(N_LEGS_BEFORE_AFTER)
    
    before      = N_LEGS_BEFORE_AFTER(indl).before;
    after       = N_LEGS_BEFORE_AFTER(indl).after;
    tree_depth  = 1:1:length(before);
        
    if indl == 1
        ax = subplot(3,2,[1 2]);
    else
        ax = subplot(3,2,indl+1);
    end
    
    hold(ax, 'on');

    if indl > 1

        hold on;

        plot( tree_depth, log(before), ...
            '--o', 'Color', 'black', ...
            'MarkerSize', 8, ...
            'MarkerEdgeColor', 'black', ...
            'MarkerFaceColor', 'black', ...
            'HandleVisibility', 'off');
        plot( tree_depth, log(after), ...
            '--d', 'Color', 'black', ...
            'MarkerSize', 8, ...
            'MarkerEdgeColor', 'black', ...
            'MarkerFaceColor', 'black', ...
            'HandleVisibility', 'off');

    elseif indl == 1
        
        hold on;

        plot( tree_depth, log(before), ...
            '--o', 'Color', 'black', ...
            'MarkerSize', 8, ...
            'MarkerEdgeColor', 'black', ...
            'MarkerFaceColor', 'black', ...
            'DisplayName', 'Before MODP');
        plot( tree_depth, log(after), ...
            '--d', 'Color', 'black', ...
            'MarkerSize', 8, ...
            'MarkerEdgeColor', 'black', ...
            'MarkerFaceColor', 'black', ...
            'DisplayName', 'After MODP');

    end
    xline(n_sols_found(indl), ...
        'LineStyle', '--', ...
        'Color', 'black', ...
        'HandleVisibility', 'off');

    xlabel(['Tree-depth - ' moons{indl}]); ylabel('log(N_s)'); 
    
    lgd             = legend('Location', 'northoutside');
    lgd.NumColumns  = 2;
    lgd.Color       = 'none';
    lgd.EdgeColor   = 'none';

end

plotFontSizeAxesDim(15, 15, fig1, gca);
save_fig_custom( fig1, 300, 'pdf', [pwd '/noOpCon_numberSols.pdf']);
