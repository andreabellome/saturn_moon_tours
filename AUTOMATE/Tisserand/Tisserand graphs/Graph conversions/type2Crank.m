function [crank1, crank2] = type2Crank(type)

% DESCRIPTION
% This function converts the type of transfer into the corresponding crank
% angles at the beginning and at the end of the transfer.
% 
% INPUT
% - type : type of transfer depending upon the moon enounter
%          possible values:
%          88 --> outbound-outbound
%          81 --> outbound-inbound
%          18 --> inbound-outbound
%          11 --> inbound-inbound
% 
% OUTPUT
% - crank1 : crank angle at the beginning of the transfer [rad].
% - crank2 : crank angle at the end of the transfer [rad].
%
% -------------------------------------------------------------------------

if type == 88 % OO
    crank1 = 0;
    crank2 = 0;
elseif type == 81 % OI
    crank1 = 0;
    crank2 = pi;
elseif type == 18 % IO
    crank1 = pi;
    crank2 = 0;
elseif type == 11 % II
    crank1 = pi;
    crank2 = pi;
end

end