function LEGSnext_1 = nodeAttachedAlreadyVisited(LEGSnext_1)

% DESCRIPTION
% This function prevents the tour to visit the same node. If the last node
% added to a tour is already present in the tour itself, then it is pruned.
%
% INPUT
% - LEGSnext_1 : matrix containing the tours. Each row is a tour. Each tour
%              is made by 'next_nodes' rows (see generateVILTSall.m) one
%              after the other.
% 
% OUTPUT
% - LEGSnext_1 : same as in input, but the number of rows (i.e., tours) is
%                limited by the constraints applied
%
% -------------------------------------------------------------------------

if ~isempty(LEGSnext_1)

    indtodel = zeros(size(LEGSnext_1,1),1);
    for indl = 1:size(LEGSnext_1,1)

        path      = reshape(LEGSnext_1(indl,:), 12, [])';
        lastNode  = path(end,7:10);
        diffNodes = abs( path(1:end-1,7:10) - lastNode );
        indxs     = find( diffNodes(:,1) < 1e-6 & diffNodes(:,2) < 1e-6 & ...
            diffNodes(:,3) < 1e-6 & diffNodes(:,4) < 1e-6, 1 );

        if ~isempty(indxs) % --> the node has been already visited in the same path
            indtodel(indl,1) = indl;
        end

    end
    indtodel(indtodel==0,:) = [];

    LEGSnext_1(indtodel,:) = [];

end

end
