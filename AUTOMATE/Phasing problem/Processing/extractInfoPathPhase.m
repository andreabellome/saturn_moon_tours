function [path, seq, legs, infs, vinfs, transf, allowedgeom, tolDVleg, vinflevels] = ...
    extractInfoPathPhase(PATHph, indPhase)

% DESCRIPTION
% This function extracts information on a specific phase of a moon tour.
% This is used to generate database on the phasing problem scripts.
% 
% INPUT
% - PATHph : structure with a specific moon tour. Each row is a moon phase.
%            The structure has the following fields: 
%            - path : matrix with tour on specific phase. 
%            - dvPhase : DV total for the given phase [km/s]
%            - tofPhase : time of flight for the given phase [days]
%            - dvOI     : DV for orbit insertion only valid for the last
%            phase (see also orbitInsertion.m)
% - indPhase : index for selecting a moon phase, i.e., a row of PATHph
% 
% OUTPUT : 
% - path   : matrix with tour on specific phase. 
% - seq    : list of IDS of the flyby bodies in sequence (see constants.m)
% - legs   : Nx2 matrix with initial and final ID for the moons on each leg
% - infs   : Nx2 matrix with initial and final infinity velocities for the
%            moons on each leg [km/s]
% - vinfs  : infinity velocities at the moons [km/s]
% - transf : list with transfer options for the moon phase (11, 18, 81, 88)
%            = (II, IO, OI, OO) 
% - allowedgeom : list with allowed geometries for transfer options (11,
%                 18, 81, 88) = (II, IO, OI, OO) 
% - tolDVleg    : max DV on the phase [km/s]
% - vinflevels  : list of unique vinfs for the phase [km/s]
% 
% -------------------------------------------------------------------------

path      = PATHph(indPhase).path;

legs  = zeros(size(path,1)-1, 2);
vinfs = zeros(size(path,1)-1, 2);
for indp = 2:size(path,1)
    if indp == size(path,1)
        legs(indp-1,:) = [ path(indp,3) path(indp,1) ];
    else
        legs(indp-1,:)  = [ path(indp,1) path(indp,1) ];
    end
    vinfs(indp-1,:) = [ path(indp,8) path(indp,10) ];
end
seq         = [ legs(:,1)' legs(end,2)' ];
infs        = [ vinfs(:,1)' vinfs(end,2)' ];

if indPhase == 5 % --> Enceladus phase
    transf      = path(2:end,2:6);
else
    transf      = path(2:end-1,2:6);
end
allowedgeom = unique(transf(:,1))';
tolDVleg    = max(path(:,end-1));
if indPhase == 5 % --> Enceladus phase
    vinflevels  = unique([min(vinfs(:,1)), min(vinfs(:,1))-0.05:0.05:max(vinfs(:,2))+0.05, max(vinfs(:,1))]);
    vinflevels  = unique([ vinflevels, unique( [ vinfs(end,2) vinfs(end,2)-0.05:0.02:vinfs(end,2)+0.05 ] ) ]);
else
    vinflevels  = unique([min(vinfs(:,1)), min(vinfs(:,1))-0.05:0.05:max(vinfs(:,2))+0.05, max(vinfs(:,1))]);
end

end
