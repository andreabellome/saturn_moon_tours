function F = prop_state( dv0, xx0, strucNorm, orb_period, three_dim )

if nargin == 4
    three_dim = 0;
end

% dv0(1) = 0;

if three_dim == 0
    dv0(end) = 0;
end

xx0(4:6) = xx0(4:6) + dv0;
% xx0(4:6) = xx0(5) + dv0;

svtf = propagateCR3BP( xx0, orb_period, strucNorm, 1e3, 1 );
% F    = [svtf - xx0];

% F = [svtf(2), svtf(4)]; % --> this gets very strange...
F = [ svtf(4)];

end