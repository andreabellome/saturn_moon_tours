function [ a, T, lambda, f ] = phi_direct( x, y, xdot, ydot, mu )

r     = sqrt( ( x + mu )^2 + y^2 );
costh = (x + mu)/r;
sinth = y/r;
th    = atan2( sinth, costh );

R   = [ cos(th), -sin(th); sin(th), cos(th) ];
R_t = R';

vec = R_t*[ xdot; ydot ];
vr  = vec(1);
vth = vec(2) + r;

a = r/( 2 - (vr^2 + vth^2)*r/(1 - mu) );
h = vth * r;
e = sqrt( 1 - h^2/(1 - mu)/a );
cosf = (h^2/(r*(1-mu)) - 1)/e; 
sinf = (vr*h)/(e*(1 - mu));
f    = atan2( sinf, cosf );
f    = wrapTo2Pi(f); % --> true anomaly defined in [0, 2*pi]

E    = 2*atan( sqrt( ( 1 - e )/( 1 + e ) ) * tan( f/2 ) );

if a > 1
    fbar = 0;
elseif a < 1
    fbar = pi;
end

T     = ( 1 - mu )/a + 2*sqrt( a*(1 - e^2) );
Delta = a^( 3/2 )*( E - e*sin(E) - fbar )/(sqrt( 1 - mu ));

lambda = th + Delta - ( f - fbar );
lambda = wrapToPi( lambda );

end

