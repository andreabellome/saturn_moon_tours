function outputNext = pruneOutputNext(outputNext, INPUT)

% DESCRIPTION
% This function prunes a structure 'outputNext' as from outLineByLine.m
% with respect to total DV and TOF.
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
% - INPUT : structure with the following mandatory fields:
%           - tolDVmax     : max. DV for the whole tour [km/s]
%           - tofdmax      : max. TOF for the whole tour [days]
%
% OUTPUT
% - outputNext : same as in input but the number of rows is reduced to
%                those tours satisfying the constraints.
%
% -------------------------------------------------------------------------

if ~isempty(outputNext)
    outputNext( [ outputNext.dvtot ]' > INPUT.tolDVmax) = [];
end

if ~isempty(outputNext)
    outputNext( [ outputNext.toftot ]' > INPUT.tofdmax ) = [];
end

dvtot    = cell2mat({outputNext.dvtot}');
toftot   = cell2mat({outputNext.toftot}');

matso      = sortrows( [dvtot toftot [1:1:length(dvtot)]'], [1, 2] );
outputNext = outputNext(matso(:,end));

end