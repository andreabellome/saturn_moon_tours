function fig = plotContours(IDS, vinflevels, idcentral, holdon, colCont, addlegend, AU)

% DESCRIPTION
% This function plots Tisserand contours for specified flyby bodies and
% infinity velocity levels.
% 
% INPUT
% - IDS        : list of IDs of flyby bodies (see constants.m)
% - vinflevels : list of infinity velocities [km/s]
% - idcentral  : ID of the central body (see constants.m)
% - holdon     : optional input. If passed as 0, new figure is opened, if
%                passed as 1 the current figure is used to plot. Default is
%                0.
% - colCont    : optional input. If passed as 0 then the Tisserand contours
%                are plotted as grey, if passed as 1 then they are plotted
%                in colours. Default is 1.
% - addlegend  : optional input. If passed as 0, no legend is shown, if
%                passed as 1 the legend is shown. Default is 0.
% - AU         : optional input. This value scales the contours, and it
%                should be a number. Default is empty, then the scale is
%                as follows:
%                - if idcentral = 1 --> then the central body is the Sun
%                   --> then the scaling is Astronomical Unit (approx.
%                   150e6 km)
%                - if idcentral = 5 --> then the central body is Jupiter
%                   --> then the scaling is Jupiter radius
%                - if idcentral = 6 --> then the central body is Saturn
%                   --> then the scaling is Saturn radius
%                - if idcentral = 7 --> then the central body is Uranus
%                   --> then the scaling is Uranus radius
% 
% OUTPUT
% - fig         : object with the figure details.
% 
% -------------------------------------------------------------------------


if nargin == 2
    idcentral   = 1;
    holdon      = 0;
    colCont     = 1;
    addlegend   = 0;
    AU          = [];
elseif nargin == 3
    holdon     = 0;
    colCont    = 1;
    addlegend  = 0;
    AU         = [];
elseif nargin == 4
    colCont   = 1;
    addlegend = 0;
    AU        = [];
elseif nargin == 5
    addlegend = 0;
    AU        = [];
elseif nargin == 6
    AU = [];
end

if holdon == 1 % --> keep the same figure open
    fig = gcf;
    fig.Color = [ 1 1 1 ];
else
    figure( 'Color', [1 1 1] );
end

if isempty(AU)

    if idcentral == 1 || idcentral == 100
        AU = 149597870.7;
    else
        [~, AU] = planetConstants(idcentral);
    end

end

colors = cool( length(IDS) );
for indplanet = 1:length(IDS)

    idpl = IDS(indplanet);
    
    COLOR   = colors( indplanet,: );
    greyCol = [0.80,0.80,0.80];

    [~, fullName] = planet_names_GA(idpl, idcentral);

    hold on; grid on;
    for indi = 1:length(vinflevels)

        [rascCONT, rpscCONT] = ...
            generateContoursMoonsSat(idpl, vinflevels(indi), idcentral);
        
        if addlegend == 1

            if indi == 1

                if colCont == 1
                    hold on;
                    plot(rascCONT./AU, rpscCONT./AU, ...
                        'Color', COLOR,...
                        'DisplayName', fullName);
                else
                    hold on;
                    plot(rascCONT./AU, rpscCONT./AU,...
                        'Color', greyCol,...
                        'DisplayName', fullName);
                end

            else
                if colCont == 1
                    hold on;
                    plot(rascCONT./AU, rpscCONT./AU, ...
                        'Color', COLOR, ...
                        'handlevisibility', 'off');
                else
                    hold on;
                    plot(rascCONT./AU, rpscCONT./AU, ...
                        'Color', greyCol, ...
                        'handlevisibility', 'off');
                end
            end

        else

            if colCont == 1
                hold on;
                plot(rascCONT./AU, rpscCONT./AU,...
                    'Color', COLOR,...
                    'handlevisibility', 'off');
            else
                hold on;
                plot(rascCONT./AU, rpscCONT./AU,...
                    'Color', greyCol,...
                    'handlevisibility', 'off');
            end

        end

    end
end

processLabelPlots( idcentral, IDS );

fig = gcf;
fig.Color = [1 1 1];

% xlim([0.975 4.15]);
% ylim([0.58 1.42]);

if addlegend == 1
    legend( 'Location', 'best' );
end

labelsDim = 12;
axesDim   = 12;
set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
h = findall(gcf, 'type', 'text');
set(h, 'fontsize', axesDim);
ax          = gca; 
ax.FontSize = axesDim; 

end
