function deltaV_lissajous = delta_v_amplitude_change_lissajous_linear( Delta_Ay, Delta_Az )

% DESCRIPTION
% This function computes the required delta-v to modify the amplitude of a 
% Lissajous orbit in the Circular Restricted Three-Body Problem (CR3BP). 
% The linear approximation is used to estimate the velocity change needed 
% to achieve the desired changes in the y- and z-components of the orbit's 
% amplitude.
%
% INPUT
% - Delta_Ay : change in the y-direction amplitude of the Lissajous orbit 
%              (in km)
% - Delta_Az : change in the z-direction amplitude of the Lissajous orbit 
%              (in km)
%
% OUTPUT
% - deltaV_lissajous : structure containing the computed delta-v values:
%                      * dv_y_l1  - delta-v in the y-direction at L1 (km/s)
%                      * dv_y_l2  - delta-v in the y-direction at L2 (km/s)
%                      * dv_z_l1  - delta-v in the z-direction at L1 (km/s)
%                      * dv_z_l2  - delta-v in the z-direction at L2 (km/s)
%                      * dv_tot_l1 - total delta-v at L1 (km/s)
%                      * dv_tot_l2 - total delta-v at L2 (km/s)
%
% -------------------------------------------------------------------------

dv_y_l1 = Delta_Ay.* 3.7134e-7;  % --> km/s
dv_y_l2 = Delta_Ay.* 3.64800e-7; % --> km/s

dv_z_l1 = Delta_Az.* 4.0123e-7; % --> km/s
dv_z_l2 = Delta_Az.* 3.9523e-7; % --> km/s

dv_tot_l1 = dv_y_l1 + dv_z_l1;
dv_tot_l2 = dv_y_l2 + dv_z_l2;

deltaV_lissajous.dv_y_l1 = dv_y_l1;
deltaV_lissajous.dv_y_l2 = dv_y_l2;

deltaV_lissajous.dv_z_l1 = dv_z_l1;
deltaV_lissajous.dv_z_l2 = dv_z_l2;

deltaV_lissajous.dv_tot_l1 = dv_tot_l1;
deltaV_lissajous.dv_tot_l2 = dv_tot_l2;

end