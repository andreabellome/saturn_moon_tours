function [vinf1, alpha1, crank1, vinf2, alpha2, crank2, tofsc] = wrap_fullResTransf(N, M, vinf, crank, idmoon, idcentral)

% DESCRIPTION
% This function computes full-resonant transfers for a given planet/moon.
% The flyby body is assumed to be in circular-coplanar orbit.
%
% INPUT
% - N         : integer number of flyby body revolutions around the main body
% - M         : integer number of spacecraft revolutions around the main body
% - vinf      : infinity veloctity [km/s]
% - crank     : crank angle [rad]
% - idmoon    : ID of the flyby body (see also constants.m)
% - idcentral : ID of the central body (see also constants.m)
% 
% OUTPUT
% - vinf1  : infinity veloctity at the beginning [km/s]
% - alpha1 : pump angle at the beginning [rad]
% - crank1 : crank angle at the beginning [rad]
% - vinf2  : infinity veloctity at the end [km/s]
% - alpha2 : pump angle at the end [rad]
% - crank2 : crank angle at the end [rad]
% - tofsc  : time of flight of the transfer [sec]
% 
% -------------------------------------------------------------------------

% --> find the resonant transfer
RES = build_Resonances(N, M, vinf, idmoon, idcentral);

if RES(2) == 0
    vinf1  = NaN;
    alpha1 = NaN;
    crank1 = NaN;
    vinf2  = NaN;
    alpha2 = NaN;
    crank2 = NaN;
    tofsc  = NaN;

else
    
    vinf1  = vinf;
    vinf2  = vinf;
    alpha1 = RES(2);
    alpha2 = alpha1;
    crank1 = crank;
    crank2 = crank;
    tofsc  = RES(end)*86400;

end
    


end