function [VI,VF] = lambertMR_MEXIFY(RI, RF, TOF, MU, Nrev, Ncase)

% DESCRIPTION
% Lambert problem solution for Keplerian dynamics and for prograde orbits
% only.
%
% INPUT
% - RI    : 1x3 vector with initial position [km]
% - RF    : 1x3 vector with final position [km]
% - TOF   : time of flight [sec]
% - MU    : gravitational parameter of the central body [km3/s2]
% - Nrev  : integer number of revolutions
% - Ncase : if 0, then low-energy is selected, if 1, then high energy
% 
% OUTPUT
% - VI : 1x3 vector with initial velocity [km/s]
% - VF : 1x3 vector with final velocity [km/s]
%
% -------------------------------------------------------------------------

if Nrev == 0 % --> ZERO REVOLUTIONS
    
    [VI,VF] = lambert_ZeroRevs_MEXIFY(RI, RF, TOF, MU);
    
else % --> MULTIREVOLUTIONS
    
    if Ncase == 0
        m = -Nrev;
    else
        m = Nrev;
    end
    
    % --> check if MR are available (...)
    
    [VI,VF] = lambert_MEXIFY(RI, RF, TOF, m, MU);
    
end

end

function [VI,VF] = lambert_ZeroRevs_MEXIFY(RI, RF, TOF, MU)

    nitermax = 2000; % Maximum number of iterations for loops
    TOL      = 1e-14;

    TWOPI = 2*pi;
    PI    = TWOPI/2;

    % Reset
    VI = [0, 0, 0];
    VF = [0, 0, 0];

    % ----------------------------------
    % Compute the vector magnitudes and various cross and dot products

    RIM2   = dot(RI,RI);
    RIM    = sqrt(RIM2);
    RFM2   = dot(RF,RF);
    RFM    = sqrt(RFM2);
    CTH    = dot(RI,RF)/(RIM*RFM);
    CR     = cross(RI,RF);
    STH    = norm(CR)/(RIM*RFM);
    if CR(3) < 0 % always direct transfer
        STH = -STH;
    end

    THETA  = (atan2(STH,CTH));
    THETA = THETA - (TWOPI * (fix(THETA/TWOPI) + min([0,sign(THETA)])));

    if THETA == TWOPI || THETA == 0
        VI=[0,0,0]; VF=[0,0,0]; 
        return
    end

    B1     = sign(STH); if STH == 0; B1 = 1; end

    % ----------------------------------
    % Compute the chord and the semi-perimeter

    C = sqrt(RIM2 + RFM2 - 2*RIM*RFM*CTH);
    S = (RIM + RFM + C)/2;
    LAMBDA = B1*sqrt((S-C)/S);

    if 4*TOF*LAMBDA == 0 || abs((S-C)/S) < TOL
        VI=[0,0,0]; VF=[0,0,0]; 
        return
    end

    % ----------------------------------
    % Compute L carefully for transfer angles less than 5 degrees

    if THETA*180/PI <= 5
       W   = atan((RFM/RIM)^.25) - PI/4;
       R1  = (sin(THETA/4))^2;
       S1  = (tan(2*W))^2;
       L   = (R1+S1)/(R1+S1+cos(THETA/2));
    else
       L   = ((1-LAMBDA)/(1+LAMBDA))^2;
    end

    M      = 8*MU*TOF^2/(S^3*(1+LAMBDA)^6);
    TPAR   = (sqrt(2/MU)/3)*(S^1.5-B1*(S-C)^1.5);
    L1     = (1 - L)/2;

    CHECKFEAS = 0;

    % ----------------------------------
    % Initialize values of y, n, and x

    Y  = 1;
    N  = 0;
    N1 = 0;

    if (TOF-TPAR) <= 1e-3
        X0  = 0;
    else
        X0  = L;
    end

    X= -1.e8;

    % ----------------------------------
    % Begin iteration

    while (abs(X0-X) >= abs(X)*TOL+TOL) && (N <= nitermax)
        N   = N+1;
        X   = X0;
        ETA = X/(sqrt(1+X) + 1)^2;
        CHECKFEAS=1;

        % ----------------------------------
        % Compute x by means of an algorithm devised by
        % Gauticci for evaluating continued fractions by the
        % 'Top Down' method

        DELTA = 1;
        U     = 1;
        SIGMA = 1;
        M1    = 0;

        while abs(U) > TOL && M1 <= nitermax
            M1    = M1+1;
            GAMMA = (M1 + 3)^2/(4*(M1+3)^2 - 1);
            DELTA = 1/(1 + GAMMA*ETA*DELTA);
            U     = U*(DELTA - 1);
            SIGMA = SIGMA + U;
        end

        C1 = 8*(sqrt(1+X)+1)/(3+1/(5 + ETA + (9*ETA/7)*SIGMA));

        % ----------------------------------
        % Compute H1 and H2

        if N == 1
            H1 = (L+X)^2*(C1 + 1 + 3*X)/((1 + 2*X + L)*(3*C1 + X*C1 +4*X));
            H2 = M*(C1+X-L)/((1 + 2*X + L)*(3*C1 + X*C1 +4*X));
        else
            QR = sqrt(L1^2 + M/Y^2);
            H1 = (((QR - L1)^2)*(C1 + 1 + 3*X))/((2*QR)*(3*C1 + X*C1+4*X));
            H2 = M*(C1+X-L)/((2*QR)*(3*C1 + X*C1+4*X));
        end

        B = 27*H2/(4*(1+H1)^3);
        U = -B/(2*(sqrt(B+1)+1));

        % ----------------------------------
        % Compute the continued fraction expansion K(u)
        % by means of the 'Top Down' method

        DELTA = 1;
        U0    = 1;
        SIGMA = 1;
        N1    = 0;

        while N1 < nitermax && abs(U0) >= TOL
            if N1 == 0
                GAMMA = 4/27;
                DELTA = 1/(1-GAMMA*U*DELTA);
                U0 = U0*(DELTA - 1);
                SIGMA = SIGMA + U0;
            else
                for I8 = 1:2
                    if I8 == 1
                        GAMMA = 2*(3*N1+1)*(6*N1-1)/(9*(4*N1 - 1)*(4*N1+1));
                    else
                        GAMMA = 2*(3*N1+2)*(6*N1+1)/(9*(4*N1 + 1)*(4*N1+3));
                    end
                    DELTA = 1/(1-GAMMA*U*DELTA);
                    U0 = U0*(DELTA-1);
                    SIGMA = SIGMA + U0;
                end
            end

            N1 = N1 + 1;
        end

        KU = (SIGMA/3)^2;
        Y = ((1+H1)/3)*(2+sqrt(B+1)/(1-2*U*KU));    % Y = Ycami

        X0 = sqrt(((1-L)/2)^2+M/Y^2)-(1+L)/2;
    end

    % ----------------------------------
    % Compute the velocity vectors

    if CHECKFEAS == 0
        VI=[0,0,0]; VF=[0,0,0]; 
        return
    end

    if N1 >= nitermax || N >= nitermax
        VI=[0,0,0]; VF=[0,0,0];
        return
    end

    R11 = (1 + LAMBDA)^2/(4*TOF*LAMBDA);
    S11 = Y*(1 + X0);
    T11 = (M*S*(1+LAMBDA)^2)/S11;

    VI(1) = -R11*(S11*(RI(1)-RF(1))-T11*RI(1)/RIM);
    VI(2) = -R11*(S11*(RI(2)-RF(2))-T11*RI(2)/RIM);
    VI(3) = -R11*(S11*(RI(3)-RF(3))-T11*RI(3)/RIM);

    VF(1) = -R11*(S11*(RI(1)-RF(1))+T11*RF(1)/RFM);
    VF(2) = -R11*(S11*(RI(2)-RF(2))+T11*RF(2)/RFM);
    VF(3) = -R11*(S11*(RI(3)-RF(3))+T11*RF(3)/RFM);

    

