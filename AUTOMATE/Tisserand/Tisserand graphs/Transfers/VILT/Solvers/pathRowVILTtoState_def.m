function VILTstruc = pathRowVILTtoState_def(pathrow, t0, INPUT)

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
idMO  = pathrow(1,1);
idpl  = INPUT.idcentral;
S     = pathrow( 1, 2:6 );
vinf1 = pathrow(1,8);
vinf2 = pathrow(1,10);
[~, DV, tofsc, node_pp, alpha_p_pf] = wrap_VILT(S, vinf1, vinf2, idMO, idpl);
nodeToAdd                           = [idMO S [alpha_p_pf vinf1] node_pp [DV tofsc/86400]];
[nodeToAdd, tof1, tof2]             = computeTof1Tof2AndRefine(nodeToAdd, INPUT.idcentral);
if tof2 > 1e99
    tof2 = 0;
end
pathrow = nodeToAdd;
% --> end: first do the post-processing

% --> start: reconstruct the state
id1 = pathrow(1);
id2 = id1;
dv  = pathrow(end-1);
tof = pathrow(end);
t1  = t0;
t2  = t1 + tof;

kio = type2kio(pathrow(2));
p   = kio(1);
q   = kio(2);

alpha1 = pathrow(7);
vinf1  = pathrow(8);
alpha2 = pathrow(9);
vinf2  = pathrow(10);

[rr1, vv1] = approxEphem_CC(id1, t1, idpl);
[rr2, vv2] = approxEphem_CC(id2, t2, idpl);

vvinf_dep = vinf1.*( -sin(-p*alpha1).*rr1./norm(rr1) + cos(-p*alpha1).*vv1./norm(vv1));
vvinf_arr = vinf2.*( -sin(-q*alpha2).*rr2./norm(rr2) + cos(-q*alpha2).*vv2./norm(vv2));

vvd = vv1 + vvinf_dep;
vva = vv2 + vvinf_arr;
% --> end: reconstruct the state

% --> start: save the output
VILTstruc.id1       = id1;
VILTstruc.t1        = t1;
VILTstruc.id2       = id2;
VILTstruc.t2        = t2;
VILTstruc.rr1       = rr1;
VILTstruc.vvd       = vvd;
VILTstruc.rr2       = rr2;
VILTstruc.vva       = vva;
VILTstruc.vv1       = vv1;
VILTstruc.vv2       = vv2;
VILTstruc.vvinf_dep = vvinf_dep;
VILTstruc.vvinf_arr = vvinf_arr;
VILTstruc.alpha1    = wrapToPi(acos( dot(vvinf_dep, vv1)/(norm(vvinf_dep)*norm(vv1)) ));
VILTstruc.vinf1     = norm(vvinf_dep);
VILTstruc.alpha2    = wrapToPi(acos( dot(vvinf_arr, vv2)/(norm(vvinf_arr)*norm(vv2)) ));
VILTstruc.vinf2     = norm(vvinf_arr);
VILTstruc.dv        = dv;
VILTstruc.tof       = tof;
VILTstruc.tof1      = tof1; % --> DAYS !!!
VILTstruc.tof2      = tof2; % --> DAYS !!!
VILTstruc.S         = pathrow( 2:6 );
% --> end: save the output

end
