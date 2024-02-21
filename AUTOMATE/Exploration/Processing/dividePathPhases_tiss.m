function PATHph = dividePathPhases_tiss(path, INPUT)

% DESCRIPTION
% This function is a post-process of a given tour.It divides the tour in
% different moon phases and it saves it in a structure.
% 
% INPUT
% - path  : matrix containing the tour. Each row is made by 'next_nodes'
%           rows (see generateVILTSall.m).
% - INPUT : structure with the following mandatory fields:
%           - h         : altitude of the circular orbit for insertion
%           manoeuvre [km] 
%           - idcentral : ID of the central body (see also constants.m)
% 
% OUTPUT
% - PATHph : structure where each row is a tour for a different moon phase.
%            It has the following fields:
%            - path : matrix with tour on specific phase. 
%            - dvPhase : DV total for the given phase [km/s]
%            - tofPhase : time of flight for the given phase [days]
%            - dvOI     : DV for orbit insertion only valid for the last
%            phase (see also orbitInsertion.m)
% 
% -------------------------------------------------------------------------

% --> divide the path by phases
ids = unique( path(:,1), 'stable' );

PATHph = struct( 'path', cell(1,length(ids)), 'dvPhase', cell(1,length(ids)),...
    'tofPhase', cell(1,length(ids)), 'dvOI', cell(1,length(ids)) );
for indsol = 1:length(ids)
    indxs     = find(path(:,1) == ids(indsol));
    if indsol == length(ids)
        pathPhase = [ path(indxs,:) ];
    else
        pathPhase = [ path(indxs,:); path(indxs(end)+1,:) ];
    end
    dvPhase                 = sum( pathPhase(2:end,end-1) );
    tofPhase                = sum( pathPhase(2:end,end) );
    PATHph(indsol).path     = pathPhase;
    PATHph(indsol).dvPhase  = dvPhase;
    PATHph(indsol).tofPhase = tofPhase;
end

if nargin == 1
    PATHph(end).dvOI = 0;
else
    % --> compute orbit insertion manoeuvre for the last phase
    pl   = PATHph(end).path(end,1);
    vinf = PATHph(end).path(end,10);
    PATHph(end).dvOI = orbitInsertion(INPUT.idcentral, pl, vinf, INPUT.h);
end

end