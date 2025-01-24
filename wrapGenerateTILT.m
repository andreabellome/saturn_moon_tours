function [MAT] = wrapGenerateTILT( rp0, ra0, lambdaTest, n, m, k, strucNorm, idcentral, idMoon )

mu = strucNorm.normMu;

MAT = [];
IND = 1;

[ a, T ] = raRp2aT_nonDim( ra0, rp0, mu );

for indl = 1:length(lambdaTest)

    indl/length(lambdaTest)*100;

    lambda = lambdaTest(indl);
    
    % --> check that IC are within SigmaA
    [x, y, xdot, ydot, isInSA] = isIC_InSigmaA( a, T, lambda, mu );
    
    if isInSA == 1
        tlim = 100;
        
        opt       = odeset('RelTol', 3e-13, 'AbsTol', 1e-13 );
        pars.mu   = mu;
        xx0       = [ x, y, 0, xdot, ydot, 0 ];
        [tt, yy1] = ode113( @(t, x) f_CR3BP(x, pars), linspace(0, tlim, 15e3), xx0, opt );
        
        [ ~, ~, locsPostFB1, ~, ~, ~, ~, ~, ...
            RR2tocheck, ~, ~, ~, ~ ] = ...
            wrapFindEventsFBmap( tt, yy1, mu );
        
        if ~isnan(locsPostFB1)
            
            for indStop = 1:length(locsPostFB1)
    
                tte = tt(1:locsPostFB1(indStop));
                yye = yy1(1:locsPostFB1(indStop),:);
        
                [~, ~, ~, radius, hmin] = constants(idcentral, idMoon);
            
                if min(RR2tocheck(1:locsPostFB1(indStop))) >= (radius + hmin)/strucNorm.normDist
                
                    yyeEnd                        = yy1( locsPostFB1(indStop),: );
                    [ ~, ~, ~, ~, ~, RR2, Rhill ] = wrapParamEvolution( tt, yyeEnd, mu );
        
                    if RR2 >= 5*Rhill
                    
                    
                        [ aB0, TB0, ~, ~ ] = phi_direct( yye(end,1), yye(end,2), yye(end,4), yye(end,5), mu );
                        [ raB0, rpB0 ]              = aT2raRp_nonDim( aB0, TB0, mu );
                        
                        
                        vB0                       = velBeforeTILT_nonDim(raB0, rpB0, aB0, mu);
                        [ vAk1, vcAk1, ~ ]        = velAfterTILT_nonDim(aB0, vB0, n, m, k, mu);
        
                        
                        if aB0 > 1
                            raAm = raB0;
                            rpAm = raB0*(vAk1/vcAk1)^2;
                            kei  = 1;
                        elseif aB0 < 1
                            raAm = rpB0*(vAk1/vcAk1)^2;
                            rpAm = rpB0;
                            kei  = -1;
                        end
                        
                        MAT(IND,:) = [ idMoon, kei, n, m, k, indStop, ra0, rp0, lambda, raB0, rpB0, raAm, rpAm, abs( vAk1 - vB0 ), 2*pi*n  ];
                        IND        = IND + 1;
                
                    end
                end

            end
    
        end

    end

end


end