function in = writeInPhasing(path, t0, perct, toflim, maxrev, toldv, INPUT)

% DESCRIPTION
% This function is simply a wrapper for input relevant for solving the
% phasing problem for moon tours.
%
% INPUT
% - path   : matrix containing the tour. Each row is made by 'next_nodes'
%           rows (see generateVILTSall.m).
% - t0     : inital epoch [MJD2000]
% - perct  : percentage of orbital period of next moon for step size in TOF
% - toflim : 1x2 vector with min, max TOF for the leg [days]
% - maxrev : max. integer number of revolutions for Lambert problem
% - toldv  : max. DV defect [km/s]
% - INPUT  : structure with the following mandatory fields:
%            - idcentral : ID of the central body (see constants.m)
% 
% OUTPUT
% - in : structure with the following fields:
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
% -------------------------------------------------------------------------

in.path       = path;
in.idcentral  = INPUT.idcentral;
in.seq        = [ path(end,3) path(end,1) ];
in.t0         = t0;
in.perct      = perct;
in.toflim     = toflim;     % --> min, max TOF for the leg (days)
in.maxrev     = maxrev;     % --> max. number of revolutions for Lambert arc
in.toldv      = toldv;      % --> max. DV for the leg (km/s)
in.maxVinfArr = path(end,10)+0.1;

end