function [PARETO_FRONT, PARETO_UNIQUE] = paretoFront_MODP( COSTmatrix )

% DESCRIPTION
% Wrapper for computing Pareto front in MODP.
% 
% INPUT
% - COSTmatrix : N-by-D matrix, where N is the number of points and D is the 
%               number of elements (objectives) of each point.
% 
% OUTPUT
% - PARETO_FRONT : matrix with Pareto front as follows:
%                  - PARETO_FRONT(:,1:N) : objectives on the front
%                  - PARETO_FRONT(:,end) : rows' IDs of the point in
%                  COSTmatrix
% - PARETO_UNIQUE : same as PARETO_FRONT but with unique points w.r.t. the
%                   first objective
% 
% -------------------------------------------------------------------------

nobj       = size(COSTmatrix,2); % --> number of objectives

idxs       = [1:1:size(COSTmatrix,1)]';
COSTmatrix = [COSTmatrix idxs];
COSTmatrix = sortrows(COSTmatrix, [1:1:nobj]);

[~, uniqueIndeces] = unique(COSTmatrix(:, 1), 'first');
COSTmatrix         = COSTmatrix(uniqueIndeces,:);
PARETO_UNIQUE      = COSTmatrix;

if size(PARETO_UNIQUE,1) == 1
    PARETO_FRONT = PARETO_UNIQUE;
else
    [ PARETO_FRONT_2, idxs] = paretoFront( COSTmatrix(:,1:nobj) );
    PARETO_FRONT            = [PARETO_FRONT_2(:,1:nobj) COSTmatrix(idxs,nobj+1)];
end

end