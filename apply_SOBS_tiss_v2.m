function LEGSnext = apply_SOBS_tiss_v2(LEGSnext, INPUT)

% DESCRIPTION
% This function applies a single-objective Beam Search (SOBS) to the
% Tisserand exploration. The SOBS sort is performed w.r.t. the first
% objective defined in INPUT.costFunction (see for example
% costFunctionTiss.m), and then w.r.t. to the second objective.
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
    BW = INPUT.BW;
    
    % --> eliminate w.r.t. BW
    if size(LEGSnext,1) > BW

        legstosav = [];

        while size(legstosav,1) <= BW && ~isempty(LEGSnext)
            
            % --> extract the cost functions
            [dvtot, toftot] = INPUT.costFunction(LEGSnext);

            % --> sort
            dvtot_rounded  = round(dvtot./1e-4).*1e-4;
            toftot_rounded = round(toftot./10).*10;
    
            dvtot    = sortrows([dvtot_rounded toftot [1:size(dvtot,1)]'], [1 2]); % --> sort w.r.t. the total DV    
            [~, idx] = unique( dvtot(:,1), 'rows', 'stable'  );
            dvtot    = dvtot(idx,:);

            legstosav = [legstosav; LEGSnext(dvtot(:,end),:)];

            LEGSnext(dvtot(:,end),:) = [];

        end

        LEGSnext = legstosav;
        
    end

end

end