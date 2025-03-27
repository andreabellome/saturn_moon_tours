function [ svtf, full_state, tt ] = propagateCR3BP( sv_0, tf, strucNorm, n_points, stopCond )

mu       = strucNorm.normMu;
pars.mu  = mu;

if nargin == 3
    n_points = 500;
    stopCond = 0;
elseif nargin == 4
    if isempty(n_points)
        n_points = 500;
    end
    stopCond = 0;
elseif nargin == 5
    if isempty(n_points)
        n_points = 500;
    end
    if isempty(stopCond)
        stopCond = 0;
    end
end

tt        = linspace( 0, tf, n_points );
opt       = odeset('RelTol', 1e-13, 'AbsTol', 1e-13 );

if stopCond == 0
else
    opt.Events = @stopconditions;
end

[tt, yy1] = ode113( @(t, x) f_CR3BP(x, pars), tt, sv_0, opt );

svtf       = yy1(end,1:6);
full_state = yy1(:,1:6);

end

function [value, isterminal, direction] = stopconditions(times, states)

value      = states(2);
isterminal = 1;   % Stop the integration
direction  = 0;

end
