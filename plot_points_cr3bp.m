function [fig] = plot_points_cr3bp( strucNorm, lpoint, colors, plotPrimary, plotSecondary, holdon )

% DESCRIPTION
% This function plots the Lagrange points in the Circular Restricted Three-Body Problem (CR3BP).
% Optionally, it can also plot the primary and secondary bodies.
% 
% INPUT
% - strucNorm    : structure containing normalization constants, including the normalized distances.
% - lpoint       : Lagrange point identifier (e.g., 'L1', 'L2', etc.).
% - colors       : (optional) color of the Lagrange point marker. Default is 'red'.
% - plotPrimary  : (optional) flag to plot the primary body (1 to plot, 0 to omit). Default is 0.
% - plotSecondary: (optional) flag to plot the secondary body (1 to plot, 0 to omit). Default is 0.
% - holdon       : (optional) flag to hold the current plot (1 to hold, 0 to create a new figure). Default is 0.
% 
% OUTPUT
% - fig          : figure handle of the generated plot.
%
% -------------------------------------------------------------------------

normDist = strucNorm.normDist;

if nargin == 2
    colors        = 'red';
    plotPrimary   = 0; % --> no primary is shown
    plotSecondary = 0; % --> no secondary is shown
    holdon        = 0;
elseif nargin == 3
    if isempty(colors)
        colors        = 'red';
    end
    plotPrimary   = 0; % --> no primary is shown
    plotSecondary = 0; % --> no secondary is shown
    holdon        = 0;
elseif nargin == 4
    if isempty(colors)
        colors        = 'red';
    end
    if isempty(plotPrimary)
        plotPrimary = 0;
    end
    plotSecondary = 0; % --> no secondary is shown
    holdon        = 0;
elseif nargin == 5
    if isempty(colors)
        colors        = 'red';
    end
    if isempty(plotPrimary)
        plotPrimary = 0;
    end
    if isempty(plotSecondary)
        plotSecondary = 0;
    end
    holdon        = 0;
elseif nargin == 6
    if isempty(colors)
        colors        = 'red';
    end
    if isempty(plotPrimary)
        plotPrimary = 0;
    end
    if isempty(plotSecondary)
        plotSecondary = 0;
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

if plotPrimary ~= 0
    % --> plot the primary
    plot3( strucNorm.x1.*normDist, 0, 0, 'o', 'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', 'yellow', 'MarkerSize', 8, ...
        'DisplayName', 'Primary body' );
end

if plotSecondary ~= 0
    % --> plot the secondary
    plot3( strucNorm.x2.*normDist, 0, 0, 'o', 'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', 'blue', 'MarkerSize', 8, ...
        'DisplayName', 'Secondary body' );
end

% --> extract the Lagrange point
LagrPoint = lagrange_point_and_gamma( strucNorm, lpoint );

% --> plot the L-points
plot3( LagrPoint(1).*normDist, ...
    LagrPoint(2).*normDist, ...
    LagrPoint(3).*normDist, 'o', 'MarkerEdgeColor', 'k', ...
        'MarkerFaceColor', colors(1,:), 'MarkerSize', 8, ...
        'DisplayName', lpoint );

end


