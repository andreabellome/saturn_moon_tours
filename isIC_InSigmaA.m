function [x, y, xdot, ydot, isInSA] = isIC_InSigmaA( a, T, lambda, mu )

Rhill = ( mu/( 3*(1 - mu) ) )^( 1/3 );

epsilon = eps;
if a > 1
    fstar = -pi + epsilon;
elseif a < 1
    fstar = epsilon;
end

[ x, y, xdot, ydot ] = phi_inverse( a, T, lambda, fstar, mu );

R2 = sqrt( ( x + mu - 1 )^2 + y^2 );

if a ~= 1 && R2 > 5*Rhill
    isInSA = 1;
else
    isInSA = 0;
    x   = NaN;
    y    = NaN;
    xdot = NaN;
    ydot = NaN;
end

end