function LEGSvilts = wrap_vilt_db_generation( IDS, vinfMinMax, stepSize, INPUT, tofDSM, tofFB, parallel )

% DESCRIPTION
% Find a database of VILTs. 
%
% INPUT
% - IDS          : IDs of the central bodies (see constants.m)
% - vinfMinMax   : Nx2 with min. and max. infinity velocities at the flyby
%                  bodies (N is the lenght of IDS and equal to the number
%                  of flyby bodies)
% - stepSize     : step-size for the infinity velocity contours.
% - INPUT        : structure with the following fields:
%                  - idcentral : ID of the central body (see constants.m)
%                  - allowed_geometries : 1xN vector with allowed
%                  geometries for  the encounters (88, 81, 18, 11), i.e.,
%                  OO/OI/IO/II 
%                  - exterior_interior  : 1x2 vector with (+1) for EXTERNAL,
%                  (-1) for INTERNAL VILT transfers
%                  -  tolDV_leg : max. DV for the VILT [km/s]
% - tofDSM             : min. time of flight between a flyby and a DSM (0
%                       by default)
% - tofFB              : min. time of flight between two flybys (0 by
%                       default)
% - parallel      : boolean to select parallel computing (true by default)
% 
% OUTPUT
% - LEGSvilts : matrix encoding all the possible VILTs according to the
%               input. Each row is a transfer with the following
%               information:
%               - next_nodes(:,1) : ID of the flyby body (see
%                 centralBody_planet.m)
%               - next_nodes(:,2:6) : S vector of the VILT anatomy (see
%                 wrap_VILT.m)
%               - next_nodes(:,7:8) : pump angle [rad] and infinity
%               velocity [km/s] at the object encounter before the
%               manoeuvre
%               - next_nodes(:,9:10) : pump angle [rad] and infinity
%               velocity [km/s] at the object encounter after the manoeuvre
%               - next_nodes(:,11:12) : DV [km/s] and time of flight [days]
%                for the transfer
%
% -------------------------------------------------------------------------

idcentral           = INPUT.idcentral;
allowed_geometries  = INPUT.allowed_geometries;
exterior_interior   = INPUT.exterior_interior;
tolDV_leg           = INPUT.tolDV_leg;

if nargin == 4
    tofDSM      = 0;
    tofFB       = 0;
    parallel    = true;
elseif nargin == 5
    tofFB       = 0;
    parallel    = true;
elseif nargin == 6
    parallel    = true;
end

if parallel

    STRUC = struct( 'next_nodes', cell(1,length(IDS)) );
    parfor ind = 1:length(IDS)
        
        ind
    
	    % --> this line simply re-writes the input parameters accordingly
        inpt(ind) = prepareINPUTdatabase(idcentral, allowed_geometries, ...
            exterior_interior, tolDV_leg, vinfMinMax(ind,1), vinfMinMax(ind,2), ...
            stepSize, tofDSM, tofFB);
    
        pl                    = IDS(ind);
        next_nodes            = wrap_generateVILTSall(pl, inpt(ind));
        STRUC(ind).next_nodes = next_nodes;
    
    end
    LEGSvilts = cell2mat({STRUC.next_nodes}');

else

    STRUC = struct( 'next_nodes', cell(1,length(IDS)) );
    for ind = 1:length(IDS)
        
        ind
    
	    % --> this line simply re-writes the input parameters accordingly
        inpt(ind) = prepareINPUTdatabase(idcentral, allowed_geometries, ...
            exterior_interior, tolDV_leg, vinfMinMax(ind,1), vinfMinMax(ind,2), ...
            stepSize, tofDSM, tofFB);
    
        pl                    = IDS(ind);
        next_nodes            = wrap_generateVILTSall(pl, inpt(ind));
        STRUC(ind).next_nodes = next_nodes;
    
    end
    LEGSvilts = cell2mat({STRUC.next_nodes}');
    
end

end
