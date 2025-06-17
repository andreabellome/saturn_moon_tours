function [ra0, rp0, raB0, rpB0, raM, rpM, dv] = extractInfo(MAT2, indmat, strucNorm)

ra0    = MAT2(indmat,7);
rp0    = MAT2(indmat,8);
raB0   = MAT2(indmat,10);
rpB0   = MAT2(indmat,11);
raM    = MAT2(indmat,12);
rpM    = MAT2(indmat,13);
dv     = MAT2(indmat,end-1)*strucNorm.normDist/strucNorm.normTime;

end