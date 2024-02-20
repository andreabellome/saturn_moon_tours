function [next_nodes] = generateVILTSall(res, vinf_dep, pl, INPUT)

% DESCRIPTION
% This function generates all the possible VILTs manoeuvres starting from a
% given infinity velocity, a resonant ratio, and depending upon INPUT
% structure. 
% 
% INPUT
% - res      : 1x2 vector with N:M values (N: flyby body integer
%              revolutions, M: spacecraft integer revolutions)
% - vinf_dep : infinity velocity before the VILT [km/s]
% - pl       : ID of the flyby body (see also constants.m)
% - INPUT    : structure with the following fields required
%              - idcentral : ID of the central body (see
%              centralBody_planet.m)
%              - vinflevels : 1xN vector with infinity velocities to
%              compute the VILTs [km/s]
%              - allowed_geometries: 1xN vector with allowed geometries for
%              the encounters OO/OI/IO/II (88, 81, 18, 11)
%              - exterior_interior: 1xN vector with +1/-1 for DSM position
%              information (see wrap_VILT.m)
%              - tolDV_leg: tolerance over the DV of the VILT [km/s]
%              - tofFB: tolerance over the minimum time of flight between
%              two successive flybys [days]
%              - tofDSM: tolerance over the minimum time of flight between
%              a flyby and a DSM [days]
%             
% OUTPUT
% - next_nodes : matrix encoding all the possible VILTs according to the
%               input. Each row is a transfer with the following
%               information:
%               - next_nodes(:,1) : ID of the flyby body (see
%                 centralBody_planet.m)
%               - next_nodes(:,2:6) : S vector of the VILT anatomy (see
%                 wrap_VILT.m)
%               - next_nodes(:,7:8) : pump angle [rad] and infinity
%               velocity [km/s] at the object encounter before the
%               manoeuvre
%               - next_nodes(:,9:10) : pump angle [rad] and infinity
%               velocity [km/s] at the object encounter after the manoeuvre
%               - next_nodes(:,11:12) : DV [km/s] and time of flight [days]
%                for the transfer
% 
% -------------------------------------------------------------------------

% --> initialise the variables
indleg     = 1;

% --> extract the input
idpl               = INPUT.idcentral;
idMO               = pl;
vinfinity_levels   = INPUT.vinflevels;
N                  = res(1);
M                  = res(2);
allowed_geometries = INPUT.allowed_geometries;
exterior_interior  = INPUT.exterior_interior;
tolDV_leg          = INPUT.tolDV_leg;

% --> for all the infinity velocities and anatomies, find VILTs
next_nodes = zeros( 1e3, 12 );
for indvinf = 1:length(vinfinity_levels)

    vinf_pp = vinfinity_levels(indvinf);

    % --> check if the given resonance is achievable for the set vinf_pp
    [~, ~, alphaRES] = resonanceVinf2raRp(N, M, vinf_pp, idpl, idMO);

    if ~isnan(alphaRES)
        for indintext = 1:length(exterior_interior)
            kei = exterior_interior(indintext);
            for indgeom = 1:length(allowed_geometries)
                type = allowed_geometries(indgeom);
                for L = 0:M-1
                    S = [type kei N M L];
                    vinf1 = vinf_dep; vinf2 = vinf_pp;
                    [~, DV, tofsc, node_pp, alpha_p_pf] = ...
                        wrap_VILT(S, vinf1, vinf2, idMO, idpl);
                    
                    if N==M && N>1 && M>1 && vinf1 == vinf2 % --> do not compute the resonant transfer in this case
                        DV = NaN;
                    end

                    if ~isnan(DV)
                        if DV <= tolDV_leg                      % --> check tolerance on DV for the leg
                            vinf_p_pf               = vinf_dep;
                            nodeToAdd               = [pl S [alpha_p_pf vinf_p_pf] node_pp [DV tofsc/86400]];
                            [nodeToAdd, tof1, tof2] = computeTof1Tof2AndRefine(nodeToAdd, idpl); % --> compute TOFs to DSMs and do refinement

                            if nodeToAdd(11) <= tolDV_leg % --> after the refinement check if the DV is still under the tolerance
                                if nodeToAdd(12) >= INPUT.tofFB && min([tof1, tof2]) >= INPUT.tofDSM % --> check tolerance on TOFs to DSMs
                                    next_nodes(indleg,:) = nodeToAdd;
                                    indleg               = indleg + 1;
                                    break % --> only compute the first L solution compatible with constraints
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
next_nodes = next_nodes(~all(next_nodes == 0, 2),:);   % --> eliminate rows all equal to zero

end
