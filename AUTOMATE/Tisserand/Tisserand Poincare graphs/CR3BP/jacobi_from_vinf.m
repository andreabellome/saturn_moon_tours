function JJ = jacobi_from_vinf( vinf, mu )

% DESCRIPTION 
% This function computes approximate Jacobi integral for adimensional
% infinity velocity.
% 
% INPUT
% - vinf       : list of infinity velocity magnitudes [adimensional]
% - mu         : normalized gravitational constant of the CR3BP 
%
% OUTPUT
% - JJ : Jacobi integral for the given infinity velocity [adimensional]
% 
% -------------------------------------------------------------------------

if nargin == 1
    mu = 0;
end

JJ = 3 - 2*mu - vinf.^2;

end