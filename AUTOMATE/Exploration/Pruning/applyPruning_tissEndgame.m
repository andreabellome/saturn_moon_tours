function [LEGSnext] = applyPruning_tissEndgame(LEGSnext, INPUT)

% DESCRIPTION
% Wrapper function for pruning criteria for Tisserand exploration. This
% function is similar to applyPruning_tiss.m, but this only works when the
% departing planet and arrival planet are the same, e.g., on and endgame
% problem. The following constraints are applied:
% - if going 'inside' the system (e.g., from Titan to Enceladus), only the
% tours increasing the pump angle are kept (the opposite occurs if one goes 
% outside the system)
% - if going 'inside' the system (e.g., from Titan to Enceladus), only the
% tours decreasing the infinity velocity are kept (the opposite occurs if
% one goes outside the system) 
% 
% INPUT
% - LEGSnext : matrix containing the tours. Each row is a tour. Each tour
%              is made by 'next_nodes' rows (see generateVILTSall.m) one
%              after the other.
% - INPUT    : structure with the following mandatory fields:
%              - costFunctionTiss : cost function (see for
%              example costFunctionTiss.m)
%              - decrease : +1 if one goes inside the system
%              - pldep    : ID of the departing flyby body (see constants.m)
%              - plarr    : ID of the arrival flyby body (see constants.m)
% 
% OUTPUT
% - LEGSnext : same as in input, but the number of rows (i.e., tours) is
%              limited by the constraints applied
%
% -------------------------------------------------------------------------

if INPUT.idcentral == 6

    if INPUT.pldep == INPUT.plarr % --> only applied in the ENDGAME

        % --> start: reduce/increase the vinf
        if ~isempty(LEGSnext)
            if INPUT.decrease == 1 % --> you want to go IN --> reduce the VINF
                indxs = find( LEGSnext(:,end-1) >1e-6 & ... % --> only applied on VILTs
                              LEGSnext(:,end-4) < LEGSnext(:,end-2) );
                LEGSnext(indxs,:) = [];
            else % --> you want to go OUT --> increase the VINF
                indxs = find( LEGSnext(:,end-1) >1e-6 & ... % --> only applied on VILTs
                              LEGSnext(:,end-4) > LEGSnext(:,end-2) );
                LEGSnext(indxs,:) = [];
            end
        end
        % --> end: reduce/increase the vinf

        % --> start: reduce/increase the alpha
        if ~isempty(LEGSnext)
            if INPUT.decrease == 1 % --> you want to go IN --> reduce the ALPHA
                indxs = find( LEGSnext(:,end-1) < 1e-6 &...
                              LEGSnext(:,end-5) - LEGSnext(:,end-15) < 1e-6 );
                LEGSnext(indxs,:) = [];
            else % --> you want to go OUT --> increase the ALPHA
                indxs = find( LEGSnext(:,end-1) < 1e-6 &...
                              LEGSnext(:,end-5) - LEGSnext(:,end-15) > 1e-6 );
                LEGSnext(indxs,:) = [];
            end
        end
        % --> end: reduce/increase the alpha

    end

end

end