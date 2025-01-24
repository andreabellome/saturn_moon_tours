function [MAT, dvsDim, MATold] = pruneMAT(MAT, dvTol, strucNorm)

MATold = [];
dvsDim = [];

if ~isempty(MAT)

    MATold = MAT;
    
    dvsDim = MAT(:,end-1)*strucNorm.normDist/strucNorm.normTime;
    indxs  = find( dvsDim > dvTol );
    
    MAT(indxs,:) = [];
    dvsDim       = MAT(:,end-1)*strucNorm.normDist/strucNorm.normTime;

end

end