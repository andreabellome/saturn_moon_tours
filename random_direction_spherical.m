function dir_vector = random_direction_spherical()
    % Azimuthal angle (theta) between 0 and 2*pi
    theta = 2 * pi * rand();

    % Elevation angle (phi) using inverse transform sampling
    phi = acos(2 * rand() - 1);

    % Convert spherical to Cartesian coordinates
    x = sin(phi) * cos(theta);
    y = sin(phi) * sin(theta);
    z = cos(phi);

    % Return the direction vector
    dir_vector = [x, y, z];
end
