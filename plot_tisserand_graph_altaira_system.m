%% --> CLEAR ALL AND ADD AUTOMATE TO THE PATH

clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%% --> Plot contours of multiple moons

% --> set-up the system (Altaira in this case)
idcentral  = 100;             % --> Altaira is the central body (see constants.m)
IDS        = [ 1 2 3 4 5 6 7 8 9 10]; % --> Major planets IDs (see constants.m)
%IDS        = [ 10 ]; % --> Major planets IDs (see constants.m)
vinflevels = {35:5:80;
              3:1:20;
              3:1:20;
              4:1:15;
              2:1:10;
              0.5:0.5:7;
              0.5:0.5:7;
              0.5:0.5:5;
              7:0.5:8;
              0.5:0.5:3};     % --> infinity velocity levels [km/s]
% vinflevels = {
%               1:1:5};     % --> infinity velocity levels [km/s]


%% --> create the figure
tisserandGraph = figure('Name','Tisserand Graph','NumberTitle','off');
hold on; grid on;

% --> Loop on the planets
colors = lines( length(IDS) );
AU = 149597870.7;
for i=1:length(IDS)
    idPlanet = IDS(i);
    vInfs = cell2mat(vinflevels(i,:));
    COLOR   = colors( i,: );
    [~, fullName] = planet_names_GA(idPlanet, idcentral);

    for indi = 1:length(vInfs)

        [rascCONT, rpscCONT] = ...
            generateContoursMoonsSat(idPlanet, vInfs(indi), idcentral);

        if indi == 1
            hold on;
            plot(rascCONT./AU, rpscCONT./AU, ...
                'Color', COLOR,...
                'DisplayName', fullName);

        else
            hold on;
            plot(rascCONT./AU, rpscCONT./AU, ...
                'Color', COLOR, ...
                'handlevisibility', 'off');
        end

        text(rascCONT(1)/AU, rpscCONT(1)/AU, num2str(vInfs(indi)), ...
        'FontSize', 6, ...
        'Color', COLOR, ...
        'FontAngle', 'italic', ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom')
    
        text(rascCONT(end)/AU, rpscCONT(end)/AU, num2str(vInfs(indi)), ...
        'FontSize', 6, ...
        'Color', COLOR, ...
        'FontAngle', 'italic', ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom')

    end

    legend( 'Location', 'best' );
    
    labelsDim = 12;
    axesDim   = 12;
    set(findall(gcf,'-property','FontSize'), 'FontSize',labelsDim)
    h = findall(gcf, 'type', 'text');
    set(h, 'fontsize', axesDim);
    ax          = gca; 
    ax.FontSize = axesDim;
    xlabel('Apoapsis [AU]')
    ylabel('Periapsis [AU]')

end
