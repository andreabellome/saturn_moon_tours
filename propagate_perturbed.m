function [Fval, tt, yy1, yy1_rot] = propagate_perturbed( dv0, xx0, pars )

xx0(4) = xx0(4) + dv0;

mu = pars.mu;

opt       = odeset('RelTol', 3e-13, 'AbsTol', 1e-13 );
opt.Events = @stopconditions;
[tt, yy1] = ode113( @(t, x) f_CR3BP(x, pars), linspace(0, 3.05, 15e3), xx0, opt );

% --> in the rotating reference frame
yy1_rot = yy1;
yy1_rot(:,1) = yy1(:,1) - ( 1 - mu );

Fval = yy1_rot(end,4);

end