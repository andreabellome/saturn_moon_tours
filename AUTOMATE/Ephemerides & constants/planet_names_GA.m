function [planet, fullName] = planet_names_GA(planet_id, idcentral)

% DESCRIPTION
% This function gives strings with intials and full names of flyby bodies
% depending upon the selected system (see also constants.m).
%
% INPUT
% - planet_id : ID of the flyby body (see also constants.m)
% - idcentral : ID of the central body (see also constants.m)
% 
% OUTPUT
% - planet   : string with initial letter for the flyby body
% - fullName : 
%
% -------------------------------------------------------------------------

if nargin == 1
    idcentral = 1;
end

if idcentral == 1

    planets = ['Y'
               'V'
               'E'
               'M'
               'J'
               'S'
               'U'
               'N'
               'P'];
    list = {'Mercury', 'Venus', 'Earth', 'Mars', 'Jupiter', 'Saturn', 'Uranus', 'Neptune', 'Pluto'};

elseif idcentral == 5

    planets = ['I'
               'E'
               'G'
               'C'];
    list = {'Io', 'Europa', 'Ganymede', 'Callisto'};

elseif idcentral == 6

        planets = ['E'
                   't'
                   'D'
                   'R';
                   'T'];
        list = {'Enceladus', 'Thetys', 'Dione', 'Rhea', 'Titan'};


elseif idcentral == 7

    planets = [ 'M'
                'A'
                'U'
                'T'
                'O'];

end

if idcentral == 6 && planet_id == 0
    planet   = 'M';
    fullName = 'Mimas';
elseif idcentral == 30 && planet_id == 0
    planet   = 'M';
    fullName = 'Moon';
else
    planet   = planets(planet_id, 1);
    fullName = list{planet_id};
end

end