end

% -----------------------------------------------------------------
% Izzo's version:
% Very fast, but not very robust for more complicated cases
% -----------------------------------------------------------------
function [V1, V2, exitflag] = lambert_MEXIFY(r1vec, r2vec, tf, m, muC)

% original documentation:
%{
 This routine implements a new algorithm that solves Lambert's problem. The
 algorithm has two major characteristics that makes it favorable to other
 existing ones.
 1) It describes the generic orbit solution of the boundary condition
 problem through the variable X=log(1+cos(alpha/2)). By doing so the
 graph of the time of flight become defined in the entire real axis and
 resembles a straight line. Convergence is granted within few iterations
 for all the possible geometries (except, of course, when the transfer
 angle is zero). When multiple revolutions are considered the variable is
 X=tan(cos(alpha/2)*pi/2).
 2) Once the orbit has been determined in the plane, this routine
 evaluates the velocity vectors at the two points in a way that is not
 singular for the transfer angle approaching to pi (Lagrange coefficient
 based methods are numerically not well suited for this purpose).
 As a result Lambert's problem is solved (with multiple revolutions
 being accounted for) with the same computational effort for all
 possible geometries. The case of near 180 transfers is also solved
 efficiently.
  We note here that even when the transfer angle is exactly equal to pi
 the algorithm does solve the problem in the plane (it finds X), but it
 is not able to evaluate the plane in which the orbit lies. A solution
 to this would be to provide the direction of the plane containing the
 transfer orbit from outside. This has not been implemented in this
 routine since such a direction would depend on which application the
 transfer is going to be used in.
 please report bugs to dario.izzo@esa.int
