function [ra, rp] = aT2raRp_nonDim( a, T, mu )

vc = sqrt( (1 - mu )/a );

ra = a + sqrt( a^2 - (T - vc^2)^2/( 4*vc^2 ) );
rp = a - sqrt( a^2 - (T - vc^2)^2/( 4*vc^2 ) );

end