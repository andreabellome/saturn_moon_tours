function [ structOrbit ] = wrap_dist_to_secondary( structOrbit, strucNorm )

% --> everything is centered in CoM of CR3BP and is in ADIMENSIONAL units

for index = 1:length(structOrbit)
    structOrbit(index).dist_to_secondary = distance_to_secondary( structOrbit(index).tt, structOrbit(index).yy, strucNorm );
end

for index = 1:length(structOrbit)
    structOrbit(index).max_dist_to_secondary = max( structOrbit(index).dist_to_secondary );
    structOrbit(index).min_dist_to_secondary = min( structOrbit(index).dist_to_secondary );
end

end