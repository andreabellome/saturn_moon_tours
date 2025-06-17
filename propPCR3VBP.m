function dx = propPCR3VBP( t, xvalues, mu )

% --> extract the values
X       = xvalues;

r1      = [X(1) + mu; X(2)];
R1      = norm(r1);

r2      = [X(1) - (1-mu); X(2)];
R2      = norm(r2);

% --> equations of motion
dx      = zeros(4,1); 

dx(1)   = X(3);
dx(2)   = X(4);
dx(3)   = X(1) + 2*X(4) - (1-mu)*(X(1) + mu)/R1^3 - mu*(X(1) + mu - 1)/R2^3;
dx(4)   = X(2) - 2*X(3) - (1-mu)*X(2)/R1^3 - mu*X(2)/R2^3;
% --> equations of motion

end