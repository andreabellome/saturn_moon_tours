function [kep] = car2kep(in,mu)

% INPUT:
%	in[6]       State vector in cartesian coordinates (position [L],
%               velocity [L/T]).
%   mu          Planetary gravity constant [L^3/(M*T^2)].
%
% OUTPUT:
%   kep[1,6]    Vector of Keplerian elements: kep = [a, e, i, Om, om, th],
%               where theta is the true anomaly. a in [L],
%                   0 <= i  <= pi   [rad]
%                   0 <= Om <  2*pi [rad]
%                   0 <= om <  2*pi [rad]
%                   0 <= th <  2*pi [rad].
%   p           Parameter [L].
%   E           Eccentric anomaly, hyperbolic anomaly or parabolic anomaly
%               (for definitions see Vallado pag. 49).
%   M           Mean anomaly [rad].
%   dt          Time from the pericentre passage [T].
%

% Threshold on eccentricity for considering the orbit to be circular
%   Value determined comparing the relative error on state and position
%   between using the circular case and the elliptic case. With this elimit
%   the relative error on position and velocity is always less then 1e-7.
elimit = 0.00000001;

r = in(1:3);
v = in(4:6);

nr = sqrt(r(1)^2+r(2)^2+r(3)^2);    % Norm of r

% Angular momentum vector: h = cross(r,v) 
h  = [r(2)*v(3)-r(3)*v(2),r(3)*v(1)-r(1)*v(3),r(1)*v(2)-r(2)*v(1)]; 
nh = sqrt(h(1)^2+h(2)^2+h(3)^2);    % Norm of h

% Inclination
i = acos(h(3)/nh);

% Line of nodes vector
if i ~= 0 && i ~= pi    % Orbit is out of xy plane
    
    % n = cross([0 0 1],h);
    % Normalisation of nv to 1: n = n/norm(n)
    %                           n = n/sqrt(n(1)^2+n(2)^2+n(3)^2);
    n = [-h(2),h(1),0]/sqrt(h(1)^2+h(2)^2);

else                    % Orbit is in xy plane
    
    % Arbitrary choice of n
    n = [1,0,0]; 
%     warning('spaceToolbox:car2kep:planarOrbit','Planar orbit. Arbitrary choice of Omega = 0.');
end

% Argument of the ascending node
Om = acos(n(1));
if n(2) < 0
    Om = mod(2*pi-Om,2*pi);
end

% Parameter
p = nh^2/mu;

% Eccentricity vector: ev = 1/mu*cross(v,h) - r/nr
% ev  = 1/mu*[v(2)*h(3)-v(3)*h(2),v(3)*h(1)-v(1)*h(3),v(1)*h(2)-v(2)*h(1)] - r/nr; 
ev = 1/mu*cross(v,h) - r/nr;
e = sqrt(ev(1)^2+ev(2)^2+ev(3)^2);    % Eccentricity (norm of eccentricity vector)

% Argument of the pericentre
if e<elimit     % Circular orbit
    
    % Arbitrary eccentricity vector
    ev = n;
    ne = 1; % ne = norm(ev)

else                    % Non circular orbit
    ne = e;
end         

om = acos(min(max((n(1)*ev(1) + n(2)*ev(2) + n(3)*ev(3)) / ne,-1),1)); % acos(dot(n,ev)/ne)

if dot(h,cross(n,ev)) < 0 
    om = mod(2*pi-om,2*pi);
end

% Semi-major axis
a = p/(1-e^2);

% True anomaly: acos(dot(ev,r)/ne/nr);
th = acos(min(max((ev(1)*r(1)+ev(2)*r(2)+ev(3)*r(3))/ne/nr,-1),1));

if dot(h,cross(ev,r)) < 0
    % the condition dot(r,cross(h,ev)) < 0 works in the same way
    th = mod(2*pi-th,2*pi);
end

kep = [a,e,i,Om,om,th];

end