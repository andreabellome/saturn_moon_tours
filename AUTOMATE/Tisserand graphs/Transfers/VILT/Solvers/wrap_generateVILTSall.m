function [NNodes] = wrap_generateVILTSall(pl, INPUT, resonances, parallel)

% DESCRIPTION
% This function is a wrapper for computing database of VILTs at a given
% moon/planet.
% 
% INPUT
% - pl         : ID of the flyby body (see also constants.m)
% - INPUT      : structure with the following fields required by the
%                function generateVILTSall.m
% - resonances : Nx2 matrix with Nx2 matrix with the following:
%               - resonances(:,1) : integer number of flyby body revolutions
%               - resonances(:,2) : integer number of spacecraft revolutions
%               this is an optional input, if not included, then
%               resonanceList.m is used.
% - parallel   : this is an additional option for parallel computing, with
%                respect to the infinity velocity levels.
%               - parallel = 1 for parallel computing
%               - parallel = 0 for non parallel computing
%               If not passed as input, parallel = 0 is assumed.
%                
% OUTPUT 
% - NNodes : matrix encoding all the possible VILTs according to the
%            input. Each row is a transfer as in 'next_nodes' (see also
%            generateVILTSall.m)
%
% -------------------------------------------------------------------------

if nargin == 2 % --> if not specified, use the list
    resonances = resonanceList(pl, INPUT.idcentral);
    parallel   = 0;
elseif nargin == 3
    if isempty(parallel)
        parallel = 0;
    end
end
vinflevels = INPUT.vinflevels;

if parallel == 0

    NNodes = zeros( 1e6, 12 );
    indn   = 1;
    for indv = 1:length(vinflevels)
    
        indv/length(vinflevels)*100;
    
        vinf_dep = vinflevels(indv);
    
        for indr = 1:size(resonances,1)
            res        = resonances(indr,:);
            next_nodes = generateVILTSall(res, vinf_dep, pl, INPUT);
            if ~isempty(next_nodes)
                vinfnn  = next_nodes(:,10);
                for indvinfnn = 1:length(vinfnn)
                    diffv             = abs(vinflevels - vinfnn(indvinfnn));
                    [~,row]           = min(diffv); 
                    vinfnn(indvinfnn) = vinflevels(row);
                end
                next_nodes(:,10) = vinfnn;
            end
            NNodes(indn:indn-1+size(next_nodes,1),:) = next_nodes;
            indn = indn + size(next_nodes,1);
        end
    
    end
    NNodes = NNodes(~all(NNodes == 0, 2),:);   % --> eliminate rows all equal to zero

elseif parallel == 1

    parfor indv = 1:length(vinflevels)

        vinf_dep = vinflevels(indv);

        STRUC(indv).NNodes = wrap_parallel_vilts(resonances, vinf_dep, pl, INPUT, vinflevels);

    end
    NNodes = cell2mat({STRUC.NNodes}');
    
end

end
