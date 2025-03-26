function [MAT, MATold3] = pruneGoDownMAT(MAT)

MATold3 = [];
if ~isempty(MAT)

    MATold3 = MAT;
    
    ra0  = MAT( :, 7 );
    raB0 = MAT( :, 10 );
    
    indxs = find( raB0 >= ra0 );
    
    MAT(indxs,:) = [];

end

end