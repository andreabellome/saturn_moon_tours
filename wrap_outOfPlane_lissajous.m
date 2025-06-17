function [strucLiss] = wrap_outOfPlane_lissajous( dt_years, Ay, Az, phi0, m0, strucNorm, lpoint, final_prop_years )

if nargin == 7
    final_prop_years = 5;
end

if final_prop_years < 0

    fprintf( 'Final propagation is negative! \n' );
    strucLiss = NaN;

else

    t0 = 0;
    for ind = 1:length(dt_years)
        
        tt        = linspace( t0, t0 + dt_years(ind)*365.25*86400/strucNorm.normTime, 5e3 ); % --> non-dimensional
    
        lissajous = linearised_lissajous_v2( Ay, Az, m0, phi0, tt, strucNorm, lpoint );
        lissajous = wrap_sev_angle( lissajous, strucNorm );                                         % --> compute SEV
        lissajous = wrap_dist_to_secondary( lissajous, strucNorm );                                 % --> compute distance to Earth
        
        tm                   = lissajous.tt(end); % --> location of the manoeuvre (non-dimensional)
        [delta_z_dot, ~, m0] = delta_v_out_plane_phase_change_lissajous_linear( Az, strucNorm, lpoint, phi0, m0, tm );
    
        strucLiss(ind).lissajous = lissajous;
        strucLiss(ind).dv        = delta_z_dot;
        strucLiss(ind).tof       = tm; % --> non-dimensional
        strucLiss(ind).mf        = m0;
    
        t0 = lissajous.tt(end);
    
    end
    
    if isempty(dt_years)
        ind = 0;
    end
    ind = ind + 1;
    
    tt        = linspace( t0, t0 + final_prop_years(1)*365.25*86400/strucNorm.normTime, 5e3 ); % --> non-dimensional
    
    lissajous = linearised_lissajous_v2( Ay, Az, m0, phi0, tt, strucNorm, lpoint );
    lissajous = wrap_sev_angle( lissajous, strucNorm );                                         % --> compute SEV
    lissajous = wrap_dist_to_secondary( lissajous, strucNorm );                                 % --> compute distance to Earth
    
    tm                   = lissajous.tt(end); % --> location of the manoeuvre
    [delta_z_dot, ~, m0] = delta_v_out_plane_phase_change_lissajous_linear( Az, strucNorm, lpoint, phi0, m0, tm );
    
    strucLiss(ind).lissajous = lissajous;
    strucLiss(ind).dv        = delta_z_dot;
    strucLiss(ind).tof       = tm;
    strucLiss(ind).mf        = m0;
    
end

end
