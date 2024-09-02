function plotResonances(IDS, RES, res, idcentral, addLegend, nColLeg, AU)

% DESCRIPTION
% This function is used to plot resonant loci on Tisserand map. This
% function should be used in conjunction with plotContours.m
%
% INPUT
% - IDS       : list of IDs of flyby bodies (see constants.m)
% - RES       : matrix containing the following information :
%               - RES(:,1) : planet
%               - RES(:,2) : alpha angle of the resonant point on Tisserand (rad)
%               - RES(:,3) : inf. vel. of the resonant point on Tisserand (km/s)
%               - RES(:,4) : N (planet revolutions)
%               - RES(:,5) : M (spacecraft revolutions)
% - res       : optional input. The user can specify the single resonance
%               to plot, ONLY IF this is present in
%               findResonancesPlanets.m; default value is empty, thus all
%               the resonances in findResonancesPlanets.m are plotted.
% - idcentral : ID of the central body (see constants.m)
% - addlegend : optional input. If passed as 0, no legend is shown, if
%               passed as 1 the legend is shown. Default is 0.
% - nColLeg   : optional input. Number of columns for the legend. Default
%               is 1.
% OUTPUT
% //
%
% -------------------------------------------------------------------------

if nargin == 2
    res = [];
    idcentral = 1;
    addLegend = 0;
    nColLeg   = 1;
    AU = [];
elseif nargin == 3

    if ~isempty(res)
        indxs = [];
        for indr = 1:size(res,1)
            indxs = [indxs; find(RES(:,4) == res(indr, 1) & ...
                RES(:,5) == res(indr, 2))];
        end
    RES = RES(indxs,:);
    end
    idcentral = 1;
    addLegend = 0;
    nColLeg = 1;
    AU = [];
elseif nargin == 4
    addLegend = 0;
    nColLeg = 1;
    AU = [];
elseif nargin == 5
    if isempty(addLegend)
        addLegend = 0;
    end
    nColLeg = 1;
    AU = [];
elseif nargin == 6
    nColLeg = 1;
    AU = [];
end

if ~isempty(res)
        indxs = [];
        for indr = 1:size(res,1)
            indxs = [indxs; find(RES(:,4) == res(indr, 1) & ...
                RES(:,5) == res(indr, 2))];
        end
    RES = RES(indxs,:);
end

if isempty(AU)
    if idcentral == 1
        AU = 149597870.7;
    else
        [~, AU] = planetConstants(idcentral);
    end
end

pl    = zeros(size(RES,1),1);
alpha = zeros(size(RES,1),1);
vinf  = zeros(size(RES,1),1);
ra    = zeros(size(RES,1),1);
rp    = zeros(size(RES,1),1);
for indres = 1:size(RES,1)
   
    pl(indres,1)    = RES(indres,1);
    alpha(indres,1) = RES(indres,2);
    vinf(indres,1)  = RES(indres,3);
    
    [ra(indres,1), rp(indres,1)] = ...
        alphaVinf2raRp(alpha(indres,1), vinf(indres,1), ...
        pl(indres,1), idcentral);
    
end
N = RES(:,4);
M = RES(:,5);

RES_2 = [pl alpha vinf N M ra rp];

INDRESN = 1;
for indpl = 1:length(IDS)
    
    pl    = IDS(indpl);
    indxs = find(RES_2(:,1) == pl);

    [~, ~, rpl] = constants(idcentral, pl);
    
    if ~isempty(indxs)
        
        NM = unique(RES_2(:,4:5), "rows", "stable");

        colors = cool(size(NM,1));

        for indm = 1:size(NM,1)

            N     = NM(indm,1);
            M     = NM(indm,2);

            if N > 1 && M < N
                rares0 = -rpl + 2*rpl*(N/M)^(2/3); % --> equation for resonances
                rares  = linspace( rares0, 100*rpl, 1e3 );
            else
                rares  = linspace( rpl, 100*rpl, 1e3 );
            end

            % --> equation for resonances
            rpres = -rares + 2*rpl*(N/M)^(2/3); 
            
            inddel        = find(rpres > rpl );
            rares(inddel) = [];
            rpres(inddel) = [];
            
            if addLegend == 0
                hold on;
                plot( rares./AU, rpres./AU, 'Color', colors(indm,:), ...
                    'handlevisibility', 'off' ); 
            elseif addLegend == 1

                nameLeg = [num2str(N) ':' num2str(M)];
                legendnameRes{INDRESN} = nameLeg;
                INDRESN = INDRESN + 1;
                plot( rares./AU, rpres./AU, 'Color', colors(indm,:), ...
                    'DisplayName', nameLeg); 
            end

        end
    end
end

if addLegend == 1
    columnlegend(nColLeg, legendnameRes, 'location', 'souteast');
end

% --> automatically scaling the plot
idmax = max(IDS);
[~, ~, rpl] = constants(idcentral, idmax);
[~, radius] = planetConstants(idcentral);
y_scaling = rpl/radius;

ylim( [0-2 y_scaling+2] );

end
