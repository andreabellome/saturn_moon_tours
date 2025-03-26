function [theta_unst, unstable_eigenvector] = unstable_dir_linear_theory( A, vec )

% Compute eigenvalues and eigenvectors
[V, D] = eig(A);

% Extract eigenvalues
eig_values = diag(D);

% Find indices for the stable and unstable eigenvalues
[~, unstable_idx] = max(real(eig_values)); % Unstable mode (largest positive real part)
[~, stable_idx]   = min(real(eig_values));   % Stable mode (largest negative real part)

% Extract the corresponding eigenvectors
unstable_eigenvector = V(:, unstable_idx);
stable_eigenvector   = V(:, stable_idx);

% Extract x and y components of the stable and unstable eigenvectors
v_x_unstable   = unstable_eigenvector(4);
v_y_unstable   = unstable_eigenvector(5);

% --> unstable direction
theta_unst = acos( dot( unstable_eigenvector(4:6), vec )/( norm(unstable_eigenvector( 4:6 ))*norm(vec) ) );

end