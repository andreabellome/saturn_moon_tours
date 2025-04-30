function v1 = eulerAxisAngle(v,n,theta)

% eulerAxisAngle.m - Euler axis and angle rotation.
%
% PROTOTYPE:
%   v1 = eulerAxisAngle(v, n, theta)
%
% DESCRIPTION:
%   Rotates a vector about an axis of a given angle (counterclockwise
%   according to the right-hand rule).
%   Note: If you want to rotate the coordinate system of a given angle
%   (counterclockwise according to the right-hand rule), use the minus in
%   front of the angle (i.e., -theta). (See reference).
%
% INPUT:
%   v[3]        Vector to be rotated.
%   n[3]        Axis of rotation.
%   theta       Angle of rotation [rad].
%
% OUTPUT:
%   v1[3,1]     Rotated vector.

v = v(:);
n = n/norm(n);

R      = zeros(3,3);
R(1,1) = cos(theta)+(1-cos(theta))*n(1)^2;
R(1,2) = (1-cos(theta))*n(1)*n(2)+sin(theta)*n(3);
R(1,3) = (1-cos(theta))*n(1)*n(3)-sin(theta)*n(2);

R(2,1) = (1-cos(theta))*n(1)*n(2)-sin(theta)*n(3);
R(2,2) = cos(theta)+(1-cos(theta))*n(2)^2;
R(2,3) = (1-cos(theta))*n(2)*n(3)+sin(theta)*n(1);

R(3,1) = (1-cos(theta))*n(1)*n(3)+sin(theta)*n(2);
R(3,2) = (1-cos(theta))*n(2)*n(3)-sin(theta)*n(1);
R(3,3) = cos(theta)+(1-cos(theta))*n(3)^2;

v1 = R'*v;

return
