function [vinfCAR, rr, vv, vvga] = vinfAlphaCrank_to_VinfCART(vinf, alpha, k, t, idpl, idcentral,customEphemerides)

% DESCRIPTION
% This function computes the v-infinity vector in cartesian coordinates
% given a set of v-infinity magnitude, pump and crank angles.
%
% INPUT
% - vinf      : v-infinity magnitude [km/s]
% - alpha     : pump angle [rad]
% - k         : crank angle [rad]
% - t         : epoch of the flyby [MJD2000]
% - idpl      : ID of the flyby body (see also constants.m)
% - idcentral : ID of the central bodt (see also constants.m)
%
% OUTPUT
% - vinfCAR : 1x3 vector with v-infinity in cartesian coordinates (vinfx,
%             vinfy, vinfx) [km/s]
% - rr      : 1x3 vector of spacecraft position at epoch [km]
% - vv      : 1x3 vector of spacecraft velocity at epoch [km/s]
% - vvga    : 1x3 vector of flyby body velocity at epoch [km/s]
%
% -------------------------------------------------------------------------

if nargin == 6
    customEphemerides = @approxEphem_CC;
end
[rrga, vvga, kepga] = customEphemerides(idpl, t, idcentral);

vinfTCN = vinf.*[ cos(alpha), -sin(alpha)*sin(k), sin(alpha)*cos(k) ];
% Bug if orbits are not planar as in the case of Altaira
% thga    = kepga(end);
% gamma   = pi/2 - sign( rrga(1)*vvga(2) - rrga(2)*vvga(1) )*acos(dot( rrga./norm(rrga), vvga./norm(vvga) ));
% 
% s = sin( thga - gamma );
% c = cos( thga - gamma );
% 
% rot_mat = [ -s, 0, c; c, 0, s; 0, 1, 0 ];
% vinfCAR = [rot_mat*vinfTCN']';

tangential  = vvga / norm(vvga);
cross_track = cross(rrga, vvga);
cross_track = cross_track / norm(cross_track);
normal      = cross(tangential, cross_track);

A = [tangential' cross_track' normal'];
 
vinfCAR = [A*vinfTCN']';
rr = rrga;
vv = vvga + vinfCAR;

end




