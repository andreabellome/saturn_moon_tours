function NNodes = wrap_parallel_vilts(resonances, vinf_dep, pl, INPUT, vinflevels)

% DESCRIPTION
% This function is used only if parallel = 1 in the wrap_generateVILTSall.m
% function. It computes database of VILTs at a given moon/planet.
% 
% INPUT
% - resonances : Nx2 matrix with Nx2 matrix with the following:
%               - resonances(:,1) : integer number of flyby body revolutions
%               - resonances(:,2) : integer number of spacecraft revolutions
% - vinf_dep   : infinity velocity before the VILT [km/s]
% - pl         : ID of the flyby body (see also constants.m)
% - INPUT      : structure with the following fields required by the
%                function generateVILTSall.m
% - vinflevels : 1xN vector with infinity velocities to compute the VILTs [km/s] 
%
% OUTPUT
% - NNodes : matrix encoding all the possible VILTs according to the
%            input. Each row is a transfer as in 'next_nodes' (see also
%            generateVILTSall.m)
%
% -------------------------------------------------------------------------

NNodes = zeros( 1e6, 12 );
indn   = 1;
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
NNodes = NNodes(~all(NNodes == 0, 2),:);

end
