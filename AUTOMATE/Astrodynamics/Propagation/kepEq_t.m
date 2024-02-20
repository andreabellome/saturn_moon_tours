function t = kepEq_t(f, a, e, mu, f0, t0)

% kepEq_t.m - Keplerian equation. It finds the time corresponding to a
%   certain true anomaly.
%
% PROTOTYPE:
%   t = kepEq_t(f, a, e, mu, f0, t0)
%
% DESCRIPTION:
%   It finds the time t corresponding to an angular position f. Elliptic
%   orbits (e < 1).
%
% INPUT:
% 	f[1]    True anomaly [rad].
%   a[1]    Semi-major axis [L].
%   e[1]    Eccentricity.
%   mu[1]   Planetary constant (mu = mass * G) [L^3/T^2].
%   f0[1]   Fixed true anomaly [rad].
%   t0[1]   Time corresponding to f0 [T].
%           > Optional: Default value = 0.
%
% OUTPUT:
% 	t[1]    Time corresponding to f [T] between [-Inf, Inf].
%
% CALLED FUNCTIONS:
%   (none)
%
% FUTURE DEVELOPMENT:
%   Extension to parabolic and hyperbolic orbits.
%
% ORIGINAL VERSION:
%   Camilla Colombo, 20/02/2006, MATLAB, tl.m
%
% AUTHOR:
%   Camilla Colombo, Nicolas Croisard, 20/11/2007, MATLAB, kepEq_t.m
%
% PREVIOUS VERSION:
%   Camilla Colombo, 20/11/2007, MATLAB, tl_inf.m
%   	- Time corresponding to f [T] given in the range [-Inf, Inf].
%   Camilla Colombo, Nicolas Croisard, 20/11/2007, MATLAB, tl3.m
%       - Header and function name in accordance with guidlines.
%
% CHANGELOG:
%   02/12/2008, Matteo Ceriotti: Optional argument t0.
%   02/12/2008, REVISION: Matteo Ceriotti
%   30/12/2009, Camilla Colombo: Header and function name in accordance
%       with guidlines.
%
% -------------------------------------------------------------------------

% Eccentricity check
if e >= 1
    t = [];
    return
end

% Optional arguments
if nargin < 6
    t0 = 0;
end

% Transform f to have f in ]-pi, pi]

k = fix(f/(2*pi));
f = f-k*2*pi;
if f > pi
    f = f-2*pi;
    k = k+1;
elseif f <= -pi
    f = f+2*pi;
    k = k-1;
end

% Transform f0 to have f0 in ]-pi, pi]

k0 = fix(f0/(2*pi));
f0 = f0-k0*2*pi;
if f0 > pi
    f0 = f0-2*pi;
    k0 = k0+1;
elseif f0 <= -pi
    f0 = f0+2*pi;
    k0 = k0-1;
end

E = 2*atan(sqrt((1-e)/(1+e))*tan(f/2));
E0 = 2*atan(sqrt((1-e)/(1+e))*tan(f0/2));

t = sqrt(a^3/mu)*(E-E0-e*(sin(E)-sin(E0)) + 2*pi*(k-k0)) + t0;

return