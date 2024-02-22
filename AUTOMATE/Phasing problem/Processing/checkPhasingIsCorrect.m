function correct = checkPhasingIsCorrect(LEGS, INPUT, t0, inphasing)

% DESCRIPTION
% This function simply checks if the phasing problem has been implemented
% correctly.
% 
% INPUT
% - LEGS  : matrix containing the tours. Each row is a tour. Each tour
%           is made by 'next_nodes' rows (see generateVILTSall.m) one
%           after the other.
% - INPUT : structure with the following mandatory fields:
%           - idcentral    : ID of the central body (see constants.m)
%           - phasingOptions : number of revolutions for Lambert problem
% 
% - t0        : initial tour date [MJD2000]
% - inphasing : structure with the following mandatory fields (see also
%               writeInPhasing.m):
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
% - correct : not needed. Will be removed in next updates.
% 
% -------------------------------------------------------------------------

correct = 1e99.*ones( size(LEGS,1),1 );
for indl = 1:size(LEGS,1)
    pathch    = reshape(LEGS(indl,:), 12, [])';
    VILTstruc = plotPhasedPath(pathch, INPUT, t0, inphasing);
    correct(indl,:) = vecnorm( abs( [ [VILTstruc(end).dv]' [VILTstruc(end).tof]' ] - pathch(end,end-1:end))' )';
end

if max(correct) < 1e-6
    fprintf('Phasing is correct. \n');
end

end