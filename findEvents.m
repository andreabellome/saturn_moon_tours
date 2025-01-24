function [indtosave, ff, aa, ffstar] = findEvents( yy1, mu )

indtosave = zeros( size(yy1,1),1 );
for indxs = 1:size(yy1,1)
    
    [ a, ~, ~, f ]     = phi_direct( yy1(indxs,1), yy1(indxs,2), yy1(indxs,4), yy1(indxs,5), mu );
    [fstar, R2, Rhill] = wrapEvents( yy1(indxs,:), mu );

    if R2 > 5*Rhill && abs( f - fstar ) < 0.5e-2
        indtosave(indxs) = indxs;
    end

    ff(indxs,1)     = f;
    aa(indxs,1)     = a;
    ffstar(indxs,:) = fstar;

end
indtosave(indtosave == 0) = [];

end