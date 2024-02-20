function depRow = depNode2depRows(depNode)

% DESCRIPTION
% This function is used only for generating the initial legs for a
% Tisserand exploration.
% 
% INPUT
% - depNode : 1x3 vector with starting node for the tour.
%             - depNode(1) is the ID of the flyby body (see constants.m)
%             - depNode(2) is the pump angle [rad]
%             - depNode(3) is the infinity velocity [km/s]
% 
% OUTPUT
% - depRow : matrix where each row is similar to 'next_nodes' rows (see
%            generateVILTSall.m), but the info on N:M(L),kei are zero.
%
% -------------------------------------------------------------------------

if ~isempty(depNode)

    struc = struct( 'depRow', cell(1,size(depNode,1)) );
    for indep = 1:size(depNode,1)
        
        depRow           = zeros(2,12);
        depRow(1:2,1)    = depNode(indep,1);
        depRow(1:2,9:10) = depNode(indep,2:3).*ones(2,2);
        depRow(1,2)      = 88;
        depRow(2,2)      = 11;
    
        struc(indep).depRow = depRow;
    
    end
    depRow = cell2mat({struc.depRow}');

end

end