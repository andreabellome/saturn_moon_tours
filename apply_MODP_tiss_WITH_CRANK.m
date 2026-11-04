function LEGSnext = apply_MODP_tiss_WITH_CRANK(LEGSnext, INPUT)

% DESCRIPTION
% This function applies a multi-objective dynamic programming (MODP) to the
% Tisserand exploration. The MODP sort is performed w.r.t. the first and
% second objectives defined in INPUT.costFunction (see for example
% costFunctionTiss.m). A rounding is performed on the time of flight with
% sensitivity of 5 days.
%
% The DP state is s = (ID, alpha, vinf, kappa), where kappa is the planar
% crank angle at arrival (0: outbound, pi: inbound), derived from the
% encounter geometry of the last leg (88/81/18/11). After an intersection
% (type = 0) kappa is free and coded as -1.
%
% INPUT
% - LEGSnext : matrix containing the tours. Each row is a tour. Each tour
%              is made by 'next_nodes' rows (see generateVILTSall.m) one
%              after the other.
% - INPUT    : structure with the following fields:
%              - INPUT.costFunction : cost function used to sort (see for
%              example costFunctionTiss.m)
%
% OUTPUT
% - LEGSnext : same as in input, but the number of rows (i.e. tours) is
%              now determined by MODP application
%
% -------------------------------------------------------------------------

if ~isempty(LEGSnext)

    % --> arrival crank flag from the geometry of the last leg
    typeLast = LEGSnext(:,end-10);
    kappa    = -1.*ones(size(typeLast));      % --> free (after intersections)
    kappa(typeLast == 88 | typeLast == 18) = 0;   % --> arrival outbound
    kappa(typeLast == 81 | typeLast == 11) = pi;  % --> arrival inbound

    keys = [ LEGSnext(:,end-11), LEGSnext(:,end-3), LEGSnext(:,end-2), kappa ];
    [~, ~, idGroup] = unique(keys, 'rows', 'stable'); % --> DP state (ID, alpha, vinf, kappa)

    ind        = 1;
    legstosav  = zeros( size(LEGSnext,1), size(LEGSnext,2) );
    for indl = 1:max(idGroup)

        % --> for every route incoming to the same node, find the PF
        indxs   = find(idGroup == indl);
        legs    = LEGSnext(indxs,:);

        % --> extract the cost functions
        [dvtot, toftot] = INPUT.costFunction(legs);

        % --> compute the Pareto front
        pf              = paretoFront_MODP( [ toftot dvtot ] );

        % --> round w.r.t. the TOF
        % pf(:,1)  = round(pf(:,1)./10).*10; % --> precision 10 days
        pfs      = sortrows( pf, [1, 2] );
        [~, idx] = unique( pfs(:,1), 'rows', 'stable'  );   % --> first w.r.t. TOF
        pf       = pfs(idx,:);

        % --> save the tours
        ltos = legs(pf(:,end),:);
        legstosav(ind:ind-1+size(ltos,1), :) = ltos;
        ind = ind + size(ltos,1);

    end
    legstosav(legstosav(:,1) == 0,:) = [];
    LEGSnext                         = legstosav;

end

end