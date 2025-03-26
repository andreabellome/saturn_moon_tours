function [fstar, R2, Rhill] = wrapEvents( xvalues, mu )

x    = xvalues(1);
y    = xvalues(2);
xdot = xvalues(4);
ydot = xvalues(5);

Rhill   = ( mu/( 3*(1 - mu) ) )^( 1/3 );

r2      = [x - (1-mu); y];
R2      = norm(r2);

a = phi_direct( x, y, xdot, ydot, mu );

epsilon = eps;
if a > 1
    fstar = pi - epsilon;
elseif a < 1
    fstar = 2*pi - epsilon;
end

end