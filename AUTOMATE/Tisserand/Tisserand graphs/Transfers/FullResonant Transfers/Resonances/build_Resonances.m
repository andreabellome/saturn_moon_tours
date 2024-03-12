function [RES] = build_Resonances(N, M, vinf, pl, idcentral)

% DESCRIPTION : 
% this function finds the Tisserand node that corresponds to a given
% resonance w.r.t. the planet.
%
% INPUT : 
% N    : planet revolutions
% M    : spacecraft revolutions
% vinf : infinity velocity (km/s)
% pl        : ID of the flyby body (see constants.m)
% idcentral : ID of the central body (see constants.m)
%
% OUTPUT :
% RES : matrix containing the following information :
%       - RES(:,1) : planet
%       - RES(:,2) : alpha angle of the resonant point on Tisserand (rad)
%       - RES(:,3) : inf. vel. of the resonant point on Tisserand (km/s)
%       - RES(:,4) : N (planet revolutions)
%       - RES(:,5) : M (spacecraft revolutions)
%       - RES(:,5) : time of flight [days]
%
% -------------------------------------------------------------------------

if nargin == 4
    idcentral = 1;
end

% --> constants
[mu, ~, rPL] = constants(idcentral, pl);
vPL          = sqrt(mu/rPL);                % --> planet orbital velocity (km/s)
tPL          = 2*pi*sqrt(rPL^3/mu);         % --> planet orbital period (s)

Tsc = N/M*tPL;                       % --> find the N:M resonance
asc = (mu*(Tsc/(2*pi))^2)^(1/3)/rPL; % --> SC semi-major axis (non-dimensional)

% --> compute the corresponding alpha
alpha = acos(vPL/(2*vinf)*(1 - (vinf/vPL)^2 - 1/asc));
if isreal(alpha)
    alpha = wrapToPi(alpha);
else % --> no resonance available for the given vinf
    pl    = 0;
    alpha = 0;
    vinf  = 0;
    N     = 0;
    M     = 0;
    Tsc   = 0;
end

% --> save the results
RES(:,1) = pl;
RES(:,2) = alpha;
RES(:,3) = vinf;
RES(:,4) = N;
RES(:,5) = M;
RES(:,6) = N*tPL/86400;

% --> eliminate rows all equal to zero
RES = RES(~all(RES == 0, 2),:);

end