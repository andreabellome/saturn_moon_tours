function [id1, id2, t1, t2, tof, dv, rr1, vvd, rr2, vva, vvinf_dep, vvinf_arr, vv1, vv2] = ...
    patRowVILTtoState(pathrow, t0, idcentral)

% DESCRIPTION
% Extract all the information about a VILT transfer. This assumes an
% initial epoch (MJD2000).
% 
% INPUT
% - pathrow : row with VILT information. This is a row of 'next_nodes'
%             matrix (see for example generateVILTSall.m)
% - t0      : epoch of the first encounter [MJD2000]
% - idcentral : ID of the central body (see constants.m)
% 
% OUTPUT
% - id1       : ID of the flyby body at first encounter (see also centralBody_planet.m) 
% - id2       : ID of the flyby body at second encounter (see also centralBody_planet.m) 
% - t1        : epoch of the flyby at first encounter [MJD2000]
% - t2        : epoch of the flyby at second encounter [MJD2000]
% - tof       : time of flight of the transfer [days]
% - dv        : DV of the transfer [km/s]
% - rr1       : 1x3 vector of body/spacecraft position at first encounter [km]
% - vvd       : 1x3 departure spacecraft velocity vector at t1 [km/s]
% - rr2       : 1x3 vector of body/spacecraft position at second encounter [km]
% - vva       : 1x3 arrival spacecraft velocity vector at t2 [km/s]
% - vvinf_dep : 1x3 infinity velocity vector at t1 [km/s]
% - vvinf_arr : 1x3 infinity velocity vector at t2 [km/s]
% - vv1       : 1x3 velocity vector of the flyby body at t1 [km/s]
% - vv2       : 1x3 velocity vector of the flyby body at t2 [km/s]
% 
% -------------------------------------------------------------------------

id1 = pathrow(1);
id2 = id1;
dv  = pathrow(end-1);
tof = pathrow(end);
t1  = t0;
t2  = t1 + tof;

kio = type2kio(pathrow(2));
p = kio(1);
q = kio(2);

alpha1 = pathrow(7);
vinf1  = pathrow(8);
alpha2 = pathrow(9);
vinf2  = pathrow(10);

[rr1, vv1] = approxEphem_CC(id1, t1, idcentral);
[rr2, vv2] = approxEphem_CC(id2, t2, idcentral);

vvinf_dep = vinf1.*( -sin(-p*alpha1).*rr1./norm(rr1) + cos(-p*alpha1).*vv1./norm(vv1));
vvinf_arr = vinf2.*( -sin(-q*alpha2).*rr2./norm(rr2) + cos(-q*alpha2).*vv2./norm(vv2));

vvd = vv1 + vvinf_dep;
vva = vv2 + vvinf_arr;

end
