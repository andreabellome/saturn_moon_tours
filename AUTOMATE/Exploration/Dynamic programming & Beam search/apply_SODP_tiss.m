function LEGSnext = apply_SODP_tiss(LEGSnext, INPUT)

% DESCRIPTION
% This function applies a single-objective dynamic programming (SODP) to the
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

    % [last_nodes_U] = unique([ LEGSnext( :,end-11 ), LEGSnext( :,end-10 ) LEGSnext( :,end-5 ) LEGSnext( :,end-4 ) LEGSnext( :,end-3 ) LEGSnext( :,end-2 ) ], ...
    %     'rows', 'stable'); % --> apply SODP
    
    [last_nodes_U] = unique([ LEGSnext( :,end-11 ), LEGSnext( :,end-3 ) LEGSnext( :,end-2 ) ], ...
        'rows', 'stable'); % --> apply SODP

    ind        = 1;
    legstosav  = zeros( size(LEGSnext,1), size(LEGSnext,2) );
    for indl = 1:size(last_nodes_U,1)
    
        % --> for every route incoming to the same node, find the PF
        % indxs   = find(LEGSnext(:,end-11) == last_nodes_U(indl,end-5) &...
        %                LEGSnext(:,end-10) == last_nodes_U(indl,end-4) &...
        %                LEGSnext(:,end-5)  == last_nodes_U(indl,end-3) &...
        %                LEGSnext(:,end-4)  == last_nodes_U(indl,end-2) & ...
        %                LEGSnext(:,end-3)  == last_nodes_U(indl,end-1) & ...
        %                LEGSnext(:,end-2)  == last_nodes_U(indl,end));
        % legs    = LEGSnext(indxs,:);

        indxs   = find(LEGSnext(:,end-11) == last_nodes_U(indl,end-2) &...
                       LEGSnext(:,end-3)  == last_nodes_U(indl,end-1) &...
                       LEGSnext(:,end-2)  == last_nodes_U(indl,end));
        legs    = LEGSnext(indxs,:);
    
        % --> extract the cost functions
        costValue = INPUT.costFunction(legs);
        
        [ minCostValue, row ] = min( costValue );

        % --> save the tours
        ltos = legs(abs(costValue - minCostValue) < 1e-6,:);
        legstosav(ind:ind-1+size(ltos,1), :) = ltos;
        ind = ind + size(ltos,1);
    
    end
    legstosav(legstosav(:,1) == 0,:) = [];
    LEGSnext                         = legstosav;

end

end
