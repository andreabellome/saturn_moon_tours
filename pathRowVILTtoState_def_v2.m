function VILTstruc = pathRowVILTtoState_def_v2(pathrow, t0, INPUT)

% DESCRIPTION
% This function processes a moon tour leg and saves it in a structure.
% 
% INPUT
% - pathrow : row vector with a VILT (similar to 'next_nodes' rows of
%             generateVILTSall.m)
% - t0      : initial tour epoch [MJD2000]
% - INPUT   : structure with the following mandatory fields:
%            - idcentral : ID of the central body (see constants.m)
% 
% OUTPUT
% - VILTstruc : structure with the following fields:
%           - id1 : ID of the first flyby body (see constants.m)
%           - t1 : initial epoch [MJD2000]
%           - id2 : ID of the arrival flyby body (see constants.m)
%           - t2 : final epoch [MJD2000]
%           - rr1     : 1x3 vector with initial position [km]
%           - vvd     : 1x3 vector with initial velocity [km/s]
%           - rr2     : 1x3 vector with final position [km]
%           - vva     : 1x3 vector with final velocity [km/s]
%           - vv1     : 1x3 vector with velocity of the first moon [km/s]
%           - vv2     : 1x3 vector with velocity of the arrival moon [km/s]
%           - vvinf_dep :  1x3 vector with infinity velocity at the
%           starting moon [km/s]
%           - vvinf_arr : 1x3 vector with infinity velocity at the
%           arrival moon [km/s]
%           - alpha1 : pump angle at the starting moon [rad]
%           - vinf1  : norm of vvinf_dep [km/s] 
%           - alpha2 : pump angle at the arrival moon [rad]
%           - vinf2  : norm of vvinf_arr [km/s] 
%           - dv     : DV manoeuvre of the DSM [km/s]
%           - tof    : time of flight [days]
%           - tof1   : time of flight from first flyby to DSM [days]
%           - tof2   : time of flight from DSM to next flyby [days]
%           - S      : anatomy of the VILT (see wrap_VILT.m)
% 
% -------------------------------------------------------------------------

% --> start: first do the post-processing
idcentral = INPUT.idcentral;
S         = pathrow( 1, 2:6 );

vinf1  = pathrow(8);
vinf2  = pathrow(10);

id1 = pathrow(1);
id2 = id1;

type = S(1);
kei  = S(2);
N    = S(3);
M    = S(4);
L    = S(5);
[vinf1, alpha1, crank1, vinf2, alpha2, crank2, dv, tof1, tof2] = ...
     wrap_vInfinityLeveraging(type, N, M, L, kei, vinf1, vinf2, id1, idcentral);

tof1_days = tof1 / 86400;
tof2_days = tof2 / 86400;
tof_days  = tof1_days + tof2_days;

t1  = t0;
t2  = t1 + tof_days;

[vvinf_dep, rr1, vvd, vvga1] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank1, t1, id1, idcentral);
[vvinf_arr, rr2, vva, vvga2] = vinfAlphaCrank_to_VinfCART(vinf2, alpha2, crank2, t2, id2, idcentral);

mu_central = constants(idcentral, 1);
kep1       = car2kep( [rr1, vvd], mu_central );
kep2       = car2kep( [rr2, vva], mu_central );

% --> start: save the output
VILTstruc.id1       = id1;
VILTstruc.t1        = t1;
VILTstruc.id2       = id2;
VILTstruc.t2        = t2;
VILTstruc.rr1       = rr1;
VILTstruc.vvd       = vvd;
VILTstruc.rr2       = rr2;
VILTstruc.vva       = vva;
VILTstruc.vv1       = vvga1;
VILTstruc.vv2       = vvga2;
VILTstruc.kep1      = kep1;
VILTstruc.kep2      = kep2;
VILTstruc.vvinf_dep = vvinf_dep;
VILTstruc.vvinf_arr = vvinf_arr;
VILTstruc.alpha1    = wrapToPi(acos( dot(vvinf_dep, vvga1)/(norm(vvinf_dep)*norm(vvga1)) ));
VILTstruc.vinf1     = norm(vvinf_dep);
VILTstruc.crank1    = crank1;
VILTstruc.alpha2    = wrapToPi(acos( dot(vvinf_arr, vvga2)/(norm(vvinf_arr)*norm(vvga2)) ));
VILTstruc.vinf2     = norm(vvinf_arr);
VILTstruc.crank2    = crank2;
VILTstruc.dv        = dv;
VILTstruc.tof       = tof_days;
VILTstruc.tof1      = tof1_days; % --> DAYS !!!
VILTstruc.tof2      = tof2_days; % --> DAYS !!!
VILTstruc.S         = pathrow( 2:6 );
% --> end: save the output

end
