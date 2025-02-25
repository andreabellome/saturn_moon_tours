function cn = c_parameter( mu, gamma, lpoint )

if nargin == 3
    lpoint = 'L1';
end

if strcmpi(lpoint, 'L1')
    n  = 2:4;
    cn = 1./(gamma.^3)*( ((+1).^n).*mu + (-1).^n.*( (1 - mu)*gamma.^( n + 1 ) )./( ( 1 - gamma ).^( n + 1 ) ) );
elseif strcmpi(lpoint, 'L2')
    n  = 2:4;
    cn = 1/(gamma.^3)*( ((-1).^n).*mu + (-1).^n.*( (1 - mu)*gamma.^( n + 1 ) )./( ( 1 + gamma ).^( n + 1 ) ) );
end

end