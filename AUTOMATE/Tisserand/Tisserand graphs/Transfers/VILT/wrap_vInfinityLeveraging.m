function [vinf1, alpha1, crank1, vinf2, alpha2, crank2, DV, tof1, tof2, tofsc] = ...
    wrap_vInfinityLeveraging(type, N, M, L, kei, vinf1, vinf2, idmoon, idcentral, remove81)

% DESCRIPTION
% This function computes v-infinity leveraging transfers for a given
% planet/moon. The flyby body is assumed to be in circular-coplanar orbit.
% This function is a wrapper of wrap_VILTS.m.
%
% INPUT
% - type : type of transfer depending upon the flyby body enounter
%          possible values:
%          88 --> outbound-outbound
%          81 --> outbound-inbound
%          18 --> inbound-outbound
%          11 --> inbound-inbound 
% - N         : integer number of flyby body revolutions around the main body
% - M         : integer number of spacecraft revolutions around the main body
% - L         : spacecraft revolution at which the DSM is performed
% - kei       : +1 for manoeuvre at APOAPSIS, -1 for manoeuvre at PERIAPSIS
% - vinf1     : infinity veloctity at the start [km/s]
% - vinf2     : infinity veloctity at the end [km/s]
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
% - DV     : manoeuvre magnitude [km/s]
% - tof1   : time of flight until the manoeuvre [sec]
% - tof2   : time of flight from the manoeuvre to the next flyby [sec]
% - tofsc  : time of flight of the transfer [sec]
% 
% -------------------------------------------------------------------------

if nargin == 9
    remove81 = 0;
elseif nargin == 10
    if isempty(remove81)
        remove81 = 0;
    end
end

% --> remove one revolution in cases like [ type kei N M L ] = [ 88/81 -1 N 1 0 ]
if M == 1 && L == 0 && ( type == 88 || type == 81 ) && kei == -1
    M = M - 1;
end

% --> this to be compatible with MIDAS
if remove81 ~= 0
    if type == 81
        N = N-1;
        M = M-1;
    end
end

% --> solve the VILT
S = [ type kei N M L ];
[~, DV, tofsc, node, alpha1, ~, ~, ~, ~, ~, ~, ~, tof1, tof2] = ...
    wrap_VILT(S, vinf1, vinf2, idmoon, idcentral);

if isnan(tofsc)

    vinf1  = NaN;
    alpha1 = NaN;
    crank1 = NaN;
    vinf2  = NaN;
    alpha2 = NaN;
    crank2 = NaN;
    tof1   = NaN;
    tof2   = NaN;

else

    % --> extract the output
    alpha2           = node(1);
    [crank1, crank2] = type2Crank(type);

end

end
