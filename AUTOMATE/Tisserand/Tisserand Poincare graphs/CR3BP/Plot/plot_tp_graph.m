function [fig, STRUC, STRUC_LL_1, STRUC_LL_2] = plot_tp_graph(idcentral, IDS, ...
                                                                vinfLevDIM, ramaxAdim, ...
                                                                npoints, param, holdon)

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
% - param      : Structure with the following fields:
%                param.adim: if 0, the DIMENSIONAL-unit plot is provided,
%                otherwise, ADIMENSIONAL-unit plot is provided. Default is 1. 
%                param.normDist: dimensionalization unit (distance from
%                central body).
% - holdon     : if 0, a new figure is opened, otherwise the current figure
%                is used. Default is 0.
%
% OUTPUT
% - fig : figure class showing the Tisserand-Poincare map
% 
% -------------------------------------------------------------------------

if nargin == 3
    ramaxAdim = 5;
    npoints   = 1e3;
    param.adim = 1;
    param.legend = 1;
    holdon    = 0;
elseif nargin == 4
    npoints = 1e3;
    param.adim = 1;
    param.legend = 1;
    holdon  = 0;
elseif nargin == 5
    param.adim = 1;
    param.legend = 1;
    holdon = 0;
elseif nargin == 6
    holdon = 0;
end

G = 6.672590000000000e-20;

if holdon == 0
    
    fig = figure( 'Color', [1 1 1] );
    hold on; grid on;
    if param.adim == 1
        xlabel( 'r_a [adim]' ); ylabel( 'r_p [adim]' );
    end
else
    fig = gcf;
    fig.Color = [ 1 1 1 ];
    hold on; grid on;
    if param.adim == 1
        xlabel( 'r_a [adim]' ); ylabel( 'r_p [adim]' );
    end
end

for ind = 1:length(IDS)

    idMoon = IDS(ind);

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

    if param.adim == 0
        param.normDist = normDist;
        if isfield(param, 'AU')
            param.normDist = param.normDist/param.AU;
        else
            if idcentral == 1
                AU = 149597870.7;
            else
                [~, AU] = planetConstants(idcentral);
            end
            param.AU = AU;
            param.normDist = param.normDist/param.AU;
        end
    end
    
    x      = 1;       % x-coordinate of the bottom-left corner
    y      = 0;       % y-coordinate of the bottom-left corner
    width  = ramaxAdim;   % width of the rectangle
    height = 1;  % height of the rectangle
    
    if param.adim == 1
        rectangle('Position', [x, y, width, height],...
            'FaceColor', [0.9, 0.9, 0.9, 0.7], ...
            'EdgeColor', 'None');
    else
        if length(IDS) == 1
            rectangle('Position', [x.*param.normDist, y.*param.normDist, ...
                width.*param.normDist, height.*param.normDist],...
            'FaceColor', [0.9, 0.9, 0.9, 0.7], ...
            'EdgeColor', 'None');
        end
    end
    
    % --> plot the Tisserand-Poincarè graph
    [STRUC]      = plotTPgrap_vinf(vinf, ramaxAdim, npoints, param);
    [STRUC_LL_1] = plotTP_graph_L_1(LL, mu, ramaxAdim, npoints, param);
    [STRUC_LL_2] = plotTP_graph_L_2(LL, mu, ramaxAdim, npoints, param);

end

if param.adim == 0
    processLabelPlots( idcentral, IDS );
end

plotDiagonal;
if isfield(param, 'legend')
    if param.legend == 1
        legend( 'location', 'best' );
    end
end

end
