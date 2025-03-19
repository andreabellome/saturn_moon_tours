function [ earth_dist ] = distance_to_secondary( tt, yy, strucNorm )

% --> everything is centered in CoM of CR3BP and is in ADIMENSIONAL units

x2         = strucNorm.x2;
xx2        = [ x2 0 0 ]; % --> Earth position
earth_dist = vecnorm( [ yy(:,1:3) - xx2 ]' )';

end