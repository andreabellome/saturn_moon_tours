function [vinf1, alpha1, crank1, vinf2, alpha2, crank2, dv, tof1, tof2, tof] = ...
    wrapper_all_transfers( S, vinf1, vinf2, id_moon, id_central, remove81 )

% This function should serve as wrapper for the following transfers:
% - VILT
% - full-resonant
% - pseudo-resonant
% Specifically, the selection of such transfers is automatically given by:
%
%   - if type is OO or II and vinf1=vinf2, then one has a full-resonant
%       transfer
%   - if type is IO or OI and vinf1=vinf2, then one has a pseudo-resonant
%       transfer
%   - if type is OO, II, IO or OI and vinf1~=vinf2, then one has a VILT
%
% Important: this function works with circular-coplanar orbits.
%
% INPUT:
% - S         : 1x5 vector containing variables defining the VILT
%             S(1) = TYPE --> OO/OI/IO/II (88, 81, 18, 11)
%             S(2) = kei  --> +1 for EXTERNAL, -1 for INTERNAL
%             S(3) = N    --> number of moon revolutions
%             S(4) = M    --> number of spacecraft revolutions
%             S(5) = L    --> number of spacecraft revolution where the DSM
%             occurs 
% - vinf1     : initial infinity velocity w.r.t. the moon [km/s]
% - vinf2     : final infinity velocity w.r.t. the moon [km/s]
% - id_moon   : flyby body ID, depending upon the central body ID (see
%             constants.m)
% - idcentral : central body ID (see constants.m)
%
% OUTPUT:
% - vinf1     : initial infinity velocity w.r.t. the moon [km/s]
% - alpha1    : initial pump angle w.r.t. the moon[rad]
% - crank1    : initial crank angle w.r.t. the moon[rad]
% - vinf2     : final infinity velocity w.r.t. the moon [km/s]
% - alpha2    : final pump angle w.r.t. the moon [rad]
% - crank2    : final crank angle w.r.t. the moon [rad]
% - dv        : cost of the transfer [km/s]
% - tof1      : time of flight until the manoeuvre [s]
% - tof2      : time of flight from the manoeuvre until next flyby [s]
% - tof       : overall time of flight of the transfer [s]
% 
% -------------------------------------------------------------------------

if nargin == 5
    remove81 = 0;
elseif nargin == 6
    if isempty(remove81)
        remove81 = 0;
    end
end

type = S(1);
kei  = S(2);
N    = S(3);
M    = S(4);
L    = S(5);
if abs( vinf1 - vinf2 ) <= 1e-7 && ( type == 88 || type == 11 )
    % --> this is a full-resonant transfer

    crank1  = type2Crank(type);
    [vinf1, alpha1, crank1, vinf2, alpha2, crank2, tof] = ...
        wrap_fullResTransf(N, M, vinf1, crank1, id_moon, id_central);  
    tof1    = 0;
    tof2    = tof;
    dv      = 0;

else
    % --> this is either a VILT or a pseudo-resonant transfer

    [vinf1, alpha1, crank1, vinf2, alpha2, crank2, dv, tof1, tof2] = ...
         wrap_vInfinityLeveraging(type, N, M, L, kei, vinf1, vinf2, id_moon, id_central, remove81);
    tof = tof1 + tof2;

end

end
