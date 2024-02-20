function LEGSnext = applyPruning_tiss(LEGSnext, INPUT)

% DESCRIPTION
% Wrapper function for pruning criteria for Tisserand exploration. The
% following pruning are applied:
% - max. DV
% - max. TOF
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
%              - costFunction : cost function (see for
%              example costFunctionTiss.m)
%              - tolDVmax : max DV for the tour [km/s]
%              - tofdmax  : max TOF for the tour [days]
%              - decrease : +1 if one goes inside the system
%              - plarr    : ID of the arrival flyby body (see constants.m)
% 
% OUTPUT
% - LEGSnext : same as in input, but the number of rows (i.e., tours) is
%              limited by the constraints applied
%
% -------------------------------------------------------------------------

% --> start: prune w.r.t. DVtot and TOFtot
if ~isempty(LEGSnext)

    % --> compute the overall DV for the tour
    dvtot = costFunctionTiss(LEGSnext);
    LEGSnext(dvtot > INPUT.tolDVmax,:) = [];

    % --> compute the overall TOF for the tour
    if ~isempty(LEGSnext)
        [~, toftot] = costFunctionTiss(LEGSnext);
        LEGSnext(toftot > INPUT.tofdmax,:) = [];
    end

end
% --> end: prune w.r.t. DVtot and TOFtot

% --> start: prune those that decrease the ALPHA (if decrease == 1 --> you go in)
if ~isempty(LEGSnext)
    if INPUT.decrease == 1 % --> you go IN the Saturn System
        indxs = find(LEGSnext(:,end-11) ~= INPUT.plarr & ...
            LEGSnext(:,end-5) <= LEGSnext(:,end-15) );
        LEGSnext(indxs,:) = [];
        
        if ~isempty(LEGSnext)
            indxs = find( LEGSnext(:,end-11) ~= INPUT.plarr & LEGSnext(:,end-1) < 1e-6 & ...
                LEGSnext(:,end-5) - LEGSnext(:,end-15) < 1e-6 );
            LEGSnext(indxs,:) = [];
        end


    else % --> you go OUT the Saturn System
        indxs = find(LEGSnext(:,end-11) ~= INPUT.plarr & ...
            LEGSnext(:,end-5) >= LEGSnext(:,end-15) );
        LEGSnext(indxs,:) = [];
        
        if ~isempty(LEGSnext)
            indxs = find( LEGSnext(:,end-11) ~= INPUT.plarr & LEGSnext(:,end-1) < 1e-6 & ...
                LEGSnext(:,end-5) - LEGSnext(:,end-15) > 1e-6 );
            LEGSnext(indxs,:) = [];
        end

    end
end
% --> end: prune those that decrease the ALPHA (if decrease == 1 --> you go in)

% --> start: prune those that decrease the VINF but only on VILTs (if decrease == 1 --> you go in)
if ~isempty(LEGSnext)
    if INPUT.decrease == 1
        indxs = find(LEGSnext(:,end-11) ~= INPUT.plarr & ...
            LEGSnext(:,end-1) >1e-6 & ... % --> only applied on VILTs
            LEGSnext(:,end-4) < LEGSnext(:,end-2) );
        LEGSnext(indxs,:) = [];
    else % --> you go OUT the Saturn System
        indxs = find(LEGSnext(:,end-11) ~= INPUT.plarr & ...
            LEGSnext(:,end-1) >1e-6 & ... % --> only applied on VILTs
            LEGSnext(:,end-4) > LEGSnext(:,end-2) );
        LEGSnext(indxs,:) = [];
    end
end
% --> end: prune those that decrease the VINF but only on VILTs (if decrease == 1 --> you go in)

end
