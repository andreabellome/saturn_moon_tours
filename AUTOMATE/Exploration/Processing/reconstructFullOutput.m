function outputFor = reconstructFullOutput(outputNext, output2, INPUT)

% DESCRIPTION
% This function is used to link two structures: 1) is for the overall tour
% (from the intial node to current one); 2) is for the tour on a specific
% phase (starting at ending nodes of the previous structure).
%
% INPUT
% - outputNext : structure where each row is a moon tour. It has the
%                following fields:
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
% - output2 : output of exploreTisserandGraph.m. This is  a structure where
%            each rows contains tours with same number of flbys. It has the
%            following fields:  
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
% - outputFor : same as 'outputNext' in input but it encodes the overall
%               tour, i.e., merging 'outputNext' and 'output2' accordingly,
%               i.e., the last node of outputNext shoud be the first one of
%               output2.
% 
% -------------------------------------------------------------------------

outputNext2 = outLineByLine(output2);

depNode     = cell2mat({outputNext2.depNode}');
lastNode    = cell2mat({outputNext.lastNode}');

ind = 1;
n   = 300e3;
outputFor = struct( 'LEGS', cell(1,n), 'dvtot', cell(1,n), 'toftot', cell(1,n), ...
    'vinfa', cell(1,n), 'lastNode', cell(1,n), 'nfb', cell(1,n), 'depNode', cell(1,n) );
for indd = 1:size(depNode,1)

    indd/size(depNode,1)*100;

    dnode = depNode(indd,:);

    indxs = find( lastNode(:,1) == dnode(:,1) & ...
                  lastNode(:,2) == dnode(:,2) & ...
                  lastNode(:,3) == dnode(:,3) );
    
    for inds = 1:length(indxs)
    
        legsPrev         = outputNext(indxs(inds)).LEGS;
        legsNext         = outputNext2(indd).LEGS;
        legsNext(:,1:12) = [];

        legsNew = [ legsPrev legsNext ];
        [dvtot, toftot, vinfa] = costFunctionTiss(legsNew);

        if dvtot <= INPUT.tolDVmax && toftot <= INPUT.tofdmax

            outputFor(ind).LEGS     = legsNew;
            outputFor(ind).dvtot    = dvtot;
            outputFor(ind).toftot   = toftot;
            outputFor(ind).vinfa    = vinfa;
            outputFor(ind).lastNode = [ legsNew(1,end-11) legsNew(1,end-3:end-2) ];
            outputFor(ind).nfb      = size(legsNew,2);
            outputFor(ind).depNode  = [ legsNew(1,1) legsNew(1,9:10) ];

        end

        ind = ind + 1;

    end

end

emptyIndex            = find(arrayfun(@(outputFor) isempty(outputFor.LEGS),outputFor));
outputFor(emptyIndex) = [];

dvtot     = cell2mat({outputFor.dvtot}');
toftot    = cell2mat({outputFor.toftot}');
matso     = sortrows( [dvtot toftot [1:1:length(dvtot)]' ], [1 2] );
outputFor = outputFor(matso(:,end));

end
