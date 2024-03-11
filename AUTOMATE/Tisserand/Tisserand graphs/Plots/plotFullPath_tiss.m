function plotFullPath_tiss(PATHph, INPUT)

% DESCRIPTION
% This function plots moon tours on Tisserand graph. Different plots are
% generated for each phase of the tour.
% 
% INPUT
% - PATHph : structure with a specific moon tour. Each row is a moon phase.
%            The structure has the following fields: 
%            - path : matrix with tour on specific phase. 
%            - dvPhase : DV total for the given phase [km/s]
%            - tofPhase : time of flight for the given phase [days]
%            - dvOI     : DV for orbit insertion only valid for the last
%            phase (see also orbitInsertion.m)
% - INPUT : structure with the following mandatory fields required:
%              - vinflevels : grid of infinity velocities [km/s]
%              - idcentral  : ID of the central body (see constants.m)
% 
% OUTPUT
% //
% 
% -------------------------------------------------------------------------

% --> plot Tisserand trajectory for each moon phase
for indph = 1:length(PATHph)
    if size(PATHph(indph).path,1) > 1
        plotPath_tiss(PATHph(indph).path, INPUT);
    end
end

end