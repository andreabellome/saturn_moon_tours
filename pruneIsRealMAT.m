function [MAT, MATold2] = pruneIsRealMAT(MAT)

MATold2 = [];

if ~isempty(MAT)

    MATold2 = MAT;
    
    indtodel = zeros( size(MAT,1), 1 );
    for indm = 1:size(MAT,1)
        if ~isreal(MAT(indm,13))
            if abs(imag(MAT(indm,13))) >= 1e-4
                indtodel(indm) = indm;
            end
        end
    end
    indtodel(indtodel == 0) = [];
    MAT(indtodel,:)         = [];

end

end