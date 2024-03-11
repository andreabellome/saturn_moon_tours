function [df] = findRpfromJacobiConst( rp, ra, JacCons )

% DESCRIPTION
% This function computes the residual between a target Jacobi constant and
% one specified through periapsis and apoapsis.
%
% INPUT
% - rp      : periapsis [adimensional]
% - ra      : apoapsis [adimensional]
% - JacCons : Jacobi constant [adimensional]
% 
% OUTPUT
% - df : residual between JacCons and the one specified with rp and ra
% 
% -------------------------------------------------------------------------

df = JacCons - ( 2./( ra + rp ) + 2.*sqrt( ( 2.*ra.*rp )./( ra + rp ) ) );

end