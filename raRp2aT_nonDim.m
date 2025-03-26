function [ a, T ] = raRp2aT_nonDim( ra, rp, mu )

a = 0.5*( ra + rp );
T = 2*(1 - mu)/( ra + rp ) + 2*sqrt( (2*ra*rp*(1 - mu))/(ra + rp) );

end