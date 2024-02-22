function [LEGS, outputNext] = apply_MODP_outNext(outputNext)

% DESCRIPTION
% This function computes the Pareto front for tours encoded in a structure
% 'outputNext' as coming from outLineByLine.m. It also gives a matrix with
% different tours, where last two columns encode the overall accumulated DV
% and TOF for the tour.
%
% INPUT
% - outputNext : structure where each row is a moon tour from output
%                structure in input. It has the following fields
%                - LEGS : single row with a specific tour. Each tour 
%                is made by 'next_nodes' rows (see generateVILTSall.m) one
%                after the other.
%                - dvtot : total DV for the tour [km/s] (no orbit insertion
%                maoeuvre)
%                - toftot   : total time of flight for the tour [days]
%                - vinfa    : infinity velocity at last encounter [km/s]
%                - depNode  : 1x3 vector with departing node for the tour
%                (a node is made by ID of the flyby body (see constants.m),
%                pump angle [rad] and infinity velocity [km/s])
%                - lastNode : 1x3 vector with last node for the tour
%                (a node is made by ID of the flyby body (see constants.m),
%                pump angle [rad] and infinity velocity [km/s])
%                - nfb      : number of flybys for the tour
% 
% 
% OUTPUT
% - LEGS : matrix containing the tours. Each row is a tour. Each tour is
%          made by 'next_nodes' rows (see generateVILTSall.m) one after the
%          other. However, the last two columns encode overall
%          accumulated DV and TOF for the tour. Only the tours on that are
%          on Pareto front of DV and TOF from outputNext in input are
%          saved.
% - outputNext : same as in input but the number of tours is reduced to the
%                ones that are on Pareto front of DV and TOF.
% 
% -------------------------------------------------------------------------

% --> compute the Pareto front
outputNext = apply_MODP_outputNext(outputNext);

% --> extract the matrix with tours for the given phase
LEGS = zeros( length(outputNext), 12 );
for indou = 1:length(outputNext)

    dv = outputNext(indou).dvtot;
    dt = outputNext(indou).toftot;
    
    LEGS(indou,:)     = outputNext(indou).LEGS(:,end-11:end);
    LEGS(indou,11:12) = [ dv dt ];

end

end
