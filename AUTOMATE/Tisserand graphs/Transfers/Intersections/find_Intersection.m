function [DE] = find_Intersection(E, pl1, pl2, vinfpl1, vinfpl2, idcentral)

% DESCRIPTION : 
% this function is used to find intersections between contours on Tisserand
% map. The function DE(rp)=0 must be solved to find intersections.
%
% INPUT :
% E       : energy of the orbit representing the intersection between two
%           infinity velocity contours (km2/s2)
% pl1     : departing planet ID
% pl2     : arrival planet ID
% vinfpl1 : infinity velocity at the first planet (km/s)
% vinfpl2 : infinity velocity at the second planet (km/s)
%
% OUTPUT : 
% DE : energy difference (km2/s2)
%
% -------------------------------------------------------------------------

if nargin == 5
    idcentral = 1;
end

rp1 = En2raRp(E, pl1, vinfpl1, idcentral); % --> periapsis radius on the first contour
rp2 = En2raRp(E, pl2, vinfpl2, idcentral); % --> periapsis radius on the second contour

DE = rp1 - rp2; % --> energy difference

end