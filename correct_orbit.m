function [sv0, orb_period] = correct_orbit( sv0_ini, orb_period_ini, strucNorm, free_var, zero_var )

mu       = strucNorm.normMu;
normDist = strucNorm.normDist;
normTime = strucNorm.normTime;

if nargin == 3
    free_var = [ 1, 5, 7 ];
    zero_var = [ 2, 4, 6 ];
elseif nargin == 4
    zero_var = [ 2, 4, 6 ];
end

tau_ini = orb_period_ini/2;

% --> propagate
tt = linspace( 0, tau_ini, 2000 );

pars.mu   = mu;
opt       = odeset('RelTol', 1e-13, 'AbsTol', 1e-13 );
[tt, yy1] = ode113( @(t, x) f_CR3BP(x, pars), tt, sv0_ini, opt );

sv_f_ini = yy1(end,:);

[sv0, orb_period] = single_shooting_diffcorr( sv0_ini, sv_f_ini, tau_ini, strucNorm );

end