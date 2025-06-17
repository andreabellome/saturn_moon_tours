function MAT = wrapGenerateMAT(ra0, rp0, lambdaTest, n, m, kk, strucNorm, idcentral, idMoon)

parfor indk = 1:length(kk)
    fprintf('%d out of %d \n', [indk, length(kk)])
    k               = kk(indk);
    STRUC(indk).MAT = wrapGenerateTILT( rp0, ra0, lambdaTest, n, m, k, strucNorm, idcentral, idMoon );
end
MAT = cell2mat({STRUC.MAT}');

end