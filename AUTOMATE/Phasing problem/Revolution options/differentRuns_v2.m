function [RevMax, RevRed_OnlyZero, RevRed_FirstLast, RevRed_LastLeg, RevRed_FirstLeg] = ...
    differentRuns_v2(seq, maxrev)

% DESCRIPTION
% This function is used to generate all the permutations of number of
% revolutions and cases (low-/high- energy) for Lambert problem, given a
% sequence of flyby bodies and a maximum number of revolutions around the
% main body.
% 
% INPUT
% - seq    : sequence of IDs for flyby bodies (see constants.m)
% - maxrev : integer number of max. revolutions for Lambert problem
% 
% OUTPUT
% - RevMax : matrix with all the permutations of number of revolutions and
%            cases (low-/high- energy) for Lambert problem. Each column
%            correspond to a leg of the sequence of flyby bodies. The
%            coding is the following:
%            0  --> means 0 revs. on the leg
%            10 --> means 1 rev. and case 0 (low energy) on the leg
%            11 --> means 1 rev. and case 1 (high energy) on the leg
%            20 --> means 2 revs. and case 0 (low energy) on the leg
%            21 --> means 2 revs. and case 1 (high energy) on the leg
%            and so on...
% - RevRed_OnlyZero : single row same as RevMax but with only 0
% - RevRed_FirstLast : same as RevMax but first and last legs (i.e.,
%                      columns) are 0
% - RevRed_LastLeg   : same as RevMax but last legs (i.e., last column) are 0
% - RevRed_FirstLeg  : same as RevMax but first legs (i.e., last column) are 0
%
% -------------------------------------------------------------------------

% number of legs
nlegs = length(seq) - 1;
if maxrev == 0
    vec = 0;
elseif maxrev >= 1
    vec = sort([ 0 [11:10:(maxrev*10+1)] [10:10:maxrev*10] ]);
end

% all combinations of revolutions
RevMax = permn(vec, nlegs);

% eliminate first/last leg
indxsLast       = find(RevMax(:,end)==0);
RevRed_LastLeg  = RevMax(indxsLast,:);
indxsFirst      = find(RevMax(:,1)==0);
RevRed_FirstLeg = RevMax(indxsFirst,:);

indxsFirstLast   = find(RevRed_LastLeg(:,1)==0);
RevRed_FirstLast = RevRed_LastLeg(indxsFirstLast,:);

RevRed_OnlyZero  = RevMax(1,:);

end