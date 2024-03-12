function [vinf1, alpha1, crank1, vinf2, alpha2, crank2, tofsc] = wrap_pseudoResTransf( type, N, M, vinf, idmoon, idcentral, remove81 )

% DESCRIPTION
% This function computes pseudo-resonant transfers for a given planet/moon.
% The flyby body is assumed to be in circular-coplanar orbit.
%
% INPUT
% - type : type of transfer depending upon the flyby body enounter
%          possible values:
%          18 --> inbound-outbound
%          11 --> inbound-inbound 
% - N         : integer number of flyby body revolutions around the main body
% - M         : integer number of spacecraft revolutions around the main body
% - vinf      : infinity veloctity [km/s]
% - idmoon    : ID of the flyby body (see also constants.m)
% - idcentral : ID of the central body (see also constants.m)
% - remove81  : optional input to remove the +1 on OI transfers. Default is
%               0, so +1 is considered.
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

% --> check the type of transfer
if type == 11 || type == 88
    warning('You selected a full-resonant transfer based on the type input.');
end

if nargin == 6
    remove81 = 0;
elseif nargin == 7
    if isempty(remove81)
        remove81 = 0;
    end
end
if remove81 ~= 0
    if type == 81
        N = N-1;
        M = M-1;
    end
end

% --> solve the pseudo-resonant transfer
S                           = [ type +1 N M 0 ];
[~, ~, tofsc, node, alpha1] = wrap_VILT(S, vinf, vinf, idmoon, idcentral);

if isnan(tofsc)

    vinf1  = NaN;
    alpha1 = NaN;
    crank1 = NaN;
    vinf2  = NaN;
    alpha2 = NaN;
    crank2 = NaN;

else

    % --> extract the output
    vinf1  = vinf;
    vinf2  = vinf;
    alpha2 = node(1);
    [crank1, crank2] = type2Crank(type);

end

end
