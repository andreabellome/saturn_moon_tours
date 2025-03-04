function [dx] = f_CR3BP(X,pars)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function contains the equations of motion of the Circular 
% Restricted 3 Body Problem.
%
%% INPUTS
% - X:       6x1 Non-dimensional state vector 
%
% - pars:    Structure containing the problem parameters
%
%% OUTPUTS
% - dx:      6x1 Non-dimensional acceleration vector 


% Author: José Carlos García
% Last revision: 25/07/2022

%% DEFINNING SEVERAL INPUTS %%
mu      = pars.mu;

% Spacecraft Relative Position Vector wrt Primary
r1      = [X(1) + mu; X(2); X(3)];
R1      = norm(r1);


% Spacecraft Relative Position Vector wrt Secondary
r2      = [X(1) - (1-mu); X(2); X(3)];
R2      = norm(r2);

% Equations of Motion
dx = zeros(6,1);          % States 

dx(1)   = X(4);
dx(2)   = X(5);
dx(3)   = X(6);
dx(4)   = X(1) + 2*X(5) - (1-mu)*(X(1) + mu)/R1^3 - mu*(X(1) + mu - 1)/R2^3;
dx(5)   = X(2) - 2*X(4) - (1-mu)*X(2)/R1^3 - mu*X(2)/R2^3;
dx(6)   = -(1-mu)*X(3)/R1^3 - mu*X(3)/R2^3;

end
