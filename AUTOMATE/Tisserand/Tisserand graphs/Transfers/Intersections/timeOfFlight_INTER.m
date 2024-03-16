function [TOFs, th1, th2] = timeOfFlight_INTER(kep, pl1, pl2, idcentral)

% DESCRIPTION :
% finds the TOF for for OO/OI/IO/II between two flyby bodies. The code works
% for elliptical orbits intercepting the two flyby bodies orbit (in circular
% co-planar model). The elliptical orbit is planar.
%
% INPUT :
% kep : keplerian elements for the SC orbit
% pl1 : ID of the departing flyby body
% pl2 : ID of the arrival flyby body
% 
% OUTPUT :
% TOFS : vector containing time of fligth between the two flyby bodies on the
%        given orbit for OO/OI/IO/II
%
% -------------------------------------------------------------------------

[mu, ~, r_pl1] = constants(idcentral, pl1);
[~, ~, r_pl2]  = constants(idcentral, pl2);

e = kep(2);
p = kep(1)*(1 - kep(2)^2);
T = 2*pi*sqrt(kep(1)^3/mu);

if pl1 < pl2 % --> SC is going UP (e.g. from Venus to Earth)
    
    R1 = r_pl1;
    R2 = r_pl2;
    
    th1 = acos((p - R1)/(e*R1));
    th1 = wrapToPi(th1);
    
    th2 = acos((p - R2)/(e*R2));
    th2 = wrapToPi(th2);
    
    M1 = th2M(th1, e);
    E1 = Mean2E(M1,e);
    t1 = T/(2*pi)*(E1 - e*sin(E1));
    
    M2 = th2M(th2, e);
    E2 = Mean2E(M2,e);
    t2 = T/(2*pi)*(E2 - e*sin(E2));
    
    TOFs(1) = t2 - t1;     % --> (OO)
    TOFs(2) = T - t2 - t1; % --> (OI)
    TOFs(3) = t1 + t2;     % --> (IO)
    TOFs(4) = T + t1 - t2; % --> (II)
    
elseif pl1 > pl2 % --> SC is going DOWN (e.g. from Earth to Venus)
    
    R1 = r_pl2;
    R2 = r_pl1;
    
    th1 = acos((p - R1)/(e*R1));
    th1 = wrapToPi(th1);
    
    th2 = acos((p - R2)/(e*R2));
    th2 = wrapToPi(th2);
    
    M1 = th2M(th1, e);
    E1 = Mean2E(M1,e);
    t1 = T/(2*pi)*(E1 - e*sin(E1));
    
    M2 = th2M(th2, e);
    E2 = Mean2E(M2,e);
    t2 = T/(2*pi)*(E2 - e*sin(E2));
    
    TOFs(1) = T + t1 - t2; % --> (OO)
    TOFs(2) = T - t2 - t1; % --> (OI)
    TOFs(3) = t1 + t2;     % --> (IO)
    TOFs(4) = t2 - t1;     % --> (II)
    
end

%%%%%%%%%% AUXILIARY FUNCTIONS %%%%%%%%%%

function M = th2M(theta, e)
    
    % --> from true anomaly to mean

    if e < 1
        E = 2*atan(sqrt((1 - e)/(1 + e))*tan(theta/2));
        M =  E - e*sin(E);
    elseif e > 1
        E = 2*atanh(sqrt((e - 1)/(e + 1))*tan(theta/2));
        M = e*sinh(E) - E;
    end

end

function E = Mean2E(M,e)

    % --> from mean anomaly to eccentric
    
    tol   = 1e-13;
    err   = 1;
    E     = M + e*cos(M);   %initial guess
    maxit = 1000;
    it    = 0;
    while (err > tol) && (it < maxit)
        Enew = E - (E - e*sin(E) - M)/(1 - e*cos(E));
        err  = abs(E - Enew);
        E    = Enew;
        it   = it + 1;
    end

end

%%%%%%%%%% AUXILIARY FUNCTIONS %%%%%%%%%%

end