function [normVinf, pump, crank] = VinfCART_to_vinfAlphaCrank(vinf, epoch, idpl, idcentral)

% DESCRIPTION
% This function computes v-infinity magnitude, pump and crank angles, given
% v-infinity vector in cartesian coordinates.
% 
% INPUT
% - vinf      : 1x3 vector with v-infinity in cartesian coordinates (vinfx,
%               vinfy, vinfx) [km/s]
% - epoch     : epoch of the flyby [MJD2000]
% - idpl      : ID of the flyby body (see also constants.m)
% - idcentral : ID of the central bodt (see also constants.m)
% 
% OUTPUT
% - normVinf : v-infinity magnitude [km/s]
% - pump     : pump angle [rad]
% - crank    : crank angle [rad]
%
% -------------------------------------------------------------------------

[rfb, vfb] = approxEphem_CC(idpl, epoch, idcentral);
norm_vfb   = norm(vfb);

if isequaln( vinf, zeros(1,3) )
    normVinf = NaN;
    pump     = NaN;
    crank    = NaN;
    return
end

tangential  = vfb / norm_vfb;
cross_track = cross(rfb, vfb);
cross_track = cross_track / norm(cross_track);
normal      = cross(tangential, cross_track);

vinf_tcn_cart = [dot(vinf, tangential), dot(vinf, cross_track), dot(vinf, normal)];

normVinf = norm(vinf_tcn_cart);
pump     = acos(vinf_tcn_cart(1) / normVinf);

if abs(pump) >= 0.001
    crank = -atan2(vinf_tcn_cart(2), vinf_tcn_cart(3));
else
    crank = 0.0;
end

end

