function [outputNext, LEGS, depNn, depNnU] = apply_MODP_outputNext(outputNext)

% DESCRIPTION
% This function computes the Pareto front for tours encoded in a structure
% 'outputNext' as coming from outLineByLine.m.
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
% OUTPUT
% - outputNext : same as in input but the number of tours is reduced to the
%                ones that are on Pareto front of DV and TOF.
% - LEGS       : not used. It will be removed in later updates.
% - depNn      : not used. It will be removed in later updates.
% - depNnU     : not used. It will be removed in later updates.
%
% -------------------------------------------------------------------------

depNn         = cell2mat({outputNext.lastNode}');
[depNnU, IDC] = unique( depNn, 'rows', 'stable'  );

ind = 1;
for inddn = 1:size(depNnU,1)

    indxs = find( depNn(:,1) == depNnU(inddn,1) & ...
        depNn(:,2) == depNnU(inddn,2) & ...
        depNn(:,3) == depNnU(inddn,3));

    OUT    = outputNext(indxs);
    dvtot  = cell2mat({OUT.dvtot}');
    toftot = cell2mat({OUT.toftot}');

    pf = paretoFront_MODP( [ dvtot toftot ] );

    ltos = OUT(pf(:,end));
    outtosave(ind:ind-1+length(ltos)) = ltos;
    ind = ind + length(ltos);

end
outputNext = outtosave;

dvtot      = cell2mat({outputNext.dvtot}');
toftot     = cell2mat({outputNext.toftot}');
matso      = sortrows( [dvtot toftot [1:1:length(dvtot)]' ], [1 2] );
outputNext = outputNext(matso(:,end));

depNn         = cell2mat({outputNext.lastNode}');
[depNnU, IDC] = unique( depNn, 'rows', 'stable'  );
LEGS          = depNode2depRows(depNnU);

end
