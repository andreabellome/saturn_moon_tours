function [revopt] = rev2RevOpt(rev, res, indleg)

% DESCRIPTION
% This function is used to generate options for Lambert problem Number of
% revolutions and case (low-/high- energy).
% 
% INPUT
% - rev : number encoding number of revolutions and case for Lambert
%         problem. For example:
%         rev = 0  --> means 0 revs. 
%         rev = 10 --> means 1 rev. and case 0 (low energy)
%         rev = 11 --> means 1 rev. and case 1 (high energy)
%         rev = 20 --> means 2 revs. and case 0 (low energy)
%         rev = 21 --> means 2 revs. and case 1 (high energy)
%         and so on...
% - res : 1x3 vector with N:M resonant ratio and number of leg at which the
%         resonant transfer is needed. If no resonant transfer is needed,
%         leave it empty.
% - indleg : ID of the current leg.
% 
% OUTPUT
% - revopt : 1x4 vector with the following info:
%            - revopt(1:2) is for number of revolutions and case for
%            Lambert problem solution.
%            - revopt(3:4) is for resonant ratio, if present: then
%            revopt(1:2) = 0. If not present, revopt(3:4) = 0.
% 
% -------------------------------------------------------------------------

rev = num2str(rev);
if str2double(rev(1)) == 0
    revopt = [0 0];
else
    if length(rev) == 2
        revopt = [ str2double(rev(1)) str2double(rev(2))];
    elseif length(rev) == 3
        revopt = [ str2double(rev(1:2)) str2double(rev(3))];
    end
end
revopt = [ revopt zeros(1,2) ];

if ~isempty(res)
    res        = reshape(res', [3,size(res,2)/3])';
    indlegres  = res(:,end);
    indxs      = find( indlegres == indleg );
    if ~isempty(indxs)
        revopt(3:4) = res(indxs,1:2);
    end
end

end
