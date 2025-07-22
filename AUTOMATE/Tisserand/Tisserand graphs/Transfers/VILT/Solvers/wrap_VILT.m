function [DIFF, DV, tofsc, node, alpha1, asc1, asc2, esc1, esc2, rla, th1, th2, T1, T2] = ...
    wrap_VILT(S, vinf1, vinf2, idMO, idpl)

% DESCRIPTION
% This function computes the VILT given the vinf1, vinf2 and the type of
% transfer (S vector). This is based on the publication:
% Strange, Campagnola, Russell, 'Leveraging flybys of low mass moons to
% enable an Enceladus orbiter' (2009)
% https://www.researchgate.net/publication/242103688_Leveraging_flybys_of_low_mass_moons_to_enable_an_Enceladus_orbiter
% 
%
% INPUT
% 
% - S        : 1x5 vector containing variables defining the VILT
%            S(1) = TYPE --> OO/OI/IO/II (88, 81, 18, 11)
%            S(2) = kei  --> +1 for EXTERNAL, -1 for INTERNAL
%            S(3) = N    --> number of moon revolutions
%            S(4) = M    --> number of spacecraft revolutions
%            S(5) = L    --> number of spacecraft revolution where the DSM occurs
% - vinf1    : initial infinity velocity w.r.t. the moon [km/s]
% - vinf2    : final infinity velocity w.r.t. the moon [km/s]
% - idMO     : flyby body ID, depending upon the central body ID (see
%            constants.m)
% - idpl     : central body ID (see constants.m)
%
% OUTPUT
% - DIFF   : non-dimensional difference between SC and moon transfer times
%          (to solve the phasing problem)
% - DV     : DV of the VILT (km/s)
% - tofsc  : TOF of the SC on the VILT (s)
% - node   : 1x2 vector containing the new node (alpha,vinf) (rad,km/s)
% - alpha1 : post-flyby pump angle (rad)
% - asc1   : SC semi-major axis of the orbit before the manoeuvre (km)
% - asc2   : SC semi-major axis of the orbit after the manoeuvre (arrival node) (km)
% - esc1   : SC eccentricity of the orbit before the manoeuvre
% - esc2   : SC eccentricity of the orbit after the manoeuvre (arrival node)
% - rla    : leveraging apse (i.e. where the manoeuvre is located, apoapsis
%          or periapsis?) (km)
% - th1    : true anomaly at the first moon encounter (rad)
% - th2    : true anomaly at the second moon encounter (rad)
% - T1     : time from first flyby to the DSM (s)
% - T2     : time from DSM to second flyby (s)
%
% -------------------------------------------------------------------------

% --> constants
ADIM = zeros(1,3);
[mu, ADIM(2), ADIM(1), ADIM(3)] = constants(idpl, idMO);

% --> guess over the pump angle
[~, ~, alpha] = generateContoursMoonsSat(idMO, vinf1, idpl);
alphaMin      = alpha(1);
alphaMax      = alpha(end);

alpha1 = linspace(alphaMin, alphaMax, 100);

% --> find guesses over the solution
[DIFF, ~, ~, ~, alpha1] = solveForAL1(alpha1, ADIM, S, vinf1, vinf2, idpl, idMO);

% figure; hold on; grid on;
% plot( alpha1, DIFF )

% --> solve for ALPHA1 given the guess
indxprev = find(diff(DIFF>=0),1);
if isempty(indxprev)
    % no solutions for the VILT problem
    DIFF = NaN; DV = NaN; tofsc = NaN; node = NaN; alpha1 = NaN; asc1 = NaN;
    asc2 = NaN; esc1 = NaN; esc2 = NaN; rla = NaN; th1 = NaN; th2 = NaN;
    T1 = NaN; T2 = NaN;
else

    indxsucc = indxprev + 1;
    if abs(min([DIFF(indxprev) DIFF(indxsucc)])) > 1e-5
        ALPHA1 = fzero(@(al) solveForAL1(al, ADIM, S, vinf1, vinf2, idpl, idMO), ...
            [alpha1(indxprev) alpha1(indxsucc)]);
    else
        [~, row] = min(abs(DIFF));
        ALPHA1   = alpha1(row);
    end

    % evaluate the solution and compute next node
    [DIFF, DV, tofsc, node, alpha1, asc1,...
        asc2, esc1, esc2, rla, th1, th2, T1, T2] = ...
        solveForAL1(ALPHA1, ADIM, S, vinf1, vinf2, idpl, idMO);

    % apply dimensionalization
    rdim = ADIM(1);
    tdim = 2*pi*sqrt(rdim^3/mu);
    vdim = sqrt(mu/rdim);

    DV    = DV*vdim;
    tofsc = tofsc*tdim;
    asc1  = asc1*rdim;
    asc2  = asc2*rdim;
    rla   = rla*rdim;
    T1    = T1*tdim;
    T2    = T2*tdim;

end

end
