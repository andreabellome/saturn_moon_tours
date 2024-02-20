function indPar=paretoQS(sln)
%PARETOQS   Find Pareto optimal front using modified quicksort
%   indPar=paretoQS(sln) returns row indices to the pareto optimal set of 
%   designs, so that for each point x_i in the front no point x_j performs 
%   better (<) in all objective functions. By definition, duplicates do not
%   dominate each other. Note that all objectives are treated as 
%   minimization, so maximize objectives y_max should be passed as
%                       y_min = -y_max; 
%                             or
%                       y_min = 1/y_max;
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
%Asset correct shape
assert(ismatrix(sln),'Input must be an nPt x nOF matrix');
%Find size of sln space
[nPt,nOF]=size(sln);
%Special cases
if isempty(sln)
    %Either/Both dimensions empty, return empty of same 'shape'
    indPar=sln;
    return
elseif nPt==1
    %Only one point must be pareto optimal
    indPar=1;
    return
elseif nOF==1
    %Only one OF, minimum must be the pareto optimal
    [~,indPar]=min(sln);
    return
end
%Init the pareto set to full
indPar=1:nPt;
nPar=nPt;
%Decide allowable number of no-improvements at expected O(n lg n) till fallback to brute force
nnImp=0;
exitThresh=2;
%Begin iteration
while true
    %Chose random pivot (quicksort inspired), remove all that are domainated by pivot
    indPar(all(sln(indPar,:) > sln(indPar(randi([1 nPar],1)),:),2))=[];
    
    %Update length
    nParPrev=nPar;
    nPar=length(indPar);
    
    %Keep track of improvement
    if (nPar==nParPrev)
        %No improvement
        nnImp=nnImp+1;
    else
        %Improvement made
        nnImp=0;
    end
    
    %Consider exit
    if nnImp>=exitThresh
        break
    end
end
%We now have a nearly-pareto set, perform final sweep to remove invalid entries
for i=nPar:-1:1 %go backwards so we don't worry about swapping
    if any(all(sln(indPar,:) < sln(indPar(i),:),2))
        indPar(i)=[];
    end
end

end