function [LEGSnext, legstosave] = checkArrived(LEGSnext, INPUT)

% DESCRIPTION
% This function is used to check if a tour on Tisserand graph should be
% stopped. This is triggered either when the arrival body is reached (with
% infinity velocity less than a user-defined tolerance), or, in the case of
% endgame problem, when the infinity velocity is less than a user-defined
% tolerance. When a tour is considered stopped, it is removed and stored in
% another matrix.
% 
% INPUT
% - LEGSnext : matrix containing the tours. Each row is a tour. Each tour
%              is made by 'next_nodes' rows (see generateVILTSall.m) one
%              after the other.
% - INPUT    : structure with the following mandatory fields:
%              - vinfArrOPTS : 1x2 vector with min. and max. arrival
%              infinity velocities [km/s]
%              - pldep    : ID of the departing flyby body (see constants.m)
%              - plarr    : ID of the arrival flyby body (see constants.m)
% 
% OUTPUT
% - LEGSnext : same as in input, but the number of rows (i.e., tours) is
%              limited by the fact that some tours might have arrived at
%              destination, and thus are removed
% - legstosave : same as LEGSnext, but it contains the tours that are
%                considered arrived to destination.
%
% -------------------------------------------------------------------------

if INPUT.pldep == INPUT.plarr && ~isempty(LEGSnext) % --> ENDGAME

    indxs = find(LEGSnext(:,end-2) <= INPUT.vinfArrOPTS(2));

    if ~isempty(indxs)
        legstosave        = LEGSnext(indxs,:);
        LEGSnext(indxs,:) = [];
        disp('Solutions found!');
    else
        legstosave = [];
    end

else

    if ~isempty(LEGSnext)
        
        indxs = find(LEGSnext(:,end-11) == INPUT.plarr);
        
        if ~isempty(indxs)
            legstosave        = LEGSnext(indxs,:);
            LEGSnext(indxs,:) = [];
            
            % --> prune w.r.t. arrival infinity velocity bounds
            legstosave(legstosave(:,end-2) > INPUT.vinfArrOPTS(2),:) = [];
            if ~isempty(legstosave)
                disp('Solutions found!');
            end
        else
            legstosave = [];
        end
    
    else
        legstosave = [];
    end

end

end