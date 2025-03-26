function [ x, y, xdot, ydot ] = phi_inverse( a, T, lambda, fstar, mu )

f = fstar;

if a > 1
    fbar = 0;
elseif a < 1
    fbar = pi;
end

h = ( T - ( 1 - mu )/a )/2;
e = sqrt( 1 - h^2/( a * ( 1 - mu ) ) );
E = 2*atan( sqrt( ( 1 - e )/( 1 + e ) ) * tan( f/2 ) );

r = ( h^2 )/( 1 + e*cos(f) );

Delta = a^( 3/2 )*( E - e*sin(E) - fbar )/(sqrt( 1 - mu ));
th    = lambda - Delta + ( f - fbar );

vr  = ( (1 - mu)*e*sin(f) )/( h );
vth = h/r;

x    = r*cos(th) - mu;
y    = r*sin(th);
xdot = vr*cos(th) - (vth - r)*sin(th);
ydot = vr*sin(th) + (vth - r)*cos(th);

end