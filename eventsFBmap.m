function [ value, isterminal, direction ] = eventsFBmap( t, xvalues, mu )

x    = xvalues(1);
y    = xvalues(2);
xdot = xvalues(4);
ydot = xvalues(5);

Rhill   = ( mu/( 3*(1 - mu) ) )^( 1/3 );

r2      = [x - (1-mu); y];
R2      = norm(r2);

[ a, ~, ~, f ] = phi_direct( x, y, xdot, ydot, mu );

epsilon = eps;
if a > 1
    fstar = pi - epsilon;
elseif a < 1
    fstar = 2*pi - epsilon;
end

value(1)      = R2 - 5*Rhill;  % y(1) > 5 is equivalent to y(1) - 5 > 0
isterminal(1) = 0;    % Stop the integration when condition is met
direction(1)  = 1;     % Detect positive crossing (when y(1) goes from below 5 to above 5)

value(2)      = f - fstar; % The condition we want to check (y(2) = 10)
isterminal(2) = 0;    % Stop the integration when condition is met
direction(2)  = 0;     % Detect both directions (crossing from either side of 10)

end
