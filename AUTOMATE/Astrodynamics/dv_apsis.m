function delta_v = dv_apsis( ra_init, rp_init, rapsis_final, apsis_to_mod, mu_central )

% DESCRIPTION
% This function computes the velocity increment (delta-v) required to change
% either the apoapsis or periapsis of an orbit, assuming an impulsive maneuver
% applied at the opposite apsis.
%
% INPUT
% - ra_init       : initial apoapsis radius [km]
% - rp_init       : initial periapsis radius [km]
% - rapsis_final  : final desired value for the modified apsis [km]
% - apsis_to_mod  : apsis to be modified (+1 for apoapsis, -1 for periapsis)
% - mu_central    : gravitational parameter of the central body [km^3/s^2]
%
% OUTPUT
% - delta_v       : velocity increment [km/s] required to achieve the apsis change
%
% -------------------------------------------------------------------------


sma_init      = 0.5 * (ra_init + rp_init);
vel_apo_init  = visVivaEquation( sma_init, ra_init, mu_central );
vel_peri_init = visVivaEquation( sma_init, rp_init, mu_central );

if apsis_to_mod == +1 % --> modify the apoapsis
    v_pre     = vel_peri_init;
    sma_final = 0.5 * (rapsis_final + rp_init);
    r_thrust  = rp_init;
elseif apsis_to_mod == -1 % --> modify the periapsis
    v_pre = vel_apo_init;
    sma_final = 0.5 * (rapsis_final + ra_init);
    r_thrust  = ra_init;
else
    error("The apsis provided must be either apsis_to_mod=+1 (APOAPSIS) or apsis_to_mod=-1 (PERIAPSIS)");
end

v_post = visVivaEquation(sma_final, r_thrust, mu_central);

delta_v = v_post - v_pre;

end