function [delta, vpip, eip, Eip, aip] = Vinf2Hyperbola(vinf, rpip, mu)

% DESCRIPTION :
% this function allows to calculate the parameters of a hyperbola given the
% velocity at infinity and the radius at the hyperbolic pericenter.
% 
% INPUT : 
% - vinf : infinity velocity (km/s)
% - rpip : hyperbolic pericentre (km)
% - mu   : gravitational parameter of the flyby body (km3/s2)
% 
% OUTPUT :
% - delta : hyperbolic deflection (rad)
% - vpip  : hyperbolic pericentre velocity (km/s)
% - eip   : hyperbolic eccentricity
% - Eip   : hyperbolic energy (km2/s2)
% - aip   : hyperbolic semi-major axis (a<0) (km)
%
% -------------------------------------------------------------------------

Eip   = 0.5*vinf.^2; 
aip   = -mu./(2.*Eip);
vpip  = sqrt(2.*(Eip + mu./rpip));
eip   = 1 + rpip.*vinf.^2./mu;
delta = 2*asin(1./eip);
delta = wrapToPi(delta);

end