function [rr, vv, kep, r, M] = ephj2000(pl, t)

% circular coplanar ephemerides for the planets in MJD2000

% INPUT : 
% pl - planet ID (Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune)
% t  - epoch MJD2000 (the reference one is January 1, 2000)

% t is expressed in days from t0 = 0

% mu = getAstroConstants('Sun', 'Mu');
[mu, ~, AU] = constants(1, 3);

if pl == 1
    % Mercury
    r   = 0.3871*AU;
    M0  = deg2rad(252.251);
    
elseif pl == 2
    % Venus
    r   = 0.7233*AU;
    M0  = deg2rad(181.980);
    
elseif pl == 3
    % Earth
    r   = 1.0000*AU;
    M0  = deg2rad(100.466);
    
elseif pl == 4
    % Mars
    r   = 1.5237*AU;
    M0  = deg2rad(355.433);
    
elseif pl == 5
    % Jupiter
    r   = 5.2026*AU;
    M0  = deg2rad(34.351);
    
elseif pl == 6
    % Saturn
    r   = 9.5549*AU;
    M0  = deg2rad(50.077);
    
elseif pl == 7
    % Uranus
    r   = 19.2185*AU;
    M0  = deg2rad(314.055);
    
elseif pl == 8
    % Neptune
    r   = 30.1104*AU;
    M0  = deg2rad(304.349);
    
end

[~, ~, r] = constants(1, pl);

% angular velocity
om  = sqrt(mu/r)/r;                  % rad/s

% planet position and velocity at t
M  = M0 + om*(t*86400);              % rad
M  = wrapTo2Pi(M);                   % rad
rr = r.*[cos(M) sin(M) 0];           % km
vv = sqrt(mu/r).*[-sin(M) cos(M) 0]; % km/s

kep = car2kep( [ rr, vv ], mu );

end
