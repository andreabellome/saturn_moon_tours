function [ aa, TT, llambda, ff, ffstar, RR2, Rhill, rra, rrp ] = wrapParamEvolution( tt1, yy1, mu )

aa      = zeros( size(yy1,1),1 );
TT      = zeros( size(yy1,1),1 );
llambda = zeros( size(yy1,1),1 );
ff      = zeros( size(yy1,1),1 );
ffstar  = zeros( size(yy1,1),1 );
RR2     = zeros( size(yy1,1),1 );
rra     = zeros( size(yy1,1),1 );
rrp     = zeros( size(yy1,1),1 );

for indxs = 1:size(yy1,1)
    
    [ a, T, lambda, f ] = phi_direct( yy1(indxs,1), yy1(indxs,2), yy1(indxs,4), yy1(indxs,5), mu );
    [fstar, R2, Rhill]  = wrapEvents( yy1(indxs,:), mu );
    [ ra, rp ]          = aT2raRp_nonDim( a, T, mu );

    ff(indxs,1)      = f;
    aa(indxs,1)      = a;
    ffstar(indxs,:)  = fstar;
    TT(indxs,:)      = T;
    llambda(indxs,:) = lambda;
    RR2(indxs,:)     = R2;
    rra(indxs,:)     = ra;
    rrp(indxs,:)     = rp;

end

end