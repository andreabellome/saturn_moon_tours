function [pathrowNew, tof1, tof2, drr] = refinePeriapsisSolutionsL0(pathRowCheck, t0, idcentral)

% DESCRIPTION
% This function refines a VILT transfer that require L=0
% (check wrap_VILTS.m) and encounter the moon before the apoapsis passage.
% A two-point boundary value problem (TPBVP) is solved that: the spacecraft
% state leaving and arriving at a moon is propagated forward and bacward,
% respectively. When the two propagation encounter, a DV is sought and the
% corresponding difference in position vector.
% fmincon is used for this purpose (Optimization Toolbox required). Initial
% guess on the refined orbit are taken as full resonant transfers.
%
% INPUT
% - pathRowCheck : VILT to be checked. This can be a row of the
%                  'next_nodes' matrix (see also generateVILTSall.m)
% - t0 : epoch of the first encounter [MJD2000]
% - idcentral : ID of the central body (see constants.m)
% 
% OUTPUT
% - pathRowCheck: same as pathRowCheck but with updated pump angles and time of
%                 flight according to the L=0 and moon encounter before the
%                 periapsis passage.
% - tof1 : time of flight from the first encounter to the DSM [s]
% - tof2 : time of flight from the DSM to the next encounter [days]
% - drr  : not needed, will be removed from future implementations
% 
% -------------------------------------------------------------------------

id1   = pathRowCheck(1);
S     = pathRowCheck(2:6);
vinf1 = pathRowCheck(8);
vinf2 = pathRowCheck(10);

% --> start: generate the initial condition that is close to the pure resonance
if S(1) == 81
    S(3:4) = S(3:4) + 1;
end
RES1 = build_Resonances(S(3), S(4), vinf1, id1, 6);
RES2 = build_Resonances(S(3), S(4), vinf2, id1, 6);

if isempty(RES1) && ~isempty(RES2)
    alpha10 = RES2(2);
    alpha20 = RES2(2);
    tof0    = RES2(end);
elseif isempty(RES2) && ~isempty(RES1)
    alpha10 = RES1(2);
    alpha20 = RES1(2);
    tof0    = RES1(end);
elseif ~isempty(RES1) && ~isempty(RES2)
    alpha10 = RES1(2);
    alpha20 = RES2(2);
    tof0    = 0.5*( RES1(end) + RES2(end) );
end
% --> end: generate the initial condition that is close to the pure resonance

% --> define initial guess, cost and constraints' functions
xx0         = [ alpha10 alpha20 tof0 ];
costFunc    = @(xx) solvePeriapsisManoeuvre(xx, vinf1, vinf2, S, id1, t0, idcentral);
constraints = @(xx) constraintSolvePeriapsis(xx, vinf1, vinf2, S, id1, t0, idcentral);

% --> options for the optimization
options = optimoptions("fmincon",...
"Algorithm","interior-point",...
"SubproblemAlgorithm","cg", ...
"StepTolerance", 1e-99, "ConstraintTolerance", 1e-4, ...
"MaxFunctionEvaluations", 10e3,...
"Display","none");

% --> lower and upper bounds for the optimization variables
lb = [ 0  0  0 ];
ub = [ pi pi Inf ];

% --> solve the TPBVP and evaluate the cost function
[xsol, fval]            = fmincon( costFunc, xx0, [], [], [], [], lb, ub, constraints, options );
[~, drr, ~, tof1, tof2] = costFunc(xsol);

% --> start: write the refined solution
if S(1) == 81
    S(3:4) = S(3:4) - 1;
end
pathrowNew = [ id1 S xsol(1) vinf1 xsol(2) vinf2 fval xsol(3) ];
% --> end: write the refined solution

end
