function [tt,yy] = propagateKepler_tof(rr1, vv1, tof, mu)

% dt must be a vector !!!

tt = linspace( 0, tof, 500 );

kep1 = car2kep([rr1, vv1], mu);

yy = zeros(length(tt), 6);
for indi = 1:length(tt)
    [rrf, vvf] = FGKepler_dt(kep1, tt(indi), mu);
    yy(indi,:) = [rrf vvf];
end

[rows,~] = size(tt);
if rows == 1
    tt = tt';
end

end