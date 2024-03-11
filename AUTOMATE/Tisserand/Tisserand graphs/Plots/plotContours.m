function plotContours(IDS, vinflevels, idcentral, holdon, colCont, addlegend, AU)

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
% //
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
else
    figure( 'Color', [0 0 0] );
end

if isempty(AU)

    if idcentral == 1
        AU = 149597870.7;
    else
        [~, AU] = planetConstants(idcentral);
    end

end

for indplanet = 1:length(IDS)

    idpl = IDS(indplanet);
    
    if idpl == 0
        COLOR = 'green';
    elseif idpl == 1
        COLOR = [0 0.45 0.74];
    elseif idpl == 2
        COLOR = [0.64 0.08 0.18];
    elseif idpl == 3
        COLOR = [0 0.5 0];
    elseif idpl == 4
        COLOR = [0.3 0.75 0.93];
    elseif idpl == 5
        COLOR = 'Cyan';
    elseif idpl == 6
        COLOR = [0 0.5 0.2];
    elseif idpl == 7
        COLOR = 'Green';
    end

    greyCol = [0.80,0.80,0.80];

    [~, fullName] = planet_names_GA(idpl, idcentral);

    hold on;
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

if idcentral == 1

    idMIN = min(IDS);
    idMAX = max(IDS);
    XLIM(:,1) = [0.15 0.7 0.9 2 4 9.7 19]';
    XLIM(:,2) = [0.5  2   2.8 6 6 15  30]';  
    xlim([XLIM(idMIN,1) XLIM(idMAX,2)]);
    if idMAX == 5
        ylim([0 3]);
    elseif idMAX == 6
        ylim([0 4]);
    elseif idMAX == 7
        ylim([0 6.5]);
    end
    
    xlabel('r_a [AU]'); ylabel('r_p [AU]');

elseif idcentral == 5

    if max(IDS) == 4
        ylim([0 30]);
        xlim([5 200]);
    elseif max(IDS) == 3
        ylim([0 16]);
        xlim([5 200]);
    end

    xlabel('r_a [R_J]'); ylabel('r_p [R_J]');

elseif idcentral == 6

    if (max(IDS) == 5 && min(IDS) == 4) || ( max(IDS) == 5 && length(IDS) == 1 )

        ylim([2 22]);
        xlim([20 80]);

%         ylim([8 22]);
%         xlim([20 350]);
    
    elseif max(IDS) == 5 && min(IDS) == 0

        ylim([1.5 9.5]);
        xlim([3.8 35.5]);

    elseif max(IDS) == 5 && min(IDS) == 1

        ylim([1.5 9.5]);
        xlim([3.8 35.5]);


    elseif max(IDS) == 4 && min(IDS) == 3

%         ylim([2 9.5]);
%         xlim([5 26]);

        ylim([6 9.5]);
        xlim([8 24.5]);

    elseif max(IDS) == 3 && min(IDS) == 2

        xlim([6.4 9.8]);
        ylim([4.8 6.5]);

    elseif max(IDS) == 2 && min(IDS) == 1

        xlim([5 6.8]);
        ylim([3.8 5.1]);

    elseif max(IDS) == 1

        ylim([4 4.1]);
        xlim([4 5.2]);

    elseif max(IDS) == 4 && length(IDS) == 1
        
        ylim([5.5 9.5]);
        xlim([8.5 40.0]);

    end

    xlabel('r_a [R_S]'); ylabel('r_p [R_S]');

elseif idcentral == 7

%     ylim();
    xlim([0 150]);

    xlabel('r_a [R_U]'); ylabel('r_p [R_U]');

end

fig = gcf;
fig.Color = [1 1 1];

% xlim([0.975 4.15]);
% ylim([0.58 1.42]);

if addlegend == 1
    legend( 'Location', 'best' );
end

end
