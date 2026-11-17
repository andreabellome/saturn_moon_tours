function [PP, idxs] = paretoFront(p)
% DESCRIPTION
% Filters a set of points P according to Pareto dominance (minimization),
% i.e., points that are dominated (both weakly and strongly) are filtered.
% Among duplicates, the one with the highest index is kept. Rows containing
% NaN are always kept (same behaviour as the original O(N^2) version).
%
% INPUT:
% - p    : N-by-D matrix, N points, D objectives.
%
% OUTPUT:
% - PP   : Pareto-filtered points, with the index appended as last column,
%          sorted by column 2 in descending order
% - idxs : indices (ascending) of the non-dominated solutions, referred to
%          p after removal of rows with p(:,1) == 0
%
% Example:
% p = [1 1 1; 2 0 1; 2 -1 1; 1, 1, 0];
% [f, idxs] = paretoFront(p)

P = p(p(:,1) ~= 0, :);
[n, dim] = size(P);

if n == 0
    PP   = zeros(0, dim + 1);
    idxs = zeros(0, 1);
    return
end

nanRows = any(isnan(P), 2);
cand    = find(~nanRows);

if isempty(cand)
    sel = zeros(0, 1);
elseif dim == 1
    v   = P(cand);
    sel = cand(find(v == min(v), 1, 'last'));
elseif dim == 2
    sel = cand(front2D(P(cand, :)));
else
    sel = cand(frontND(P(cand, :)));
end

idxs = sort([sel(:); find(nanRows)]);
PP   = [P(idxs, :) idxs];
PP   = sortrows(PP, 2, 'descend');
end

% -------------------------------------------------------------------------
function sel = front2D(P)
% O(N log N) sweep for two objectives (minimization).
% Ties in both objectives are ordered by descending index, so the highest
% index among duplicates comes first and survives.
n        = size(P, 1);
[~, ord] = sortrows([P (1:n)'], [1 2 -3]);
f2       = P(ord, 2);
runMin   = cummin(f2);
keep     = [true; f2(2:end) < runMin(1:end-1)];
sel      = ord(keep);
end

% -------------------------------------------------------------------------
function sel = frontND(P)
% General D: after a lexicographic sort, a point can only be weakly
% dominated by points that come before it.
[n, dim] = size(P);
[~, ord] = sortrows([P (1:n)'], [1:dim, -(dim + 1)]);
Q        = P(ord, :);
keep     = true(n, 1);
for k = 1:n
    if ~keep(k), continue; end
    r = (k+1:n)';
    r = r(keep(r));
    if isempty(r), break; end
    dom          = all(bsxfun(@ge, Q(r,:), Q(k,:)), 2);
    keep(r(dom)) = false;
end
sel = ord(keep);
end