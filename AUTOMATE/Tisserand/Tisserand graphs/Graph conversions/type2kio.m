function [kio] = type2kio(type)

% DESCRIPTION
% This function converts the type of transfer into a variable
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
% - kio : 1x2 vector with cosinus values of crank angle encounters (depends
%         upon the type selected in input)
%
% -------------------------------------------------------------------------

if type == 88 % OO
    kio = [1  1];
elseif type == 81 % OI
    kio = [1 -1];
elseif type == 18 % IO
    kio = [-1 1];
elseif type == 11 % II
    kio = [-1 -1];
end

end