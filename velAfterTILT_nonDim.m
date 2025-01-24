function [vAk1, vcAk1, aAm] = velAfterTILT_nonDim(aB0, vB0, n, m, k, mu)

aAm   = ( ( n*sqrt(1 - mu) - (1/2 + k)*(aB0)^(3/2) )/( m - k - 1/2 ) )^(2/3);
vcAk1 = sqrt( (1 - mu)/aAm );

vAk1 = sqrt( vB0^2 + (1 - mu)*( 1/aAm - 1/aB0 ) );

end