%}

% adjusted documentation:
%{
 For problems with |m| > 0, there are generally two solutions. By
 default, the right branch solution will be returned. The left branch
 may be requested by giving a negative value to the corresponding
 number of complete revolutions [m].
%}

% Authors
% .-`-.-`-.-`-.-`-.-`-.-`-.-`-.-`-.-`-.-`-.-`-.-`-.-`-.-`-.-`-.
% Name       : Dr. Dario Izzo
% E-mail     : dario.izzo@esa.int
% Affiliation: ESA / Advanced Concepts Team (ACT)

% Made more readible and optimized for speed by Rody P.S. Oldenhuis
% Code available in MGA.M on   http://www.esa.int/gsp/ACT/inf/op/globopt.htm

% last edited 12/Dec/2009

% ADJUSTED FOR EML-COMPILATION 24/Dec/2009

    % initial values
    tol = 1e-14;    bad = false; TWOPI = 2*pi; PI = pi;
    
    % work with non-dimensional units
    r1 = norm(r1vec);          r1vec = r1vec/r1;
    V = sqrt(muC/r1);          r2vec = r2vec/r1;
    T = r1/V;                  tf    = tf/T; % also transform to seconds

    % relevant geometry parameters (non dimensional)
    mr2vec = sqrt(r2vec*r2vec.');
    % make 100% sure it's in (-1 <= dth <= +1)
    dth = acos( max(-1, min(1, (r1vec*r2vec.')/mr2vec)) );

    % decide whether to use the left or right branch (for multi-revolution
    % problems), and the long- or short way
    leftbranch = sign(m);
    longway    = sign(r1vec(1)*r2vec(2) - r1vec(2)*r2vec(1));
    
    m  = abs(m);
    tf = abs(tf);
    if (longway < 0), dth = TWOPI - dth; end

    % derived quantities
    c      = sqrt(1 + mr2vec^2 - 2*mr2vec*cos(dth)); % non-dimensional chord
    s      = (1 + mr2vec + c)/2;                     % non-dimensional semi-perimeter
    a_min  = s/2;                                    % minimum energy ellipse semi major axis
    Lambda = sqrt(mr2vec)*cos(dth/2)/s;              % lambda parameter (from BATTIN's book)
    crossprd = cross(r1vec, r2vec);
    mcr       = sqrt(crossprd*crossprd.');           % magnitues thereof
    nrmunit   = crossprd/mcr;                        % unit vector thereof

    % Initial values
    % ---------------------------------------------------------

    % ELMEX requires this variable to be declared OUTSIDE the IF-statement
    logt = log(tf); % avoid re-computing the same value

    % single revolution (1 solution)
    if (m == 0)

        % initial values
        inn1 = -0.5233;      % first initial guess
        inn2 = +0.5233;      % second initial guess
        x1   = log(1 + inn1);% transformed first initial guess
        x2   = log(1 + inn2);% transformed first second guess

        % multiple revolutions (0, 1 or 2 solutions)
        % the returned soltuion depends on the sign of [m]
    else
        % select initial values
        if (leftbranch < 0)
            inn1 = -0.5234; % first initial guess, left branch
            inn2 = -0.2234; % second initial guess, left branch
        else
            inn1 = +0.7234; % first initial guess, right branch
            inn2 = +0.5234; % second initial guess, right branch
        end
        x1 = tan(inn1*TWOPI/4);% transformed first initial guess
        x2 = tan(inn2*TWOPI/4);% transformed first second guess
    end

    % since (inn1, inn2) < 0, initial estimate is always ellipse
    xx   = [inn1, inn2];  aa = a_min./(1 - xx.^2);
    bbeta = longway * 2*asin(sqrt((s-c)/2./aa));
    % make 100.4% sure it's in (-1 <= xx <= +1)
    aalfa = 2*acos(  max(-1, min(1, xx)) );

    % evaluate the time of flight via Lagrange expression
    y12  = aa.*sqrt(aa).*((aalfa - sin(aalfa)) - (bbeta-sin(bbeta)) + TWOPI*m);

    % initial estimates for y
    if m == 0
        y1 = log(y12(1)) - logt;
        y2 = log(y12(2)) - logt;
    else
        y1 = y12(1) - tf;
        y2 = y12(2) - tf;
    end

    % Solve for x
    % ---------------------------------------------------------

    % Newton-Raphson iterations
    % NOTE - the number of iterations will go to infinity in case
    % m > 0  and there is no solution. Start the other routine in
    % that case
    err = inf;  iterations = 0; xnew = 0;
    while (err > tol)
        % increment number of iterations
        iterations = iterations + 1;
        % new x
        xnew = (x1*y2 - y1*x2) / (y2-y1);
        % copy-pasted code (for performance)
        if m == 0, x = exp(xnew) - 1; else x = atan(xnew)*2/(PI); end
        a = a_min/(1 - x^2);
        if (x < 1) % ellipse
            beta = longway * 2*asin(sqrt((s-c)/2/a));
            % make 100.4% sure it's in (-1 <= xx <= +1)
            alfa = 2*acos( max(-1, min(1, x)) );
        else % hyperbola
            alfa = 2*acosh(x);
            beta = longway * 2*asinh(sqrt((s-c)/(-2*a)));
        end
        % evaluate the time of flight via Lagrange expression
        if (a > 0)
            tof = a*sqrt(a)*((alfa - sin(alfa)) - (beta-sin(beta)) + TWOPI*m);
        else
            tof = -a*sqrt(-a)*((sinh(alfa) - alfa) - (sinh(beta) - beta));
        end
        % new value of y
        if m ==0, ynew = log(tof) - logt; else ynew = tof - tf; end
        % save previous and current values for the next iterarion
        % (prevents getting stuck between two values)
        x1 = x2;  x2 = xnew;
        y1 = y2;  y2 = ynew;
        % update error
        err = abs(x1 - xnew);
        % escape clause
        if (iterations > 15), bad = true; break; end
    end

    % If the Newton-Raphson scheme failed, try to solve the problem
    % with the other Lambert targeter.
    if bad
        % NOTE: use the original, UN-normalized quantities
        [V1, V2, exitflag] = lambert_LancasterBlanchard(r1vec*r1, r2vec*r1, longway*tf*T, leftbranch*m, muC, TWOPI);
        return
    end

    % convert converged value of x
    if m==0, x = exp(xnew) - 1; else x = atan(xnew)*2/(PI); end

    %{
      The solution has been evaluated in terms of log(x+1) or tan(x*pi/2), we
      now need the conic. As for transfer angles near to pi the Lagrange-
      coefficients technique goes singular (dg approaches a zero/zero that is
      numerically bad) we here use a different technique for those cases. When
      the transfer angle is exactly equal to pi, then the ih unit vector is not
      determined. The remaining equations, though, are still valid.
    %}

    % Solution for the semi-major axis
    a = a_min/(1-x^2);

    % Calculate psi
    if (x < 1) % ellipse
        beta = longway * 2*asin(sqrt((s-c)/2/a));
        % make 100.4% sure it's in (-1 <= xx <= +1)
        alfa = 2*acos( max(-1, min(1, x)) );
        psi  = (alfa-beta)/2;
        eta2 = 2*a*sin(psi)^2/s;
        eta  = sqrt(eta2);
    else       % hyperbola
        beta = longway * 2*asinh(sqrt((c-s)/2/a));
        alfa = 2*acosh(x);
        psi  = (alfa-beta)/2;
        eta2 = -2*a*sinh(psi)^2/s;
        eta  = sqrt(eta2);
    end

    % unit of the normalized normal vector
    ih = longway * nrmunit;

    % unit vector for normalized [r2vec]
    r2n = r2vec/mr2vec;

    % cross-products
    % don't use cross() (emlmex() would try to compile it, and this way it
    % also does not create any additional overhead)
    crsprd1 = [ih(2)*r1vec(3)-ih(3)*r1vec(2),...
               ih(3)*r1vec(1)-ih(1)*r1vec(3),...
               ih(1)*r1vec(2)-ih(2)*r1vec(1)];
    crsprd2 = [ih(2)*r2n(3)-ih(3)*r2n(2),...
               ih(3)*r2n(1)-ih(1)*r2n(3),...
               ih(1)*r2n(2)-ih(2)*r2n(1)];

    % radial and tangential directions for departure velocity
    Vr1 = 1/eta/sqrt(a_min) * (2*Lambda*a_min - Lambda - x*eta);
    Vt1 = sqrt(mr2vec/a_min/eta2 * sin(dth/2)^2);

    % radial and tangential directions for arrival velocity
    Vt2 = Vt1/mr2vec;
    Vr2 = (Vt1 - Vt2)/tan(dth/2) - Vr1;

    % terminal velocities
    V1 = (Vr1*r1vec + Vt1*crsprd1)*V;
    V2 = (Vr2*r2n + Vt2*crsprd2)*V;

    % exitflag
    exitflag = 1; % (success)

    % also compute minimum distance to central body
    % NOTE: use un-transformed vectors again!
%     extremal_distances = ...
%         minmax_distances(r1vec*r1, r1, r2vec*r1, mr2vec*r1, dth, a*r1, V1, V2, m, muC);

end

% -----------------------------------------------------------------
% Lancaster & Blanchard version, with improvements by Gooding
% Very reliable, moderately fast for both simple and complicated cases
% -----------------------------------------------------------------
function [V1, V2, exitflag] = lambert_LancasterBlanchard(r1vec, r2vec, tf, m, muC, TWOPI)
%{
LAMBERT_LANCASTERBLANCHARD       High-Thrust Lambert-targeter
lambert_LancasterBlanchard() uses the method developed by
Lancaster & Blancard, as described in their 1969 paper. Initial values,
and several details of the procedure, are provided by R.H. Gooding,
as described in his 1990 paper.
%}

% Please report bugs and inquiries to:
%
% Name       : Rody P.S. Oldenhuis
% E-mail     : oldenhuis@gmail.com
% Licence    : 2-clause BSD (see License.txt)


% If you find this work useful, please consider a donation:
% https://www.paypal.me/RodyO/3.5

    % ADJUSTED FOR EML-COMPILATION 29/Sep/2009

    PI = TWOPI/2;
    
    % manipulate input
    tol     = 1e-12;                            % optimum for numerical noise v.s. actual precision
    r1      = sqrt(r1vec*r1vec.');              % magnitude of r1vec
    r2      = sqrt(r2vec*r2vec.');              % magnitude of r2vec
    r1unit  = r1vec/r1;                         % unit vector of r1vec
    r2unit  = r2vec/r2;                         % unit vector of r2vec
    crsprod = cross(r1vec, r2vec, 2);           % cross product of r1vec and r2vec
    mcrsprd = sqrt(crsprod*crsprod.');          % magnitude of that cross product
    th1unit = cross(crsprod/mcrsprd, r1unit);   % unit vectors in the tangential-directions
    th2unit = cross(crsprod/mcrsprd, r2unit);
    % make 100.4% sure it's in (-1 <= x <= +1)
    dth = acos( max(-1, min(1, (r1vec*r2vec.')/r1/r2)) ); % turn angle

    % if the long way was selected, the turn-angle must be negative
    % to take care of the direction of final velocity
    longway = sign(tf); tf = abs(tf);
    if (longway < 0), dth = dth-TWOPI; end

    % left-branch
    leftbranch = sign(m); m = abs(m);

    % define constants
    c  = sqrt(r1^2 + r2^2 - 2*r1*r2*cos(dth));
    s  = (r1 + r2 + c) / 2;
    T  = sqrt(8*muC/s^3) * tf;
    q  = sqrt(r1*r2)/s * cos(dth/2);

    % general formulae for the initial values (Gooding)
    % -------------------------------------------------

    % some initial values
    T0  = LancasterBlanchard(0, q, m, PI);
    Td  = T0 - T;
    phr = mod(2*atan2(1 - q^2, 2*q), TWOPI);

    % initial output is pessimistic
    V1 = NaN(1,3);    V2 = V1;    % extremal_distances = [NaN, NaN];

    % single-revolution case
    if (m == 0)
        x01 = T0*Td/4/T;
        if (Td > 0)
            x0 = x01;
        else
            x01 = Td/(4 - Td);
            x02 = -sqrt( -Td/(T+T0/2) );
            W   = x01 + 1.7*sqrt(2 - phr/(PI));
            if (W >= 0)
                x03 = x01;
            else
                x03 = x01 + (-W).^(1/16).*(x02 - x01);
            end
            lambda = 1 + x03*(1 + x01)/2 - 0.03*x03^2*sqrt(1 + x01);
            x0 = lambda*x03;
        end

        % this estimate might not give a solution
        if (x0 < -1), exitflag = -1; return; end

    % multi-revolution case
    else

        % determine minimum Tp(x)
        xMpi = 4/(3*(PI)*(2*m + 1));
        if (phr < PI)
            xM0 = xMpi*(phr/(PI))^(1/8);
        elseif (phr > (PI))
            xM0 = xMpi*(2 - (2 - phr/(PI))^(1/8));
        % EMLMEX requires this one
        else
            xM0 = 0;
        end

        % use Halley's method
        xM = xM0;  Tp = inf;  iterations = 0;
        while abs(Tp) > tol
            % iterations
            iterations = iterations + 1;
            % compute first three derivatives
            [dummy, Tp, Tpp, Tppp] = LancasterBlanchard(xM, q, m, PI);%#ok
            % new value of xM
            xMp = xM;
            xM  = xM - 2*Tp.*Tpp ./ (2*Tpp.^2 - Tp.*Tppp);
            % escape clause
            if mod(iterations, 7), xM = (xMp+xM)/2; end
            % the method might fail. Exit in that case
            if (iterations > 25), exitflag = -2; return; end
        end

        % xM should be elliptic (-1 < x < 1)
        % (this should be impossible to go wrong)
        if (xM < -1) || (xM > 1), exitflag = -1; return; end

        % corresponding time
        TM = LancasterBlanchard(xM, q, m, PI);

        % T should lie above the minimum T
        if (TM > T), exitflag = -1; return; end

        % find two initial values for second solution (again with lambda-type patch)
        % --------------------------------------------------------------------------

        % some initial values
        TmTM  = T - TM;   T0mTM = T0 - TM;
        [dummy, Tp, Tpp] = LancasterBlanchard(xM, q, m, PI);%#ok

        % first estimate (only if m > 0)
        if leftbranch > 0
            x   = sqrt( TmTM / (Tpp/2 + TmTM/(1-xM)^2) );
            W   = xM + x;
            W   = 4*W/(4 + TmTM) + (1 - W)^2;
            x0  = x*(1 - (1 + m + (dth - 1/2)) / ...
                (1 + 0.15*m)*x*(W/2 + 0.03*x*sqrt(W))) + xM;

            % first estimate might not be able to yield possible solution
            if (x0 > 1), exitflag = -1; return; end

        % second estimate (only if m > 0)
        else
            if (Td > 0)
                x0 = xM - sqrt(TM/(Tpp/2 - TmTM*(Tpp/2/T0mTM - 1/xM^2)));
            else
                x00 = Td / (4 - Td);
                W = x00 + 1.7*sqrt(2*(1 - phr));
                if (W >= 0)
                    x03 = x00;
                else
                    x03 = x00 - sqrt((-W)^(1/8))*(x00 + sqrt(-Td/(1.5*T0 - Td)));
                end
                W      = 4/(4 - Td);
                lambda = (1 + (1 + m + 0.24*(dth - 1/2)) / ...
                    (1 + 0.15*m)*x03*(W/2 - 0.03*x03*sqrt(W)));
                x0     = x03*lambda;
            end

            % estimate might not give solutions
            if (x0 < -1), exitflag = -1; return; end

        end
    end

    % find root of Lancaster & Blancard's function
    % --------------------------------------------

    % (Halley's method)
    x = x0; Tx = inf; iterations = 0;
    while abs(Tx) > tol
        % iterations
        iterations = iterations + 1;
        % compute function value, and first two derivatives
        [Tx, Tp, Tpp] = LancasterBlanchard(x, q, m, PI);
        % find the root of the *difference* between the
        % function value [T_x] and the required time [T]
        Tx = Tx - T;
        % new value of x
        xp = x;
        x  = x - 2*Tx*Tp ./ (2*Tp^2 - Tx*Tpp);
        % escape clause
        if mod(iterations, 7), x = (xp+x)/2; end
        % Halley's method might fail
        if iterations > 25, exitflag = -2; return; end
    end

    % calculate terminal velocities
    % -----------------------------

    % constants required for this calculation
    gamma = sqrt(muC*s/2);
    if (c == 0)
        sigma = 1;
        rho   = 0;
        z     = abs(x);
    else
        sigma = 2*sqrt(r1*r2/(c^2)) * sin(dth/2);
        rho   = (r1 - r2)/c;
        z     = sqrt(1 + q^2*(x^2 - 1));
    end

    % radial component
    Vr1    = +gamma*((q*z - x) - rho*(q*z + x)) / r1;
    Vr1vec = Vr1*r1unit;
    Vr2    = -gamma*((q*z - x) + rho*(q*z + x)) / r2;
    Vr2vec = Vr2*r2unit;

    % tangential component
    Vtan1    = sigma * gamma * (z + q*x) / r1;
    Vtan1vec = Vtan1 * th1unit;
    Vtan2    = sigma * gamma * (z + q*x) / r2;
    Vtan2vec = Vtan2 * th2unit;

    % Cartesian velocity
    V1 = Vtan1vec + Vr1vec;
    V2 = Vtan2vec + Vr2vec;

    % exitflag
    exitflag = 1; % (success)

    % also determine minimum/maximum distance
%     a = s/2/(1 - x^2); % semi-major axis
%     extremal_distances = minmax_distances(r1vec, r1, r1vec, r2, dth, a, V1, V2, m, muC);

end

% Lancaster & Blanchard's function, and three derivatives thereof
function [T, Tp, Tpp, Tppp] = LancasterBlanchard(x, q, m, PI)

    % protection against idiotic input
    if (x < -1) % impossible; negative eccentricity
        x = abs(x) - 2;
    elseif (x == -1) % impossible; offset x slightly
        x = x + eps;
    end

    % compute parameter E
    E  = x*x - 1;

    % T(x), T'(x), T''(x)
    if x == 1 % exactly parabolic; solutions known exactly
        % T(x)
        T = 4/3*(1-q^3);
        % T'(x)
        Tp = 4/5*(q^5 - 1);
        % T''(x)
        Tpp = Tp + 120/70*(1 - q^7);
        % T'''(x)
        Tppp = 3*(Tpp - Tp) + 2400/1080*(q^9 - 1);

    elseif abs(x-1) < 1e-2 % near-parabolic; compute with series
        % evaluate sigma
        [sig1, dsigdx1, d2sigdx21, d3sigdx31] = sigmax(-E);
        [sig2, dsigdx2, d2sigdx22, d3sigdx32] = sigmax(-E*q*q);
        % T(x)
        T = sig1 - q^3*sig2;
        % T'(x)
        Tp = 2*x*(q^5*dsigdx2 - dsigdx1);
        % T''(x)
        Tpp = Tp/x + 4*x^2*(d2sigdx21 - q^7*d2sigdx22);
        % T'''(x)
        Tppp = 3*(Tpp-Tp/x)/x + 8*x*x*(q^9*d3sigdx32 - d3sigdx31);

    else % all other cases
        % compute all substitution functions
        y  = sqrt(abs(E));
        z  = sqrt(1 + q^2*E);
        f  = y*(z - q*x);
        g  = x*z - q*E;

        % BUGFIX: (Simon Tardivel) this line is incorrect for E==0 and f+g==0
        % d  = (E < 0)*(atan2(f, g) + pi*m) + (E > 0)*log( max(0, f + g) );
        % it should be written out like so:
        if (E<0)
            d = atan2(f, g) + PI*m;
        elseif (E==0)
            d = 0;
        else
            d = log(max(0, f+g));
        end

        % T(x)
        T = 2*(x - q*z - d/y)/E;
        %  T'(x)
        Tp = (4 - 4*q^3*x/z - 3*x*T)/E;
        % T''(x)
        Tpp = (-4*q^3/z * (1 - q^2*x^2/z^2) - 3*T - 3*x*Tp)/E;
        % T'''(x)
        Tppp = (4*q^3/z^2*((1 - q^2*x^2/z^2) + 2*q^2*x/z^2*(z - x)) - 8*Tp - 7*x*Tpp)/E;

    end
end

% series approximation to T(x) and its derivatives
% (used for near-parabolic cases)
function [sig, dsigdx, d2sigdx2, d3sigdx3] = sigmax(y)

    % preload the factors [an]
    % (25 factors is more than enough for 16-digit accuracy)
    persistent an;
    if isempty(an)
        an = [
            4.000000000000000e-001;     2.142857142857143e-001;     4.629629629629630e-002
            6.628787878787879e-003;     7.211538461538461e-004;     6.365740740740740e-005
            4.741479925303455e-006;     3.059406328320802e-007;     1.742836409255060e-008
            8.892477331109578e-010;     4.110111531986532e-011;     1.736709384841458e-012
            6.759767240041426e-014;     2.439123386614026e-015;     8.203411614538007e-017
            2.583771576869575e-018;     7.652331327976716e-020;     2.138860629743989e-021
            5.659959451165552e-023;     1.422104833817366e-024;     3.401398483272306e-026
            7.762544304774155e-028;     1.693916882090479e-029;     3.541295006766860e-031
            7.105336187804402e-033];
    end

    % powers of y
    powers = y.^(1:25);

    % sigma itself
    sig = 4/3 + powers*an;

    % dsigma / dx (derivative)
    dsigdx = ( (1:25).*[1, powers(1:24)] ) * an;

    % d2sigma / dx2 (second derivative)
    d2sigdx2 = ( (1:25).*(0:24).*[1/y, 1, powers(1:23)] ) * an;

    % d3sigma / dx3 (third derivative)
    d3sigdx3 = ( (1:25).*(0:24).*(-1:23).*[1/y/y, 1/y, 1, powers(1:22)] ) * an;

end


