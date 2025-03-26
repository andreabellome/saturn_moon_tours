function [c, ceq] = propagate_perturbed_fmincon(dv0, xx0, pars)

[Fval, tt, yy1, yy1_rot] = propagate_perturbed( dv0, xx0, pars );

c = [];
ceq = Fval;

end
