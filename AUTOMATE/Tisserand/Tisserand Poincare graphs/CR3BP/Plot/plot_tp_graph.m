function [fig, STRUC, STRUC_LL_1, STRUC_LL_2] = plot_tp_graph(idcentral, idMoon, vinfLevDIM, ramaxAdim, npoints)

% DESCRIPTION 
% This function is used to plot Tisserand-Poincarè graphs in adimensional
% variables.
% 
% INPUT
% - idcentral  : ID of the primary (see also constants.m)
% - idMoon     : ID of the secondary (see also constants.m)
% - vinfLevDIM : list of infinity velocity magnitudes [km/s]
% - ramaxAdim  : max. apoapsis in ADIMENSIONAL variables (if not given in
%                input, a default value of 5 is assumed)
% - npoints    : umber of points for the contours on the Tisserand-Poincare
%                map. Too high number can lead to high computational effort
%                (if not given in input, a default value of 1e3 is assumed)
%
% OUTPUT
% - fig : figure class showing the Tisserand-Poincare map
% 
% -------------------------------------------------------------------------

if nargin == 3
    ramaxAdim = 5;
    npoints  = 1e3;
elseif nargin == 4
    npoints = 1e3;
end

G = 6.672590000000000e-20;

[mu1, mu2, rPL] = constants(idcentral, idMoon);
mass1           = mu1/G;
mass2           = mu2/G;

% --> set the dimensionalization variables
mu        = mass2/(mass1 + mass2);
normDist  = rPL;
normTime  = sqrt(normDist^3/(G*(mass1 + mass2)));
normVel   = normDist/normTime;

% --> find libration point
[L1, L2, L3, L4, L5] = librationPoints(mu);

LL   = [ L1; L2; L3; L4; L5 ];
vinf = vinfLevDIM./normVel;

fig = figure( 'Color', [1 1 1] );
hold on; grid on;
xlabel( 'r_a [adim]' ); ylabel( 'r_p [adim]' );

x      = 1;       % x-coordinate of the bottom-left corner
y      = 0;       % y-coordinate of the bottom-left corner
width  = ramaxAdim;   % width of the rectangle
height = 1;  % height of the rectangle

rectangle('Position', [x, y, width, height],...
    'FaceColor', [0.9, 0.9, 0.9, 0.7], ...
    'EdgeColor', 'None');

% --> plot the Tisserand-Poincarè graph
[STRUC]      = plotTPgrap_vinf(vinf, ramaxAdim, npoints);
[STRUC_LL_1] = plotTP_graph_L_1(LL, mu, ramaxAdim, npoints);
[STRUC_LL_2] = plotTP_graph_L_2(LL, mu, ramaxAdim, npoints);

plotDiagonal;
legend( 'location', 'best' );

end
