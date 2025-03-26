function cn = c_parameter( mu, gamma, lpoint )

if nargin == 2
    lpoint = 'L1';
end

if strcmpi(lpoint, 'L1')
    n  = 2:4;
    cn = 1./(gamma.^3)*( ((+1).^n).*mu + (-1).^n.*( (1 - mu)*gamma.^( n + 1 ) )./( ( 1 - gamma ).^( n + 1 ) ) );
elseif strcmpi(lpoint, 'L2')
    cn(1) = ((-1)^2 * (mu + (1.0 - mu) * (gamma / (1.0 + gamma))^(2 + 1))) / gamma^3;
    cn(2) = ((-1)^3 * (mu + (1.0 - mu) * (gamma / (1.0 + gamma))^(3 + 1))) / gamma^3;
    cn(3) = ((-1)^4 * (mu + (1.0 - mu) * (gamma / (1.0 + gamma))^(4 + 1))) / gamma^3;
elseif strcmpi(lpoint, 'L3')
    cn(1) = ((-1)^2 * (mu + (1.0 - mu) * (gamma / (1.0 + gamma))^(2 + 1))) / gamma^3;
    cn(2) = ((-1)^2 * (mu + (1.0 - mu) * (gamma / (1.0 + gamma))^(3 + 1))) / gamma^3;
    cn(3) = ((-1)^2 * (mu + (1.0 - mu) * (gamma / (1.0 + gamma))^(4 + 1))) / gamma^3;
end

end