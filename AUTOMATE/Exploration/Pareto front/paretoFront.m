function [ PP, idxs] = paretoFront( p )

% DESCRIPTION
% Filters a set of points P according to Pareto dominance, i.e., points
% that are dominated (both weakly and strongly) are filtered.
%
% INPUT: 
% - P    : N-by-D matrix, where N is the number of points and D is the 
%          number of elements (objectives) of each point.
%
% OUTPUT:
% - P    : Pareto-filtered P
% - idxs : indices of the non-dominated solutions
%
% Example:
% p = [1 1 1; 2 0 1; 2 -1 1; 1, 1, 0];
% [f, idxs] = paretoFront(p)
%     f = [1 1 1; 2 0 1]
%     idxs = [1; 2]

PP               = p;
PP(PP(:,1)==0,:) = [];

PP = -PP;

[i, dim] = size(PP);
idxs     = [1 : i]';
while i >= 1
    old_size      = size(PP,1);
    indices       = sum( bsxfun( @ge, PP(i,:), PP ), 2 ) == dim;
    indices(i)    = false;
    PP(indices,:) = [];
    idxs(indices) = [];
    i             = i - 1 - (old_size - size(PP,1)) + sum(indices(i:end));
end  

PP = -PP;
PP = [PP idxs];

PP = sortrows(PP, 2, 'descend');

end
