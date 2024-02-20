function LEGS = canYouReach11Res(LEGS, INPUT)

% DESCRIPTION
% This function prunes all the VILTs that are not outboubd-outbound except
% those that can reach the 1:1 resonant transfer. The rationale behind this
% criterion can be found in:
% Takubo, Landau, Anderson, 'Automated Tour Design in the Saturnian System' 
% (2022), https://arxiv.org/abs/2210.14996
% 
% INPUT
% - LEGS : matrix containing the tours. Each row is a tour. Each tour
%              is made by 'next_nodes' rows (see generateVILTSall.m) one
%              after the other.
% - INPUT : structure with the following mandatory fields:
%           - DELTA_MAX : matrix with maximum deflections (see also
%           findDeltaMaxPlanets.m)
%           - LEGSvilts : matrix with database of VILTs. Each row is a
%           VILT as in 'next_nodes' (see also generateVILTSall.m)
% 
% OUTPUT
% - LEGS : same as in input but the number of rows (i.e., tours) is
%              limited by the constraints applied
%
% -------------------------------------------------------------------------

if ~isempty(LEGS)

    % --> extract max. deflections database
    DELTA_MAX   = INPUT.DELTA_MAX;
    toldegreesV = 0;

    % --> extract the list of arrival nodes
    lastNode    = [ LEGS(:,end-11) LEGS(:,end-3:end-2) ];
    typeLast    = LEGS(:,end-10);
    
    % --> extract the 1:1 VILTs
    LEGSvilts11 = INPUT.LEGSvilts( INPUT.LEGSvilts(:,1) == lastNode(1,1) & ...
                                   INPUT.LEGSvilts(:,4) == 1 & ...
                                   INPUT.LEGSvilts(:,5) == 1 , : );
    
    INDnotReach = zeros( size(lastNode,1),1 );
    for indl = 1:size(lastNode,1)
        
        depNode = lastNode(indl,:);
        type    = typeLast(indl,:);

        deltaMax   = DELTA_MAX(DELTA_MAX(:,1) == depNode(1) & ...
                               abs(DELTA_MAX(:,2) - depNode(3))<1e-7, 3);
        deltaMax = deltaMax(1);
    
        legtosave = LEGSvilts11(LEGSvilts11(:,1) == depNode(1) & ...
                            abs(LEGSvilts11(:,8) - depNode(3))<1e-7, :);
        
        if ~isempty(legtosave) % --> se LEGSvilts11 NON è vuoto --> controlla che raggiungi 1:1
    
            diffalpav    = abs(legtosave(:,7) - depNode(2));
            diffalpadmax = - diffalpav + deltaMax;
            indxsa       = find(diffalpadmax >= 0 | (diffalpadmax < 0 & (abs(diffalpadmax)) <= toldegreesV), 1); % --> to save!

            if isempty(indxsa) % --> se non raggiungi 1:1
    
                % --> then you cannot reach 1:1 resonance
                if type == 11 || type == 18 || type == 81

                    % --> eliminate those that are not OO
                    INDnotReach(indl,:) = indl;

                end
    
            end

%         else % --> se LEGSvilts11 è vuoto --> comunque elimina tutto tranne le 88
%             
%             if type == 11 || type == 18 || type == 81
% 
%                 % --> eliminate those that are not OO
%                 INDnotReach(indl,:) = indl;
%                 
%             end

        end
    
    end
    INDnotReach(INDnotReach==0,:) = [];
    
    LEGS(INDnotReach,:) = [];

end

end
