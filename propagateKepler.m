function [tt, yy, kkep] = propagateKepler(rr1, vv1, tt, mu)

% DESCRIPTION
% This function propagates in keplerian dynamics an initial state over a
% grid of time of flights.
% 
% INPUT
% - rr1 : 1x3 vector with initial position [km]
% - vv1 : 1x3 vector with initial velocity [km/s]
% - tt  : 1xN vector with time of flights [s]
% - mu  : gravitational constant of the central body [km3/s2]
% 
% OUTPUT 
% - tt   : same as in input
% - yy   : Nx6 matrix, where each row is the state, i.e., position and
%          velocity vectors evaluated at each tt(i)
% - kkep : Nx6 matrix, where each row is a set of keplerian elements (see
%          car2kep.m) evaluated at each tt(i)
% 
% -------------------------------------------------------------------------

kep1 = car2kep([rr1, vv1], mu);

yy = zeros(length(tt), 6);
for indi = 1:length(tt)
    [rrf, vvf] = FGKepler_dt(kep1, tt(indi), mu);
    yy(indi,:) = [rrf vvf];
end

[rows,~] = size(tt);
if rows == 1
    tt = tt';
end

if nargout == 3
    
    kkep = zeros( size(yy,1), 6 );
    for indy = 1:size(yy,1)
        kkep(indy,:) = car2kep( yy(indy,:), mu );
    end
else
    kkep = [];
end

end