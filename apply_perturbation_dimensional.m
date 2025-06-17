function [ sv0_dim_pert, pos_pert_km_sigma, vel_pert_km_s_sigma ] = apply_perturbation_dimensional( sv0_dim, pos_pert_km, vel_pert_km_s, sigma_pos, sigma_vel )

% --> perturbations are in km and km/s

if nargin == 3
    sigma_pos = 3;
    sigma_vel = 3;
elseif nargin == 4
    sigma_vel = 3;
end

% --> generate random perturbation in position and velocity
pos_pert_km_sigma   = normrnd(pos_pert_km, pos_pert_km/sigma_pos);
vel_pert_km_s_sigma = normrnd(vel_pert_km_s, vel_pert_km_s/sigma_vel);

% --> generate random unit perturbation for the direction
dir_vector_pos     = random_direction_spherical();
pos_pert_vector_km = pos_pert_km_sigma.*dir_vector_pos;

dir_vector_vel       = random_direction_spherical();
vel_pert_vector_km_s = vel_pert_km_s_sigma.*dir_vector_vel;

% --> apply perturbation
sv0_dim_pert      = zeros( 1,6 );
sv0_dim_pert(1:3) = sv0_dim(1:3) + pos_pert_vector_km;
sv0_dim_pert(4:6) = sv0_dim(4:6) + vel_pert_vector_km_s;

end

