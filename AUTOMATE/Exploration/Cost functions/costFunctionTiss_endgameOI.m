function [dvtot, toftot, vinfa, dvs, tofs, alpha] = costFunctionTiss_endgameOI(LEGSnext, idcentral, pl, h)

% DESCRIPTION
% This is a cost function (user can specify its own) for Tisserand map
% exploration. It computes total DV and TOF of a moon tour plus the
% contribution to insert the spacecraft around a specified moon.
% 
% INPUT
% - LEGSnext : matrix containing the tours. Each row is a tour. Each tour
%              is made by 'next_nodes' rows (see generateVILTSall.m) one
%              after the other.
% - idcentral : ID of the central body (see constants.m)
% - pl        : ID of the flyby body (see constants.m)
% - h         : altitude of the circular orbit around the flyby body [km]
% 
% OUTPUT
% - dvtot  : column vector with total DV of the tour for each row of
%            LEGSnext, i.e., for each tour [km/s]
% - toftot : column vector with total TOF of the tour for each row of
%            LEGSnext, i.e., for each tour [days]
% - vinfa  : column vector with arrival infinity velocity at the last
%            encounter for each row of LEGSnext, i.e., for each tour [km/s]
% - dvs    : matrix with DVs for each leg of the tour. Each row contains
%            the DVs for each row of LEGSnext, i.e., for each tour [km/s]
% - tofs   : matrix with TOFs for each leg of the tour. Each row contains 
%           the TOFs for each row of LEGSnext, i.e., for each tour [km/s]
% - alpha  : column vector with arrival pump angle at the last encounter
%           for each row of LEGSnext, i.e., for each tour [rad]
%
% ------------------------------------------------------------------------- 

% --> extract the info
dvs    = LEGSnext(:,11:12:end-1);
tofs   = LEGSnext(:,12:12:end);
dvtot  = sum(dvs,2);
toftot = sum(tofs,2);
vinfa  = LEGSnext(:,end-2);
alpha  = LEGSnext(:,end-3);

% --> compute DV for orbit insertion and overall DV
dv     = orbitInsertion(idcentral, pl, vinfa, h);
dvtot  = dvtot + dv;

end
