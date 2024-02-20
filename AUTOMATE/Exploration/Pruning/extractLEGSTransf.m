function LEGSnext = extractLEGSTransf(LEGSnext, seqTransfer, INPUT)

% DESCRIPTION
% This function extrtacts user-defined VILTs from available database. In
% particular, one specifies a tour, and a leg. Only the tours arriving at
% the specified leg are saved, BUT only considering the resonant ratio
% (N:M).
%
% INPUT
% - LEGSnext : matrix containing the tours. Each row is a tour. Each tour
%              is made by 'next_nodes' rows (see generateVILTSall.m) one
%              after the other.
% - seqTransfer : matrix containing a specific tour. Each row is a VILT.
%                 Each row is taken from 'next_nodes' rows (see
%                 generateVILTSall.m).
% - INPUT       : structure with the following mandatory fields:
%                 - indl    : ID of the current leg
%                 - pldep   : ID of the departing flyby body (see
%                 constants.m) 
%                 - plarr   : ID of the arrival flyby body (see
%                 constants.m) 
%                 - maxlegs : max. number of flyby legs
% 
% OUTPUT 
% - LEGSnext : same as in input but only tours with last leg equal to
%              seqTransfer(:,3:4) is taken.

if ~isempty(seqTransfer)

    indl = INPUT.indl;
    
%     % --> only save those that are specified in the seqTransfer
%     if ~isempty(LEGSnext)
%         if ~isempty(seqTransfer)
%             if INPUT.pldep == INPUT.plarr
%                 diff     = vecnorm( [abs( LEGSnext(:,end-10:end-6) - seqTransfer(indl,:) )]' )';
%                 LEGSnext = LEGSnext(diff == 0,:);
%             else
%                 if indl < INPUT.maxlegs
%                     diff     = vecnorm( [abs( LEGSnext(:,end-10:end-6) - seqTransfer(indl,:) )]' )';
%                     LEGSnext = LEGSnext(diff == 0,:);
%                 end
%             end
%         end
%     end
    
    % --> only consider the resonant ratio (N:M)
    seqTransfer = seqTransfer(:,3:4);
    if ~isempty(LEGSnext)
        if ~isempty(seqTransfer)
            if INPUT.pldep == INPUT.plarr
                diff     = vecnorm( [abs( LEGSnext(:,end-8:end-7) - seqTransfer(indl,:) )]' )';
                LEGSnext = LEGSnext(diff == 0,:);
            else
                if indl < INPUT.maxlegs
                    diff     = vecnorm( [abs( LEGSnext(:,end-8:end-7) - seqTransfer(indl,:) )]' )';
                    LEGSnext = LEGSnext(diff == 0,:);
                end
            end
        end
    end

end

end