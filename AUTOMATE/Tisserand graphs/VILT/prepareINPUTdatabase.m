function INPUT = prepareINPUTdatabase(idcentral, allowed_geometries, ...
    exterior_interior, tolDV_leg, vinfMin, vinfMax, stepSize, tofDSM, tofFB)

% DESCRIPTION
% This is a wrapper function for setting up the input required for
% generating VILT database, i.e., for launching the function wrap_generateVILTSall.m
% 
% INPUT
% - idcentral          : ID of the central body (see constants.m)
% - allowed_geometries : 1xN vector with allowed geometries for
%                        the encounters (88, 81, 18, 11), i.e., OO/OI/IO/II
% - exterior_interior  : 1x2 vector with +1 for EXTERNAL, -1 for INTERNAL
%                        VILT transfers
% - tolDV_leg          : max. DV for the VILT [km/s]
% - vinfMin            : min. infinity velocity [km/s]
% - vinfMax            : max. infinity velocity [km/s]
% - stepSize           : step size for infinity velocities [km/s]
% - tofDSM             : min. time of flight between a flyby and a DSM
% - tofFB              : min. time of flight between two flybys
%
% OUTPUT
% - INPUT : structure with the following fields:
%           - idcentral          : same as in input
%           - allowed_geometries : same as in input
%           - exterior_interior  : same as in input
%           - tolDV_leg          : same as in input
%           - vinflevels         : vector with infinity velocity levels for
%                                  VILTs computation [km/s]
%           - tofDSM             : same as in input
%           - tofFB              : same as in input
% 
% -------------------------------------------------------------------------

INPUT.idcentral          = idcentral;
INPUT.allowed_geometries = allowed_geometries;    % --> allowed geometries for VILT
INPUT.exterior_interior  = exterior_interior;     % --> +1 is exterior VILT, -1 is interior VILT
INPUT.tolDV_leg          = tolDV_leg;             % --> max. DSM magnitude (km/s)
INPUT.vinflevels         = unique([vinfMin vinfMax [vinfMin:stepSize:vinfMax]])';
INPUT.tofDSM             = tofDSM; % --> max. days between flyby and manoeuvre
INPUT.tofFB              = tofFB;  % --> max. days between two flybys

end
