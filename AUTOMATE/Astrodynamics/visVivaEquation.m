function vel = visVivaEquation( sma, rad, mu )

% DESCRIPTION
% This function computes the orbital velocity at a given radial distance
% from the central body using the vis-viva equation. 
%
% INPUT
% - sma : semi-major axis of the orbit [km]
% - rad : radial distance from the central body at the point of interest [km]
% - mu  : gravitational parameter of the central body [km^3/s^2]
%
% OUTPUT
% - vel : orbital velocity at the given radius [km/s]
%
% -------------------------------------------------------------------------

energy = -mu./(2 .* sma);
vel    = sqrt( 2 .* (energy + mu./rad) );

end