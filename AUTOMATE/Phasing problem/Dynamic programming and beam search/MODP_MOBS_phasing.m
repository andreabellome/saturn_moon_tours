function output2 = MODP_MOBS_phasing(output2, bw, INPUT)

% DESCRIPTION
% This function applies multi-objective dynamic programming (MODP) and
% multi-objective beam search (MOBS) to the structure 'output2' as from the
% function exploreTisserandGraph.m
% 
% INPUT
% - output2 : structure where each rows contains tours with same number of
%            flbys. It has the following fields: 
%            - LEGS : matrix containing the tours. Each row is a tour. Each
%            tour is made by 'next_nodes' rows (see generateVILTSall.m) one
%            after the other.
%            - dvtot : column vector containing the overall DV for the
%            tours [km/s] 
%            - toftot : column vector containing the overall TOF for the
%            tours [days]
%            - vinfa : column vector containing the arrival infinity
%            velocity for the tours [km/s]
% - bw      : beam width 
% - INPUT   : structure with the following mandarory fields:
%           - BW           : beam width
%           - costFunction : cost function (see for example
%           costFunctionTiss.m) 
% 
% OUTPUT
% - output2 : same as in input but the number of rows are pruned with
%             respect to MODP and MOBS application.
% -------------------------------------------------------------------------

% --> start: apply MODP
if ~isempty(output2)
    
    dvtotFull  = output2.dvtot;
    toftotFull = output2.toftot;
    LEGSnext   = output2.LEGS;

    % --> find the unique arrival nodes
    arrNodes       = [ LEGSnext( :,end-11 ), LEGSnext( :,end-3 ) LEGSnext( :,end-2 ) ];
    [last_nodes_U] = uniquetol(arrNodes, 1e-6, 'ByRows', true);

    ind        = 1;
    legstosav  = zeros( size(LEGSnext,1), size(LEGSnext,2) );
    for indl = 1:size(last_nodes_U,1)
    
        % --> for every route incoming to the same node, find the PF
        indxs   = find(LEGSnext(:,end-11) == last_nodes_U(indl,end-2) &...
                       LEGSnext(:,end-3)  == last_nodes_U(indl,end-1) &...
                       LEGSnext(:,end-2)  == last_nodes_U(indl,end));
        legs    = LEGSnext(indxs,:);
        dvtot   = dvtotFull(indxs,:);
        toftot  = toftotFull(indxs,:);
    
        pf = paretoFront_MODP( [ toftot dvtot ] );

        % --> round w.r.t. the TOF
        pf(:,1)  = round(pf(:,1)./10).*10; % --> precision 5 days
        pf(:,2)  = round(pf(:,2), 2);      % --> precision 0.005 km/s
        pfs      = sortrows( pf, [1, 2] );

        [~, idx] = unique( pfs(:,1), 'rows', 'stable'  );   % --> first w.r.t. TOF
        pfnew    = pfs(idx,:);

%         if INPUT.pldep == INPUT.plarr % --> only apply DV bins on the ENDGAME
%             [~, idx] = unique( pfnew(:,2), 'rows', 'stable'  ); % --> second w.r.t. DV
%             pfnew    = pfnew(idx,:);
%         end

        pf   = pfnew;
        
        ltos = legs(pf(:,end),:);
    
        legstosav(ind:ind-1+size(ltos,1), :) = ltos;
        ind = ind + size(ltos,1);
    
    end
    legstosav(legstosav(:,1) == 0,:) = [];
    LEGSnext                         = legstosav;

    % --> save the output
    output2.LEGS = LEGSnext;
    [output2.dvtot, output2.toftot, output2.vinfa] = INPUT.costFunction(LEGSnext);

end
% --> end: apply MODP

% --> start: apply MOBS
INPUT.BW = bw;
LEGSnext = apply_MOBS_tiss(output2.LEGS, INPUT);

% --> save the output
output2.LEGS                                   = LEGSnext;
[output2.dvtot, output2.toftot, output2.vinfa] = INPUT.costFunction(LEGSnext);
% --> end: apply MOBS

% if ~isempty(output2)
%     dvtot = output2.dvtot;
%     if bw < length(dvtot)
%         matso          = sortrows( [dvtot [1:1:length(dvtot)]'], 1 );
%         indxs          = matso(1:bw,end);
%         output2.LEGS   = output2.LEGS(indxs,:);
%         output2.dvtot  = output2.dvtot(indxs,:);
%         output2.toftot = output2.toftot(indxs,:);
%         output2.vinfa  = output2.vinfa(indxs,:);
%     end
% end

end
