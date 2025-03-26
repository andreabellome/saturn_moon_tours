function sev_angle = sun_earth_vehicle_angle( tt, yy, strucNorm )

% --> everything is centered in CoM of CR3BP and is in ADIMENSIONAL units

x2      = strucNorm.x2;
yy(:,1) = yy(:,1) - x2; % --> 1) shift with center to Earth
vec     = [ -1 0 0 ];   % --> from Earth to Sun

sev_angle = zeros( size( yy,1 ),1 );
for index = 1:size(yy,1)
    sev_angle(index,:) = acos( dot( yy(index,1:3), vec )./( norm( yy(index,1:3) )*norm( vec ) ) );
end

end