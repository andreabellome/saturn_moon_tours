function [dv, alpha, alpha_A] = findDV(vvrel_A, vvrel_D, muPL, rpmin)

% DESCRIPTION
% This function computes DV defects.
%
% INPUT
% - vvrel_A : 1x3 vector with incoming relative velocity [km/s]
% - vvrel_D : 1x3 vector with outgoing relative velocity [km/s]
% - muPL    : gravitational parameter of the flyby body [km3/s2]
% - rpmin   : minimum flyby periapsis [km]
% 
% OUTPUT
% - dv      : DV defect manoeuvre [km/s]
% - alpha   : deflection required for the flyby [rad]
% - alpha_A : max. deflection for the minimum periapsis flyby [rad]
%
% -------------------------------------------------------------------------

alpha   = acos(dot(vvrel_A, vvrel_D)/(norm(vvrel_A)*norm(vvrel_D))); % turning angle
e_A     = 1 + (rpmin*norm(vvrel_A)^2)/muPL;                          % max. deflection hyperbola eccentricity
alpha_A = 2*asin(1/e_A);                                             % max. deflection turning angle

alpha   = wrapToPi(alpha);
alpha_A = wrapToPi(alpha_A);

% --> compute the DV
if alpha <= alpha_A
    dv = abs( norm(vvrel_D) - norm(vvrel_A));
else
    dv = sqrt((norm(vvrel_A))^2 + (norm(vvrel_D))^2 - 2*(norm(vvrel_A))*(norm(vvrel_D))*cos(alpha_A - alpha));
end

end
