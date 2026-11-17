function indPar=paretoQS(sln)
%PARETOQS   Find Pareto optimal front (fast version, same behaviour as original)
%   indPar=paretoQS(sln) returns row indices to the pareto optimal set of
%   designs, so that for each point x_i in the front no point x_j performs
%   better (<) in all objective functions. By definition, duplicates do not
%   dominate each other. Note that all objectives are treated as
%   minimization, so maximize objectives y_max should be passed as
%                       y_min = -y_max;
%                             or
%                       y_min = 1/y_max;
%
%   For 2 objectives an exact O(n log n) sweep is used. For more than 2
%   objectives the original modified-quicksort algorithm is used.
%   Output is identical to the original implementation: a row vector of
%   indices in ascending order, with points removed only if strictly
%   dominated in ALL objectives (ties and duplicates are kept).
%
%   Inputs: sln - The solution space to identify pareto optimal designs in,
%                 as a matrix of the shape nPt x nOf
%                 (number of points x number of objectives)
%
%   Outputs: indPar - Indices of the pareto optimal points of the given
%                     input space
%
%   Example:
%       nPt=1000;
%       x=linspace(1/5,5,nPt).';
%       paretoQS([x+0.75.*randn(nPt,1),1./x+0.75.*randn(nPt,1)])

%Assert correct shape
assert(ismatrix(sln),'Input must be an nPt x nOF matrix');

%Find size of sln space
[nPt,nOF]=size(sln);

%Special cases (identical to original)
if isempty(sln)
    indPar=sln;
    return
elseif nPt==1
    indPar=1;
    return
elseif nOF==1
    [~,indPar]=min(sln);
    return
end

if nOF==2
    indPar=paretoSweep2D(sln);
else
    indPar=paretoQS_original(sln,nPt);
end

end

%% ------------------------------------------------------------------------
function indPar=paretoSweep2D(sln)
% Point j is removed iff there exists i with f1_i < f1_j AND f2_i < f2_j.
% Points with NaN in any objective can neither dominate nor be dominated
% (all comparisons with NaN are false), exactly as in the original.

nPt  = size(sln,1);
f1   = sln(:,1);
f2   = sln(:,2);
keep = true(nPt,1);

valid = ~isnan(f1) & ~isnan(f2);
iv    = find(valid);

if numel(iv) > 1
    % --> sort valid points by f1 ascending
    [f1s, ord] = sort(f1(iv));
    f2s        = f2(iv(ord));
    n          = numel(f1s);

    % --> groups of equal f1 (strict < means equal f1 cannot dominate)
    newGroup   = [true; diff(f1s) ~= 0];
    groupStart = find(newGroup);
    groupEnd   = [groupStart(2:end)-1; n];

    % --> running min of f2 over all points with strictly smaller f1
    minPrev    = Inf;
    domSorted  = false(n,1);
    for k = 1:numel(groupStart)
        idx = groupStart(k):groupEnd(k);
        domSorted(idx) = f2s(idx) > minPrev;   % --> strictly dominated
        minPrev = min(minPrev, min(f2s(idx)));
    end

    keep(iv(ord(domSorted))) = false;
end

indPar = find(keep).';   % --> row vector, ascending order (as original)

end

%% ------------------------------------------------------------------------
function indPar=paretoQS_original(sln,nPt)
% Original modified-quicksort algorithm (unchanged), used for nOF > 2

indPar=1:nPt;
nPar=nPt;
nnImp=0;
exitThresh=2;
while true
    indPar(all(sln(indPar,:) > sln(indPar(randi([1 nPar],1)),:),2))=[];
    nParPrev=nPar;
    nPar=length(indPar);
    if (nPar==nParPrev)
        nnImp=nnImp+1;
    else
        nnImp=0;
    end
    if nnImp>=exitThresh
        break
    end
end
for i=nPar:-1:1
    if any(all(sln(indPar,:) < sln(indPar(i),:),2))
        indPar(i)=[];
    end
end

end