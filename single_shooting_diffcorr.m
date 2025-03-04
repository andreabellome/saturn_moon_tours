function [sv0, orb_period] = single_shooting_diffcorr( sv0_ini, sv_f_ini, tau_ini, strucNorm, free_var, zero_var, tol, max_iter )

mu       = strucNorm.normMu;

if nargin == 4
    free_var = [ 1, 5, 7 ];
    zero_var = [ 2, 4, 6 ];
    tol      = 1e-12;
    max_iter = 2000;
elseif nargin == 5
    zero_var = [ 2, 4, 6 ];
    tol      = 1e-12;
    max_iter = 2000;
elseif nargin == 6
    tol      = 1e-12;
    max_iter = 2000;
elseif nargin == 7
    max_iter = 2000;
end

indxs = find( free_var == 7 );
if isempty(indxs)
    variable_time = false;
else
    variable_time = true;
end

var_c        = free_var;
var_c(indxs) = [];
zero_c       = zero_var;

ind_x      = zeros( 1,6 );

x_freevars = sv0_ini(var_c);
ind_x(var_c) = 1;

ind_ini = ones(1,6) - ind_x;  % Choosing indexes for sv0

if variable_time
    x_freevars = [ x_freevars, tau_ini ];
end

k             = 1;
norm_y_constr = 1;

pars.mu = mu;
while norm_y_constr > tol && k <= max_iter
    
    sv0 = ind_ini .* sv0_ini;

    if variable_time
        sv0(var_c) = x_freevars(1:end-1);
        tf = x_freevars(end);
        [ sv_tf, STM_tf ] = propagateCR3BP_STM( sv0, tf, strucNorm, 500 );
        
        [ sv_dot ] = f_CR3BP( sv_tf, pars );
        sv_dot = sv_dot';

        df     = [ STM_tf( zero_c, var_c ), sv_dot(zero_c)' ];

    end

    y_constr = sv_tf(zero_c);

    inv_df = inv(df * df');  % Inverse of (df * df^T)
    slope  = df' * inv_df;   % Equivalent of (df.T).dot(inv_df)

    x_freevars = [x_freevars' - slope * y_constr']';  % Equivalent of slope.dot(y_constr)

    norm_y_constr = norm(y_constr);
    k             = k + 1;
        

end

if variable_time
    orb_period = 2 * x_freevars(end);
else
    orb_period = 2 * tau_ini;
end

end
