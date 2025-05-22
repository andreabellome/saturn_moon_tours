function [df] = findRpfromJacobiConst( rp, ra, JacCons, mu )

% DESCRIPTION
% This function computes the residual between a target Jacobi constant and
% one specified through periapsis and apoapsis.
%
% INPUT
% - rp      : periapsis [adimensional]
% - ra      : apoapsis [adimensional]
% - JacCons : Jacobi constant [adimensional]
% - mu      : gravitational parameter of the CRTBP system [adimensional] -
%             default is zero
% 
% OUTPUT
% - df : residual between JacCons and the one specified with rp and ra
% 
% -------------------------------------------------------------------------

if nargin == 3
    mu = 0;
end

df = JacCons - ( 2.*(1 - mu)./( ra + rp ) + 2.*sqrt( ( 2.*(1 - mu).*ra.*rp )./( ra + rp ) ) );

end