function LEGSnext = apply_MODP_tiss(LEGSnext, INPUT)

% DESCRIPTION
% This function applies a multi-objective dynamic programming (MODP) to the
% Tisserand exploration. The MODP sort is performed w.r.t. the first and
% second objectives defined in INPUT.costFunction (see for example
% costFunctionTiss.m). A rounding is performed on the time of flight with
% sensitivity of 5 days.
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

    [last_nodes_U] = unique([ LEGSnext( :,end-11 ), LEGSnext( :,end-3 ) LEGSnext( :,end-2 ) ], ...
        'rows', 'stable'); % --> apply SODP
    
    ind        = 1;
    legstosav  = zeros( size(LEGSnext,1), size(LEGSnext,2) );
    for indl = 1:size(last_nodes_U,1)
    
        % --> for every route incoming to the same node, find the PF
        indxs   = find(LEGSnext(:,end-11) == last_nodes_U(indl,end-2) &...
                       LEGSnext(:,end-3)  == last_nodes_U(indl,end-1) &...
                       LEGSnext(:,end-2)  == last_nodes_U(indl,end));
        legs    = LEGSnext(indxs,:);
    
        % --> extract the cost functions
        [dvtot, toftot] = INPUT.costFunction(legs);
        
        % --> compute the Pareto front
        pf              = paretoFront_MODP( [ toftot dvtot ] );

        % --> round w.r.t. the TOF
        pf(:,1)  = round(pf(:,1)./10).*10; % --> precision 5 days
        pfs      = sortrows( pf, [1, 2] );
        [~, idx] = unique( pfs(:,1), 'rows', 'stable'  );   % --> first w.r.t. TOF
        pfnew    = pfs(idx,:);
        pf       = pfnew;
        
        % --> save the tours
        ltos = legs(pf(:,end),:);
        legstosav(ind:ind-1+size(ltos,1), :) = ltos;
        ind = ind + size(ltos,1);
    
    end
    legstosav(legstosav(:,1) == 0,:) = [];
    LEGSnext                         = legstosav;

end

end
