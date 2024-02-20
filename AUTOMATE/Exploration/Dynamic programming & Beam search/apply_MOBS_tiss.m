function LEGSnext = apply_MOBS_tiss(LEGSnext, INPUT)

% DESCRIPTION
% This function applies a multi-objective Beam Search (MOBS) to the
% Tisserand exploration. The MOBS sort is performed w.r.t. the first and
% second objectives defined in INPUT.costFunction (see for example
% costFunctionTiss.m).
%
% INPUT
% - LEGSnext : matrix containing the tours. Each row is a tour. Each tour
%              is made by 'next_nodes' rows (see generateVILTSall.m) one
%              after the other.
% - INPUT    : structure with the following fields:
%              - INPUT.BW : beam width
%              - INPUT.costFunction : cost function used to sort (see for
%              example costFunctionTiss.m)
%
% OUTPUT
% - LEGSnext : same as in input, but the number of rows (i.e. tours) is
%              max. equal to INPUT.BW
%
% -------------------------------------------------------------------------

if ~isempty(LEGSnext)

    % --> extract the beam width
    BW  = INPUT.BW;

    if size(LEGSnext,1) > BW

        legstosav = [];
        ind       = 1;
    
        while size(legstosav,1) <= BW && ~isempty(LEGSnext)
            
            % --> extract the cost functions
            [dvtot, toftot] = INPUT.costFunction(LEGSnext);
            
            % --> compute the Pareto front
            pf = paretoFront_MODP( [ toftot dvtot ] );

            % --> save the legs in the Pareto front
            ltos = LEGSnext(pf(:,end),:);
            legstosav(ind:ind-1+size(ltos,1), :) = ltos;
            ind = ind + size(ltos,1);
    
            % --> eliminate and compute the second front
            LEGSnext(pf(:,end),:) = [];
    
        end
    
        LEGSnext = legstosav;

    end

end

end
