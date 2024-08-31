function [dv, drr, tof, tof1, tof2] = solvePeriapsisManoeuvre(xx, vinf1, vinf2, S, id1, t0, idcentral)

% DESCRIPTION
% Solve two-point bnoundary value problem (TPBVP) for VILTs that are INTERIOR,
% such that L = 0, and with an outbound departure (see also description of
% wrap_VILT.m). The TPBVP is as follows: the spacecraft state leaving and
% arriving at a moon is propagated forward and bacward, respectively. When
% the two propagation encounter, a DV is sought and the corresponding
% difference in position vector.
% 
% INPUT
% - xx : 1x3 optimization variables; these are as follows:
%       xx(1) : alpha1, i.e., pump angle at departure [rad]
%       xx(2) : alpha2, i.e., pump angle at arrival [rad]
%       xx(3) : tof, i.e., time of flight on the VILT [s]
% - vinf1 : departing infinity velocity [km/s]
% - vinf2 : arrival infinity velocity [km/s]
% - S     : anatomy of the VILT (see also wrap_VILT.m)
% - id1   : ID of the flyby body (see also constants.m)
% - t0    : epoch at the departure [MJD2000]
% - idcentral : ID of the central body (see also constants.m)
% 
% OUTPUT
% - dv   : DV on the VILT [km/s]
% - drr  : 1x3 node of the TPBVP, i.e., difference of position vector
%          between backward and forward propagation.
% - tof  : time of flight on the VILT [days]
% - tof1 : time of flight from departure to DSM [days]
% - tof2 : time of flight from DSM to arrival [days]
% 
% -------------------------------------------------------------------------

% --> constants
mu = constants(idcentral, id1);

% --> extract the optimization variables
alpha1 = xx(1);
alpha2 = xx(2);
tof    = xx(3);

% --> extract type of transfer (IO, OI, OO, II)
kio = type2kio(S(1));
p   = kio(1);
q   = kio(2);

% --> moon's ephemerides
t1         = t0;
t2         = t1 + tof;
[rr1, vv1] = approxEphem_CC(id1, t1, idcentral);
[rr2, vv2] = approxEphem_CC(id1, t2, idcentral);

% --> spacecraft state
vvinf_dep = vinf1.*( -sin(-p*alpha1).*rr1./norm(rr1) + cos(-p*alpha1).*vv1./norm(vv1));
vvinf_arr = vinf2.*( -sin(-q*alpha2).*rr2./norm(rr2) + cos(-q*alpha2).*vv2./norm(vv2));

% [crank1, crank2] = type2Crank(S(1));
% [vvinf_dep, rr1, vvd] = vinfAlphaCrank_to_VinfCART(vinf1, alpha1, crank1, t0, id1, idcentral); % --> find cartesian elements


vvd = vv1 + vvinf_dep;
vva = vv2 + vvinf_arr;

kep1 = car2kep( [rr1 vvd], mu );

try

    % --> time of flight on the two arcs
    tof1 = kepEq_t(2*pi, kep1(1), kep1(2), mu, kep1(end), 0); % --> time to periapsis
    tof2 = tof*86400 - tof1;

    % --> propagate forward until the manoeuvre point
    [rrpre, vvpre] = FGCar_dt(rr1, vvd, tof1, mu);
    
    % --> propagate backwards until the manoeuvre location
    [rrpost, vvpost] = FGCar_dt(rr2, vva, -tof2, mu);

catch

    st = 1

end

% --> DV
dv = norm(vvpost - vvpre);

% --> position vector error
drr = rrpost - rrpre;

end
