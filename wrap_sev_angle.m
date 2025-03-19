function structOrbit = wrap_sev_angle( structOrbit, strucNorm )

% --> everything is centered in CoM of CR3BP and is in ADIMENSIONAL units

for index = 1:length(structOrbit)
    structOrbit(index).sev_angle = sun_earth_vehicle_angle( structOrbit(index).tt, structOrbit(index).yy, strucNorm );
end

for index = 1:length(structOrbit)
    structOrbit(index).max_sev_angle = max( structOrbit(index).sev_angle );
    structOrbit(index).min_sev_angle = min( structOrbit(index).sev_angle );
end

end