function [muCentral, mupl, rpl, radpl, hmin, Tpl] = constants(idcentral, pl)

% DESCRIPTION
% This function extracts central body and flyby body parameters. It assumes
% circular coplanar orbits of the flyby bodies around the central body.
% Each flyby body is assumed to be a perfect sphere.
%
% INPUT
% - idcentral : ID of the central body
%               0:  Sun
%               30: Earth
%               5:  Jupiter
%               6:  Saturn
%               7:  Uranus
% - pl        : ID of the flyby body, depending on the idpl
%               if idcentral = 0:
%                   flyby body ID (1. Mercury, 2. Venus, 3. Earth, 4. Mars, 5. Jupiter, ...
%                   6. Saturn, 7. Uranus, 8. Neptune)
%               if idcentral = 30
%                   flyby body ID (0. Moon)
%               if idcentral = 5
%                   flyby body ID (1. Io, 2. Europa, 3. Ganimede, 4. Callisto)
%               if idcentral = 6
%                   flyby body ID (0. Mimas, 1. Enceladus, 2. Tethys, 3. Dione, 4. Rhea, 5. Titan)
%               if idcentral = 7
%                   flyby body ID (1. Miranda, 2. Ariel, 3. Umbriel, 4. Titania, 5. Oberon)
%
% OUTPUT
% - muCentral : gravitational parameter of the central body [km3/s2]
% - mupl      : gravitational parameter of the flyby body [km3/s2]
% - rpl       : circular orbit radius of the flyby body [km]
% - radpl     : circular radius of the flyby body [km]
% - hmin      : minimum altitude for the flyby [km]
% - Tpl       : orbital period of the flyby body [s]
% 
% -------------------------------------------------------------------------


if idcentral == 1
    muCentral                      = 132724487690;
    [mupl, radpl, rpl, ~, ~, hmin] = planetConstants(pl);
elseif idcentral == 5
    muCentral                      = planetConstants(idcentral);
    [rpl, mupl, radpl, hmin]       = jupMoonsConstants(pl);
elseif idcentral == 6
    muCentral = planetConstants(idcentral);
    [rpl, mupl, radpl, hmin]       = satMoonsConstants(pl);
elseif idcentral == 7
    muCentral = planetConstants(idcentral);
    [rpl, mupl, radpl, hmin]       = uranusMoonsConstants(pl);
elseif idcentral == 30 % --> central body is the Earth
    muCentral = planetConstants(3);
    mupl      = 4.902780137400001e+03; % --> mu for the Moon
    rpl       = 384401;
    radpl     = 1738;
    hmin      = 100;
end
Tpl = 2*pi.*sqrt( rpl.^3./muCentral );

end
