function vinfStruc = adjust_vinf( gm, a, cart_fb, planar_sc_vel, vinf_norm, heading, side )

% DESCRIPTION
% This function computes v-infinity, pump and crank angles given an orbit
% crossing a flyby body.
% 
% INPUT
% - gm      : gravitational parameter of the central body [km/3/s2]
% - a       : semi-major axix [km]
% - cart_fb : 1x6 vector with position [km] and velocity [km/s] of the flyby
%             body
% - planar_sc_vel : velocity of the spacecraft [km/s]
% - vinf_norm     : v-infinity magnitude [km/s]
% - heading       : 8.OUTGOING, 1.INCOMING
% - side          : +1.ABOVE, -1.BELOW
% 
% OUTPUT
% - vinfStruc : structure with the following fields:
%               - vinfStruc.vinf  : v-infinity magnitude [km/s]
%               - vinfStruc.alpha : pump angle [rad]
%               - vinfStruc.crank : crank angle [rad]
% 
% -------------------------------------------------------------------------

rfb = cart_fb(1:3);
vfb = cart_fb(4:6);

n_rfb = norm(rfb);
n_vfb = norm(vfb);

sc_orbital_period = 2*pi*sqrt( a^3/gm );
sc_sma = ( gm*( sc_orbital_period/(2*pi) )^2 )^(1/3);
if sc_sma <= n_rfb / 2
    alpha = NaN;
else
    energy = -gm/(2*sc_sma);
    v_sc   = sqrt( 2*( energy + gm/n_rfb ) );

    if (-v_sc < n_vfb - vinf_norm) && (  n_vfb - vinf_norm< v_sc ) && (v_sc < vinf_norm + n_vfb )
        cosalpha = (v_sc^2 - vinf_norm^2 - n_vfb^2) / (2 * vinf_norm * n_vfb);
        alpha = acos(cosalpha);
    else
        alpha = NaN;
    end

end

if isnan(alpha)
    vinfStruc.vinf  =  NaN;
    vinfStruc.alpha =  NaN;
    vinfStruc.crank =  NaN;
    return
end

vec_x = rfb / n_rfb;

beta = acos(dot(vfb, vec_x) / n_vfb);
x = dot(planar_sc_vel, vec_x);

k = (x - cos(beta) * (n_vfb + vinf_norm * cos(alpha))) / (vinf_norm * sin(alpha) * sin(beta));

if ~( (-1 <= k) && (k <= 1) )
    vinfStruc.vinf  =  NaN;
    vinfStruc.alpha =  NaN;
    vinfStruc.crank =  NaN;
    return
end

if heading == 8 % --> OUTGOING
    heading_factor = 1;
else
    heading_factor = -1;
end

if side == 1 % --> ABOVE
    side_factor = -1;
else
    side_factor = 1;
end

crank_interval = heading_factor * side_factor * acos(k);

vinfStruc.vinf  =  vinf_norm;
vinfStruc.alpha =  alpha;
vinfStruc.crank =  crank_interval;

end
