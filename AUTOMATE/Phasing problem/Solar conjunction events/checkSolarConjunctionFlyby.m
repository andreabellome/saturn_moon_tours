function [LEGS, indtodel] = checkSolarConjunctionFlyby(LEGS, INPUT, inphasing)

% DESCRIPTION
% This function is used to check solar conjunction events for moon tours.
% Tours are analysed and pruned if the solar conjunction occurs.
%
% INPUT
% - LEGS      : matrix containing the tours. Each row is a tour. Each tour is
%               made by 'next_nodes' rows (see generateVILTSall.m) one
%               after the other.
% - INPUT     : structure with the followinf mandatory fields:
%               - t0        : initial tour epoch [MJD2000]
%               - pl1       : ID of the moon phase (see constants.m)
%               - idcentral : ID of the central body (see constants.m)
%               - phaselim  : limit on phase angle [rad]
%               - phasingOptions : revolutions for Lambert arcs
% - inphasing : structure with the following fields:
%        - path   : matrix containing the tour. Each row is made by 'next_nodes'
%           rows (see generateVILTSall.m).
%        - idcentral : ID of the central body (see constants.m)
%        - seq    : 1x2 vector with initial and final moon IDs (see
%        constants.m)
%        - t0     : inital epoch [MJD2000]
%        - perct  : percentage of orbital period of next moon for step size
%        in TOF 
%        - toflim : max. integer number of revolutions for Lambert problem
%        - maxrev : max. integer number of revolutions for Lambert problem
%        - toldv  : max. DV defect [km/s]
%        - maxVinfArr : max. arrival infinity velocity at next moon [km/s]
% 
% OUTPUT
% - LEGS : same as in input but the number of rows is reduced to those
%          compliant with the solar phase angle constraint.
% 
% -------------------------------------------------------------------------

st       = 1;
indtodel = [];
if ~isempty(LEGS) && INPUT.checkSolar == 1

    t0       = INPUT.t0;
    pl1      = INPUT.pl1;
    pl2      = INPUT.idcentral;
    phaselim = INPUT.phaselim;
    
    indtodel = zeros( size(LEGS,1),1 );
    for indl = 1:size(LEGS,1)
        
        % --> find flyby times
        pathch    = reshape(LEGS(indl,:), 12, [])';
        VILTstruc = plotPhasedPath(pathch, INPUT, t0, inphasing);
        
        % --> check solar conjunction Earth-Saturn
        t1 = [VILTstruc.t1]';
        t2 = [VILTstruc.t2]';
        tt = [ t1' t2(end) ];

        [~, phase] = findSolarConjunction(tt, pl1, pl2, phaselim);

        if max(phase) >= phaselim % --> at least one flyby occurrs in solar conjunction
            indtodel(indl,:) = indl;
            fprintf('Solar conjunction occurrs. \n');
        end
    
    end
    indtodel(indtodel == 0) = [];
    
    LEGS(indtodel,:) = [];

    st = 0;
    
else
    fprintf('Solar conjunction is not checked. \n');
end

if st == 0 && isempty(LEGS) % --> then the solar conjunction prevents solutions to appear
    fprintf('Solar conjunction prevents solutions to appear. \n');
end

end
