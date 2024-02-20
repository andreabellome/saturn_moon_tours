function [c, ceq] = constraintSolvePeriapsis(xx, vinf1, vinf2, S, id1, t0, idcentral)

% DESCRIPTION
% This function is used to write non-linear constraints for the
% optimization problem solved in refinePeriapsisSolutionsL0.m
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
% - c : 1x2 vector of inequality constraints. This is as fowllows:
%       c(1) is the TOF until the DSM [days]              --> c(1) > 0
%       c(2) is the TOF from DSM to next encounter [days] --> c(2) > 0
% - ceq : 1x3 vector with equality constraints. This is the position vector
%        difference at the DSM point [km]
%
% -------------------------------------------------------------------------

% --> propagate forward and bacwark until the DSM point
[~, drr, ~, tof1, tof2] = solvePeriapsisManoeuvre(xx, vinf1, vinf2, S, id1, t0, idcentral);

% --> write the constraints
c   = [-tof1 -tof2];
ceq = drr;

end