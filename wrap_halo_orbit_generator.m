function [ sv0, orb_period, Jc, tt, yy ] = wrap_halo_orbit_generator( Az, lpoint, strucNorm, num_periods )

% Az must be in km!!!

if nargin == 3
    num_periods = 1;
end

% --> provide initial guess for Halo orbit
[ xx0, orb_period_ini ] = halo_initial_guess( Az, 0, lpoint, strucNorm );

% --> differential corrector for Halo orbit
sv0_ini           = xx0;
[sv0, orb_period] = correct_orbit( sv0_ini, orb_period_ini, strucNorm );

if nargout > 2
    % --> Jacobi constant of the Halo orbit
    Jc = jacobiConst( sv0(1:3), sv0(4:6), strucNorm.normMu); 
end

% --> propagate the final orbit

if nargout > 3

    tt        = linspace(0, num_periods*orb_period, 1e3);
    pars.mu   = strucNorm.normMu;
    opt       = odeset('RelTol', 3e-13, 'AbsTol', 1e-13 );
    [tt, yy]  = ode113( @(t, x) f_CR3BP(x, pars), tt, sv0, opt );

end

end