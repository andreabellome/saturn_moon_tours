function out = kep2car(kep,mu,p)
% DESCRIPTION:
%   Converts from Keplerian orbital elements to Cartesian position and
%   velocity. All units to be consistent each other. Angles in radians.
%   Note: In the case of hyperbola, theta must be such that the point is on
%       the physical leg of the hyperbola (the leg around the attracting
%       mass).
%  
% INPUT:
%	kep[6]      Vector of keplerian elements: [a e i Om om theta], where
%               theta is the true anomaly. a in [L], angles in [rad].
%               In case of hyperbola (e>1), it must be: kep(1)<0.
%   mu          Planetary gravity constant [L^3/(M*T^2)].
%   p           Semi-latus rectum [L]. Only used for parabola case.
%
% OUTPUT:
% 	out[1,6]    State vector in cartesian coordinates (position [L],
%               velocity [L/T]).

%elimitpar = 0.99999999999999999;
% ---> CL: 07/10/2010, Matteo Ceriotti: changed way of expressing elimitpar
elimitpar = 1e-17;

e   = kep(2);
i   = kep(3);
Om  = kep(4);
om  = kep(5);
tho = kep(6);

% Rotation matrix
R = zeros(3,3);
R(1,1) = cos(om)*cos(Om)-sin(om)*cos(i)*sin(Om);
R(2,1) = cos(om)*sin(Om)+sin(om)*cos(i)*cos(Om);
R(3,1) = sin(om)*sin(i);

R(1,2) = -sin(om)*cos(Om)-cos(om)*cos(i)*sin(Om);
R(2,2) = -sin(om)*sin(Om)+cos(om)*cos(i)*cos(Om);
R(3,2) = cos(om)*sin(i);

R(1,3) = sin(i)*sin(Om);
R(2,3) = -sin(i)*cos(Om);
R(3,3) = cos(i);

% In plane Parameters
% ---> CL: 07/10/2010, Matteo Ceriotti: added condition e <= (1+elimitpar)
if e >= (1-elimitpar) && e <= (1+elimitpar) % Parabola
    if nargin < 3
        error('Parabolic case: the semi-latus rectum needs to be provided')
    end
else
    % ---> CL: 07/10/2010, Matteo Ceriotti: Removed if nargin < 3. p shall
    % be computed even if it is given, if it is not a parabola.
    p = kep(1)*(1-e^2);     % Value of p in the input is not considered and overwritten with this one
end

r = p/(1+e*cos(tho));
xp = r*cos(tho);
yp = r*sin(tho);
wom_dot = sqrt(mu*p)/r^2;
r_dot   = sqrt(mu/p)*e*sin(tho);
vxp = r_dot*cos(tho)-r*sin(tho)*wom_dot;
vyp = r_dot*sin(tho)+r*cos(tho)*wom_dot;

% 3D cartesian vector
out = zeros(1,6);
out(1) = R(1,1)*xp+R(1,2)*yp;
out(2) = R(2,1)*xp+R(2,2)*yp;
out(3) = R(3,1)*xp+R(3,2)*yp;

out(4) = R(1,1)*vxp+R(1,2)*vyp;
out(5) = R(2,1)*vxp+R(2,2)*vyp;
out(6) = R(3,1)*vxp+R(3,2)*vyp;

end
