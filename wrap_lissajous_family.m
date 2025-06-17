function lissajous = wrap_lissajous_family( Ay_vect, Az_vect, m, phi, final_time, strucNorm, lpoint )

% !!! This uses another formulation for the Lissajous with respect to the
% one of Ross book (the two formulations are equivalent, but they are
% shifted in phases)

% !!! Az_vect and Ay_vect should have the same length and are in km !!!

% !!! final_time is in NON-DIMENSIONAL UNITS !!!!! 

n = length(Az_vect);
lissajous = struct( 'Ax', cell(1,n), 'Ay', cell(1,n), 'Az', cell(1,n), ...
                     'sv0', cell(1,n), ...
                     'norm_plot', cell(1,n), ...
                     'orb_period_in_plane', cell(1,n), ...
                     'orb_period_out_of_plane', cell(1,n), ...
                     'Jc', cell(1,n), 'tt', cell(1,n), 'yy', cell(1,n), ...
                     'phi', cell(1,n), 'psi', cell(1,n), 'm', cell(1,n));
for ind = 1:length(Az_vect)
    lissajous(ind) = linearised_lissajous_v2( Ay_vect(ind), Az_vect(ind), m, phi, final_time, strucNorm, lpoint );
end

end