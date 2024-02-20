function alpha = wrapToPi(alpha)

% DESCRIPTION
% Wraps an angle from 0 to pi.
%
% INPUT
% - alpha : angle [rad]
%
% OUTPUT
% - alpha : angle wrapped between 0 and pi [rad]
%
% -------------------------------------------------------------------------

if ~isreal(alpha)
   alpha = real(alpha) ;
end

% wrap to [0..2*pi]
alpha = wrapToTwoPi(alpha);

% wrap to [-pi..pi]
idx = alpha>pi;
alpha(idx) = alpha(idx)-2*pi;


end
