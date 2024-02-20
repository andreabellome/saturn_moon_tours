function [LEGSviltsNew, tof1, tof2, check] = computeTof1Tof2AndRefine(LEGSvilts, idcentral)

% DESCRIPTION
% This function computes the time of flights between a flyby and a DSM on a
% VILT. It also performs a refinement on the transfers that require L=0
% (check wrap_VILTS.m) and encounter the moon before the apoapsis passage.
% IMPORTANT: currently only Saturn is considered as central body.
% 
% INPUT
% - LEGSvilts: matrix with VILTs information. Each row is a transfer with
%              the following information:
%               - LEGSvilts(:,1) : ID of the flyby body (see
%                 constants.m)
%               - LEGSvilts(:,2:6) : S vector of the VILT anatomy (see
%                 wrap_VILT.m)
%               - LEGSvilts(:,7:8) : pump angle [rad] and infinity
%               velocity [km/s] at the object encounter before the
%               manoeuvre
%               - LEGSvilts(:,9:10) : pump angle [rad] and infinity
%               velocity [km/s] at the object encounter after the manoeuvre
%               - LEGSvilts(:,11:12) : DV [km/s] and time of flight [days]
%                for the transfer
% - idcentral : ID of the central body (see constants.m)
%
% OUTPUT
% - LEGSviltsNew: same as LEGSvilts in input, but the LEGSviltsNew(:,11:12)
%                 are updated according to the refinement.
% - tof1 : time of flight from the first encounter to the DSM [days]
% - tof2 : time of flight from the DSM to the next encounter [days]. If no
%          DSM is present (e.g., on a resonant transfer) this is considered
%          as Inf. 
% - check : variable not needed, will be removed from future updates.
% 
% -------------------------------------------------------------------------

% --> gravitational parameter of Saturn
mu = constants(idcentral, 1);
t0 = 0;

check        = zeros( size(LEGSvilts,1), 10 );
LEGSviltsNew = zeros( size(LEGSvilts,1), size(LEGSvilts,2) );

for ind = 1:size(LEGSvilts,1)

    pathrow = LEGSvilts(ind,:);

    res = pathrow(4:5);
    L   = pathrow(6);
    kei = pathrow(3);

    if pathrow(end-1) > 1e-6 % --> only check those that have DSM
        
        % --> traj. info for the given leg
        [~, ~, ~, ~, tof, dv, rr1, vvd,...
            rr2, vva, ~, ~, ~, ~] = patRowVILTtoState(pathrow, t0, idcentral);
        
        kep1 = car2kep( [rr1 vvd], mu );
                
        if kei == -1 % --> MANOEUVRE AT PERIAPSIS
            
            % --> propagate until the periapsis
            
            if kep1(end) > pi
                % --> propagate until the periapsis
                tof1 = kepEq_t(2*pi, kep1(1), kep1(2), mu, kep1(end), 0) + 2*pi*sqrt( kep1(1)^3/mu )*(L);
            elseif kep1(end) < pi 
                % --> RIPRENDI DA QUI: THIS IS WHERE THE PROBLEM IS !!!! --> what does it mean L=0?
                tof1 = kepEq_t(2*pi, kep1(1), kep1(2), mu, kep1(end), 0) + 2*pi*sqrt( kep1(1)^3/mu )*(L - 1);
            end
        
        elseif kei == 1 % --> MANOEUVRE AT APOAPSIS
        
            if kep1(end) > pi
                % --> you passed the apoapsis --> you need to pass periapsis again
                tof1 = kepEq_t(2*pi, kep1(1), kep1(2), mu, kep1(end), 0) + 2*pi*sqrt( kep1(1)^3/mu )*( L + 1/2 );
            elseif kep1(end) < pi
                % --> you have not passed the apoapsis
                tof1 = kepEq_t(pi, kep1(1), kep1(2), mu, kep1(end), 0) + 2*pi*sqrt( kep1(1)^3/mu )*L;
            end    
        
        end
        
        % --> propagate until the manoeuvre point
        [~, vvpre] = FGCar_dt(rr1, vvd, tof1, mu);

        % --> time of flight on the next arc
        tof2 = tof*86400 - tof1;

        % --> propagate backwards until the manoeuvre location
        [~, vvpost, ~] = FGCar_dt(rr2, vva, -tof2, mu);

        % --> checl that everything is correct
        check(ind,:) = [ kei pathrow(2) kep1(end) res L tof1/86400 tof2/86400 abs( norm(vvpost - vvpre) - dv ) 0 ];

        if check(ind,end-3) < 0
            
            [pathrowNew, tof1] = refinePeriapsisSolutionsL0(pathrow, t0, idcentral);

            [~, ~, ~, ~, tof, dv, rr1, vvd,...
                rr2, vva, ~, ~, ~, ~] = patRowVILTtoState(pathrowNew, t0, idcentral);
            kep1 = car2kep( [rr1 vvd], mu );
            tof2 = tof*86400 - tof1;

            [rrpre, vvpre]      = FGCar_dt(rr1, vvd, tof1, mu);
            [rrpost, vvpost, ~] = FGCar_dt(rr2, vva, -tof2, mu);

            LEGSviltsNew(ind,:) = pathrowNew;
            check(ind,:)     = [ kei pathrowNew(2) kep1(end) res L tof1/86400 tof2/86400 abs( norm(vvpost - vvpre) - dv ) norm(rrpre - rrpost) ];

        else

            LEGSviltsNew(ind,:) = pathrow;

        end

    else % --> this is a pure resonance

        tof                 = pathrow(end);
        LEGSviltsNew(ind,:) = pathrow;
        check(ind,:)        = [ kei pathrow(2) NaN res L tof Inf 0 0 ];

    end
    
end

tof1 = check(:,end-3);
tof2 = check(:,end-2);

end
