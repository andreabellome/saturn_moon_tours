function LEGSnext = sortDVtof(LEGSnext, INPUT)

% DESCRIPTION
% This function is used to sort the tours on Tisserand map w.r.t. the cost
% functions (see for example costFunctionTiss.m). Tours are sorted first
% w.r.t. the first objective (e.g., DV), and then w.r.t. the second
% objective (e.g., TOF).
% 
% INPUT
% - LEGSnext : matrix containing the tours. Each row is a tour. Each tour
%              is made by 'next_nodes' rows (see generateVILTSall.m) one
%              after the other.
% - INPUT : structure with the following mandatory fields:
%              - costFunction : cost function (see for
%              example costFunctionTiss.m)
% 
% OUTPUT
% - LEGSnext : same as in input but the rows, i.e., tours, are now sorted
%              w.r.t. first and second objectives in INPUT.costFunction 
%
% -------------------------------------------------------------------------

if ~isempty(LEGSnext)
    
    % --> compute the cost functions
    [dvtot, toftot] = INPUT.costFunction(LEGSnext);

    % --> sort w.r.t. DV and TOF
    dvtot    = sortrows([dvtot toftot [1:size(dvtot,1)]'], [1 2]); 
    LEGSnext = LEGSnext(dvtot(:,end),:);
end

end