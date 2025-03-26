function F = prop_state_v2( dv0, xx0_new, xx0_original, strucNorm, orb_period )

dv0(end) = 0;

xx0_new(4:6) = xx0_new(4:6) + dv0;
% xx0(4:6) = xx0(5) + dv0;

svtf = propagateCR3BP( xx0_new, orb_period, strucNorm, 1e3 );
F    = [svtf - xx0_original];

% F = svtf(4);

end