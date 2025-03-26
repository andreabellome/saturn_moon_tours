function plotPath_reduced( path, idcentral, col, flipTraj, Name )

% DESCRIPTION
% This function is used as standalone bit to plot a path on a TG. This can
% handle also VILT transfer.
% 
% INPUT
% - path     : 
% - idcentral  : ID of the central body (see constants.m)
% - col      : optional input. Should be a string or an RGB triplet. This 
%              is used to specify the color of the trajectory on the
%              Tisserand graph. Default value is 'b'.
% - flipTraj : optional input. If passed as 1, then it flips the trajectory
%              (it was used for comet-sample-return mission analysis).
%              Default is 0.
% - Name     : optional input. Should be a string. This is used if one
%              wants to add legend to the trajectory on Tisserand graph.
% 
% OUTPUT
% //
% 
% -------------------------------------------------------------------------

if idcentral == 1
    AU = 149597870.7;
else
    [~, AU] = planetConstants(idcentral);
end

if nargin == 2
    col        = 'b';
    flipTraj   = 0;
    Name       = [];
elseif nargin == 3
    flipTraj   = 0;
    Name       = [];
elseif nargin == 4
    Name       = [];
end

indlegend = 0;
for indp = 1:size(path,1)-1
    
    if isnan(path(indp+1,6)) % --> intersection
        node1 = [ path(indp,1) path(indp,9:10) ];
        node2 = [ path(indp+1,3) path(indp+1,7:8) ];
    else % --> VILT
        node1 = [ path(indp,1) path(indp,9:10) ];
        node2 = [ path(indp+1,1) path(indp+1,7:8) ];
        node3 = [ path(indp+1,1) path(indp+1,9:10) ];
    end

    [ra1, rp1] = alphaVinf2raRp(node1(2), node1(3), node1(1), idcentral);
    [ra2, rp2] = alphaVinf2raRp(node2(2), node2(3), node2(1), idcentral);

    [rascCONT, rpscCONT] = tisserandTrajectory_SS(node1(1), node1(3), rp1, ra1, rp2, ra2, idcentral);

    if flipTraj == 1
        rascCONT = flip(rascCONT);
        rpscCONT = flip(rpscCONT);
    end

    if indlegend >= 1
        plot(rascCONT./AU, rpscCONT./AU, 'Color', col, ...
            'linewidth', 2, 'handlevisibility', 'off');
    else
        if isempty(Name)
            plot(rascCONT./AU, rpscCONT./AU, 'Color', col, ...
                'linewidth', 2, 'handlevisibility', 'off');
        else
            indlegend = indlegend + 1;
            plot(rascCONT./AU, rpscCONT./AU, 'Color', col, ...
                'linewidth', 2, 'DisplayName', Name);
        end
    end
    x = [rascCONT(end-1)./AU, rascCONT(end)./AU];
    y = [rpscCONT(end-1)./AU, rpscCONT(end)./AU];
    arrowh(x, y, col, 200);

    plot(ra1/AU, rp1/AU, 'k.', 'markersize', 15, 'handlevisibility', 'off');
    plot(ra2/AU, rp2/AU, 'k.', 'markersize', 15, 'handlevisibility', 'off');


    if ~isnan(path(indp+1,6)) % --> VILT arrow
        
        [ra3, rp3] = alphaVinf2raRp(node3(2), node3(3), node3(1), idcentral);

        if path(indp+1,11) > 1e-7
            x = [ra2, ra3]./AU;
            y = [rp2, rp3]./AU;
            plot(x, y, 'r', 'linewidth', 2, 'HandleVisibility', 'off');
            arrowh(x, y, 'r', 200);
            plot(ra3/AU, rp3/AU, 'k.', 'markersize', 15, ...
                'handlevisibility', 'off');
        end

    end

end

end