function dv = orbitInsertion(idcentral, pl, vinf, h)

% DESCRIPTION
% This function computes the DV for circular orbit insertion around a flyby
% body. 
% 
% INPUT
% - idcentral : ID of the central body for the system (see constants.m)
% - pl        : ID of the flyby body (see constants.m)
% - vinf      : infinity velocity at the flyby body [km/s]
% - h         : altitude of the circular orbit [km]
%
% OUTPUT
% - dv : DV for circular orbit insertion [km/s]
% 
% -------------------------------------------------------------------------

% --> constants
[~, mum, ~, radm] = constants(idcentral, pl);

% --> compute DV for orbit insertion
rpip = radm + h;
dv   = sqrt( vinf.^2 + 2.*mum./rpip ) - sqrt( mum./rpip );

end