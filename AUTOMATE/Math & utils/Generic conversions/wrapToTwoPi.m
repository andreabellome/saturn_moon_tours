function alpha = wrapToTwoPi(alpha)

% DESCRIPTION
% Wraps an angle from 0 to 2*pi.
%
% INPUT
% - alpha : angle [rad]
%
% OUTPUT
% - alpha : angle wrapped between 0 and 2*pi [rad]
%
% -------------------------------------------------------------------------

% wrap to [0..2*pi]
alpha = mod(alpha,2*pi);
end