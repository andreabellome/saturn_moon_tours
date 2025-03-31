function [delta_z_dot, psi_f, m_f, delta_psi] = delta_v_out_plane_phase_change_lissajous_linear( Az, strucNorm, lpoint, phi0, m, tm )

% DESCRIPTION
% This function computes the required delta-v to modify the out-of-plane 
% phase of a Lissajous orbit in the Circular Restricted Three-Body Problem (CR3BP). 
% The function uses a linear approximation to estimate the velocity change 
% needed to achieve the desired phase shift in the z-direction oscillation.
%
% INPUT
% - Az        : amplitude of the Lissajous orbit in the z-direction (km)
% - strucNorm : structure containing normalization constants for distances 
%               and velocities
% - lpoint    : Lagrange point reference (e.g., L1 or L2)
% - phi0      : initial in-plane phase angle (rad)
% - m         : integer defining the phase shift (0 or 1)
% - tm        : time at which the maneuver is performed (non-dimensional) (optional, default: 0)
%
% OUTPUT
% - delta_z_dot : absolute velocity change in the z-direction due to phase shift (km/s)
% - psi_f       : final out-of-plane phase angle after maneuver (rad)
% - m_f         : final phase shift factor
% - delta_psi   : resulting change in the out-of-plane phase angle (rad)
%
% -------------------------------------------------------------------------

if nargin == 5
    tm = 0; % --> time at which the manoeuvre is performed
end

% --> normalization
Az = Az./strucNorm.normDist./1e3; % --> this needs to be scaled down to 1e3 km

% --> find the parameters of the problem
[ ~, ~, ~, ~, ~, omv, ~ ] = find_parameters_linear_theory( strucNorm, lpoint );

% --> out-of-plane phase
psi0 = phi0 + m*pi/2;

% --> manoeuvre
delta_z_dot = abs(2*Az*omv.*sin( wrapTo2Pi(omv.*tm + psi0) ));

delta_psi   = wrapTo2Pi(-2.*( omv.*tm + psi0 )); % --> mod(2*pi)
psi_f       = wrapTo2Pi( psi0 + -2.*( omv.*tm + psi0 ) );
m_f         = (psi_f - phi0)*2/pi;

% --> normalize back
delta_z_dot = delta_z_dot.*strucNorm.normVel;

end
