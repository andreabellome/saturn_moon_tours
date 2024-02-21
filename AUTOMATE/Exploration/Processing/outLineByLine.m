function outputNext = outLineByLine(output)

% DESCRIPTION
% This function simply post-processes an output structure from
% exploreTisserandGraph.m and re-writes each moon tour line by line in
% another structure.
%
% INPUT
% - output : structure where each rows contains tours with same number of
%            flbys. It has the following fields: 
%            - LEGS : matrix containing the tours. Each row is a tour. Each tour 
%              is made by 'next_nodes' rows (see generateVILTSall.m) one
%              after the other.
%            - dvtot : column vector containing the overall DV for the
%            tours [km/s] 
%            - toftot : column vector containing the overall TOF for the
%            tours [days]
%            - vinfa : column vector containing the arrival infinity
%            velocity for the tours [km/s]
% 
% OUTPUT
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
% -------------------------------------------------------------------------

dvtot = cell2mat({output.dvtot}');
n     = length(dvtot);

ind        = 1;
outputNext = struct( 'LEGS', cell(1,n), ...
    'dvtot', cell(1,n), 'toftot', cell(1,n), ...
    'vinfa', cell(1,n), 'lastNode', cell(1,n), 'nfb', cell(1,n) );
for indou = 1:length(output)
    
    LEGS   = output(indou).LEGS;
    dvtot  = output(indou).dvtot;
    toftot = output(indou).toftot;
    vinfa  = output(indou).vinfa;
    for indl = 1:size(LEGS,1)
        
        outputNext(ind).LEGS     = LEGS(indl,:);
        outputNext(ind).dvtot    = dvtot(indl,:);
        outputNext(ind).toftot   = toftot(indl,:);
        outputNext(ind).vinfa    = vinfa(indl,:);
        outputNext(ind).depNode  = [ LEGS(indl,1) LEGS(indl,9:10) ];
        outputNext(ind).lastNode = [ LEGS(indl,end-11) LEGS(indl,end-3:end-2) ];
        outputNext(ind).nfb      = size(LEGS(indl,:),2);

        ind = ind + 1;

    end

end

end