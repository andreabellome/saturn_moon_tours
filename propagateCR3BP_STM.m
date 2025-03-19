function [ svtf, stm, full_state, full_stm ] = propagateCR3BP_STM( sv_0, tf, strucNorm, n_points )

mu       = strucNorm.normMu;
pars.mu  = mu;

if nargin == 3
    n_points = 500;
end

tt = linspace( 0, tf, n_points );

phi0_mat  = [sv_0; eye(6)];  % Stack sv_0 on top of a 6x6 identity matrix
phi0_vect = reshape(phi0_mat', 42, 1);  % Reshape into a 42x1 column vector

opt       = odeset('RelTol', 1e-13, 'AbsTol', 1e-13 );
[tt, yy1] = ode113( @(t, phi) f_CR3BP_STM(t, phi, pars), tt, phi0_vect, opt );

svtf = yy1(end,1:6);
stm  = reshape(yy1(end,7:end),6,6)';

full_state = yy1(:,1:6);
full_stm   = yy1(:,7:end);

end
