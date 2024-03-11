function C = jacobiConst(y,v,mu)

% DESCRIPTION
% This function computes Jacobi constant for a given state in CR3BP.
% 
% INPUT
% - y  : Nx3 position vector [adimensional]
% - v  : Nx3 velocity vector [adimensional]
% - mu : normalized gravitational constant of the CR3BP 
% 
% OUTPUT
% - C : Jacobi constant [adimensional]
%
% -------------------------------------------------------------------------

%the distances
r1 = sqrt((mu+y(:,1)).^2+(y(:,2)).^2+(y(:,3)).^2);
r2 = sqrt((y(:,1)-(1-mu)).^2+(y(:,2)).^2+(y(:,3)).^2);

%Compute the Jacobi Energy
C=-(v(:,1)^2 + v(:,2)^2+v(:,3)^2)/2 + 2*((y(:,1)^2 + y(:,2)^2)/2 + (1-mu)/r1 + mu/r2);

end

