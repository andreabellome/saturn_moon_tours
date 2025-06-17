function fig = plotContour_singleLine(IDS, vinflevels, idcentral, holdon, color, plot_scale, names)

if nargin == 2
    idcentral = 1;
    holdon = 0;
    color = [];
    plot_scale = [];
    names = [];
elseif nargin == 3
    holdon = 0;
    color = [];
    plot_scale = [];
    names = [];
elseif nargin == 4
    if isempty(holdon)
        holdon = 0;
    end
    if color == 0
        color = [];
    end
    plot_scale = [];
    names = [];
elseif nargin == 5
    if isempty(holdon)
        holdon = 0;
    end
    if color == 0
        color = [];
    end
    plot_scale = [];
    names = [];
elseif nargin == 6
    if isempty(holdon)
        holdon = 0;
    end
    if color == 0
        color = [];
    end
    if plot_scale == 0
        plot_scale = [];
    end
    names = [];
end

if holdon == 0
    fig = figure('Color', [1 1 1]);
else
    fig = gcf;
    fig.Color = [1 1 1];
end

if isempty(plot_scale)
    if idcentral == 1
        AU = 149597870.7;
    else
        [~, AU] = planetConstants(idcentral);
    end
    plot_scale = AU;
end
AU = plot_scale;

for indplanet = 1:length(IDS)
    idpl = IDS(indplanet);
    
    if isempty(color)
        if idpl == 1
            color = [0 0.45 0.74];
        elseif idpl == 2
            color = [0.64 0.08 0.18];
        elseif idpl == 3
            color = [0 0.5 0];
        elseif idpl == 4
            color = [0.3 0.75 0.93];
        elseif idpl == 5
            color = [0 0 0];
        elseif idpl == 6
            color = [0 0.5 0.2];
        end
    end

    hold on;
    for indi = 1:length(vinflevels)

        [rascCONT, rpscCONT] = generateContoursMoonsSat(idpl, vinflevels(indi), idcentral);
        
        if indi == 1
            if isempty(names) || (iscell(names) && isequal(names, {0}))
                hold on;
                plot(rascCONT./AU, rpscCONT./AU, 'color', color, 'HandleVisibility', 'off');
            else
                plot(rascCONT./AU, rpscCONT./AU, 'color', color, 'DisplayName', names{indplanet});
            end
        else
            plot(rascCONT./AU, rpscCONT./AU, 'color', color, 'HandleVisibility', 'off');
        end
        
    end
end

% idMIN = min(IDS);
% idMAX = max(IDS);
% XLIM(:,1) = [0.15 0.7 0.9 2 4 9.7]';
% XLIM(:,2) = [0.5  2   2.8 6 6 15]';  
% xlim([XLIM(idMIN,1) XLIM(idMAX,2)]);
% if idMAX >= 5
%     ylim([0 2]);
% end

% xlabel('r_a - AU'); ylabel('r_p - AU');

end
