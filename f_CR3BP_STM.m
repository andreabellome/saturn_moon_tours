function [phi_dot_vect] = f_CR3BP_STM( t, phi, pars )

x  = phi(1:6);
mu = pars.mu;

phi0_mat = reshape(phi(7:42),6,6);

mu1 = 1 - mu;
mu2 = mu;

rho1_2 = (x(1) + mu2) ^ 2 + x(2) ^ 2 + x(3) ^ 2;
rho2_2 = (x(1) - mu1) ^ 2 + x(2) ^ 2 + x(3) ^ 2;
rho1_3 = rho1_2 ^ 1.5;
rho1_5 = rho1_2 ^ 2.5;
rho2_3 = rho2_2 ^ 1.5;
rho2_5 = rho2_2 ^ 2.5;

ux = - x(1) + mu1 * (x(1) + mu2) / rho1_3 + mu2 * (x(1) - mu1) / rho2_3;
uy = - x(2) + mu1 * x(2) / rho1_3 + mu2 * x(2) / rho2_3;
uz = (mu1 / rho1_3 + mu2 / rho2_3) * x(3);

uxx = -1 + (mu1 / rho1_3) * (1 - (3 * (x(1) + mu2) ^ 2 / rho1_2)) + (mu2 / rho2_3) * (1 - (3 * (x(1) - mu1) ^ 2 / rho2_2));
uyy = -1 + (mu1 / rho1_3) * (1 - (3 * x(2) ^ 2 / rho1_2)) + (mu2 / rho2_3) * (1 - (3 * x(2) ^ 2 / rho2_2));
uxy = -(mu1 / rho1_5) * 3 * x(2) * (x(1) + mu2) - (mu2 / rho2_5) * 3 * x(2) * (x(1) - mu1);
uxz = -(3 * mu1 * (x(1) - mu2) * x(3) / rho1_5 + 3 * mu2 * (x(1) - mu1) * x(3) / rho2_5);
uyz = -(3 * mu1 * x(2) * x(3) / rho1_5 + 3 * mu2 * x(2) * x(3) / rho2_5);
uzz = -(mu1 * (3 * x(3) ^ 2 - rho1_2) / rho1_5 + mu2 * (3 * x(3) ^ 2 - rho2_2) / rho2_5);

mat1 = -[ uxx, uxy, uxz;
          uxy, uyy, uyz;
          uxz, uyz, uzz ];

mat2 = [ 0 2 0; -2 0 0; 0 0 0 ];

df = [ zeros(3,3), eye(3);
        mat1,      mat2 ];

phi_dot_mat = df*phi0_mat';

phi_dot_vect = zeros( 42, 1 );

phi_dot_vect(1)    = x(4);
phi_dot_vect(2)    = x(5);
phi_dot_vect(3)    = x(6);
phi_dot_vect(4)    = 2 * x(5) - ux;
phi_dot_vect(5)    = -2 * x(4) - uy;
phi_dot_vect(6)    = -uz;
phi_dot_vect(7:42) = reshape(phi_dot_mat', 36, 1);

end