function [alpha] = checkZeroAlphas(alpha)

% DESCRIPTION
% This function checks if an anlge is real or not. If the imaginary part of
% the angle is less than a tolerance (1e-4 rad) then the angle is assumed
% to be equal to its real part
% 
% INPUT
% - alpha : angle [rad]
% 
% OUTPUT
% - alpha : same as input
%
% -------------------------------------------------------------------------

if ~isreal(alpha)
    if imag(alpha) < 1e-4
        alpha = real(alpha);
    else
        alpha = NaN;
    end
end

end