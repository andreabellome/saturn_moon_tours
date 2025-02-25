function [Ax] = fromAz_toAx_halo_sun_earth_l1(Az, normDist)

% Az and Ax are given in km!!!!

Az = Az.*10^7./( normDist.*10^5 );

l1    = -15.9650314;
l2    = 1.740900800;
Delta = 0.29221444425;

ampl_x = @(ampl_z) sqrt( ( -l2.*(ampl_z).^2 - Delta )./( l1 ) );

Ax = ampl_x(Az).*normDist./(10^7).*10^5;

end