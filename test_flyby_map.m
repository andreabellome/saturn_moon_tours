
clear all; close all; clc; format long g;
addpath(genpath([pwd '/AUTOMATE']));

%% 

idcentral = 6;
idMoon    = 1;

strucNorm = wrapNormCR3BP(idcentral, idMoon);
mu        = strucNorm.normMu;
[~, RS]   = planetConstants(idcentral);

ra0        = 5.06751*RS/strucNorm.normDist;
rp0        = 4.09668*RS/strucNorm.normDist;
lambdaTest = deg2rad([-5:0.1:5]);

dvTol = 0.5; % km/s

n  = 13;
m  = 11;
kk = 0:m-1;

% --> find all the TILTs
MAT = wrapGenerateMAT(ra0, rp0, lambdaTest, n, m, kk, strucNorm, idcentral, idMoon);

% --> prune
MAT = wrapPruningMAT(MAT, dvTol, strucNorm);

[maxDist, rowMaxDist] = max(abs(MAT(:,10) - MAT(:,7)));

indmat = 58;
[ra0, rp0, raB0, rpB0, raM, rpM, dv] = extractInfo(MAT, indmat, strucNorm);

plot( ra0*strucNorm.normDist/RS, rp0*strucNorm.normDist/RS, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'cyan');
plot( raB0*strucNorm.normDist/RS, rpB0*strucNorm.normDist/RS, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'yellow');
plot( raM*strucNorm.normDist/RS, rpM*strucNorm.normDist/RS, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'magenta');

RES = findResonances(idMoon, vinfLevDIM, idcentral);
plotResonances(idMoon, RES, [n, m], idcentral);
processLabelPlots( idcentral, idMoon );                                               % --> adjust the lables and scaling

ra0 = raB0;
rp0 = rpB0;
n   = 20;
m   = 17;
kk  = 0:m-1;

MAT2 = wrapGenerateMAT(ra0, rp0, lambdaTest, n, m, kk, strucNorm, idcentral, idMoon);
MAT2 = wrapPruningMAT(MAT2, dvTol, strucNorm);

[maxDist, rowMaxDist] = max(abs(MAT2(:,10) - MAT2(:,7)));
[maxDV, rowMaxDV]     = max(abs(MAT2(:,end-1) - MAT2(:,end-1)));

indmat = rowMaxDist;
[ra0, rp0, raB0, rpB0, raM, rpM, dv] = extractInfo(MAT, indmat, strucNorm);

plot( ra0*strucNorm.normDist/RS, rp0*strucNorm.normDist/RS, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'cyan');
plot( raB0*strucNorm.normDist/RS, rpB0*strucNorm.normDist/RS, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'yellow');
plot( raM*strucNorm.normDist/RS, rpM*strucNorm.normDist/RS, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'magenta');

plotResonances(idMoon, RES, [n, m], idcentral);
processLabelPlots( idcentral, idMoon );                                               % --> adjust the lables and scaling

ra0 = raM;
rp0 = rpM;
n   = 7;
m   = 6;
kk  = 0:m-1;

MAT3 = wrapGenerateMAT(ra0, rp0, lambdaTest, n, m, kk, strucNorm, idcentral, idMoon);
MAT3 = wrapPruningMAT(MAT3, dvTol, strucNorm);

[maxDist, rowMaxDist] = max(abs(MAT3(:,10) - MAT3(:,7)));
[maxDV, rowMaxDV]     = max(abs(MAT3(:,end-1) - MAT3(:,end-1)));

indmat = rowMaxDist;

[ra0, rp0, raB0, rpB0, raM, rpM, dv] = extractInfo(MAT3, indmat, strucNorm);

plot( ra0*strucNorm.normDist/RS, rp0*strucNorm.normDist/RS, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'cyan');
plot( raB0*strucNorm.normDist/RS, rpB0*strucNorm.normDist/RS, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'yellow');
plot( raM*strucNorm.normDist/RS, rpM*strucNorm.normDist/RS, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'magenta');


%%

idcentral = 5;
idMoon    = 2;

% --> norm. var. CR3BP
strucNorm = wrapNormCR3BP(idcentral, idMoon);
strucNorm.normDist = 670974;
strucNorm.normMu   = 2.5266e-5;

mu        = strucNorm.normMu;

[~, RJ] = planetConstants(idcentral);

lambdaTest = deg2rad([-5:0.1:5]);

n  = 13;
m  = 11;
kk = 0:m-1;

dvTol = 0.5; % km/s

for indk = 1:length(kk)
    k = kk(indk);
    STRUC(indk).MAT = wrapGenerateTILT( rp0, ra0, lambdaTest, n, m, k, strucNorm, idcentral, idMoon );
end
MAT = cell2mat({STRUC.MAT}');

indtodel = zeros( size(MAT,1), 1 );
for indm = 1:size(MAT,1)
    if ~isreal(MAT(indm,13))
        if abs(imag(MAT(indm,13))) >= 1e-4
            indtodel(indm) = indm;
        end
    end
end
indtodel(indtodel == 0) = [];
MAT(indtodel,:) = [];

dvsDim = MAT(:,end-1)*strucNorm.normDist/strucNorm.normTime;
indxs = find( dvsDim > dvTol );

MAT(indxs,:) = [];
dvsDim = MAT(:,end-1)*strucNorm.normDist/strucNorm.normTime;

indmat = 1;
raB0 = MAT(indmat,10);
rpB0 = MAT(indmat,11);

plot( raB0*strucNorm.normDist/RS, rpB0*strucNorm.normDist/RS, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'yellow');

%%

% ra0 = 0.99520010;
% rp0 = 0.49000987;
% [ a, T ] = raRp2aT_nonDim( ra0, rp0, mu );
% lambda   = deg2rad( -0.01 );

% a      = 1.31037;
% T      = 2.9789;
% lambda = deg2rad( -3.39 );
% [ra0, rp0] = aT2raRp_nonDim( a, T, mu );


ra0 = 14*RJ/strucNorm.normDist;
rp0 = 9.5*RJ/strucNorm.normDist;
[ a, T ] = raRp2aT_nonDim( ra0, rp0, mu );

lambdaTest = deg2rad([-5:0.1:5]);

n = 4;
m = 3;
k = 0;
dvTol = 0.5; % km/s

MAT = wrapGenerateTILT( rp0, ra0, lambdaTest, n, m, k, strucNorm, idcentral, idMoon );

dvsDim = MAT(:,end-1)*strucNorm.normDist/strucNorm.normTime;
indxs = find( dvsDim > dvTol );

MAT(indxs,:) = [];

%%
for indl = 1:length(lambdaTest)

    close all; clc;

    lambda = lambdaTest(indl);

    param.adim = 0;
    fig3       = plot_tp_graph(idcentral, idMoon, [ 0.2:0.1:1.6 ], 4, 1e3, param); % --> plot TP graph
    xlim([9, 17.5]);
    ylim([9, 10.2]);
    
    
    % --> check that IC are within SigmaA
    [x, y, xdot, ydot, isInSA] = isIC_InSigmaA( a, T, lambda, mu );
    [ ac, Tc, lambdac, fc ]    = phi_direct( x, y, xdot, ydot, mu );
    
    tlim = 100;
    
    opt       = odeset('RelTol', 3e-13, 'AbsTol', 1e-13 );
    pars.mu   = mu;
    xx0       = [ x, y, 0, xdot, ydot, 0 ];
    [tt, yy1] = ode113( @(t, x) f_CR3BP(x, pars), linspace(0, tlim, 15e3), xx0, opt );
    
    [ ~, ~, ~, ~, ~, ~, ~, rra, rrp ] = wrapParamEvolution( tt, yy1, mu );
    
    hold on;
    plot( rra*strucNorm.normDist/RJ, rrp*strucNorm.normDist/RJ, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'cyan');
    plot( ra0*strucNorm.normDist/RJ, rp0*strucNorm.normDist/RJ, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'yellow');
    
    [ ttPostFB, yyPostFB, locsPostFB1, aa, TT, llambda, ff, ffstar, ...
        RR2, RR2PostFB, Rhill, ffPostFB, ffstarPostFB ] = ...
        wrapFindEventsFBmap( tt, yy1, mu );
    
    if ~isnan(locsPostFB1)
    
        [ ~, ~, ~, ~, ~, ~, ~, rraPFB, rrpPFB ] = wrapParamEvolution( tt, yy1(1:locsPostFB1(end),:), mu );
        % plot( rraPFB*strucNorm.normDist/RJ, rrpPFB*strucNorm.normDist/RJ, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'magenta');
        
        
        n       = 4;
        m       = 3;
        k       = 0;
        indStop = length(locsPostFB1); % --> take the (n-k) SigmaB crossing
        
        tte = tt(1:locsPostFB1(indStop));
        yye = yy1(1:locsPostFB1(indStop),:);

        [~, ~, ~, radius, hmin] = constants(idcentral, idMoon);
    
        if min(RR2(1:locsPostFB1(indStop))) >= (radius + hmin)/strucNorm.normDist
        
            yyeEnd                        = yy1( locsPostFB1(indStop),: );
            [ ~, ~, ~, ~, ~, RR2, Rhill ] = wrapParamEvolution( tt, yyeEnd, mu );
            RR2 >= 5*Rhill
            
            
            [ aB0, TB0, lambdaB0, fB0 ] = phi_direct( yye(end,1), yye(end,2), yye(end,4), yye(end,5), mu );
            [ raB0, rpB0 ]              = aT2raRp_nonDim( aB0, TB0, mu );
            
            plot( raB0*strucNorm.normDist/RJ, rpB0*strucNorm.normDist/RJ, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'yellow');
            
            vB0                         = velBeforeTILT_nonDim(raB0, rpB0, aB0, mu);
            [ vAk1, vcAk1, aAm ]        = velAfterTILT_nonDim(aB0, vB0, n, m, k, mu);
%             (1 - mu)*( 0.5*( (1 - mu)/(aAm) - vAk1^2 ) )^(-1)
%             (1 - mu)*( 0.5*( (1 - mu)/(aB0) - vB0^2 ) )^(-1)
            
            if aB0 > 1
                raAm = raB0;
                rpAm = raB0*(vAk1/vcAk1)^2;
            elseif aB0 < 1
                raAm = rpB0*(vAk1/vcAk1)^2;
                rpAm = rpB0;
            end
            [ aAm, TAm ] = raRp2aT_nonDim( raAm, rpAm, mu );
            
            plot( raAm*strucNorm.normDist/RJ, rpAm*strucNorm.normDist/RJ, 'o', 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'magenta');
            
            dv = abs( vAk1 - vB0 )*strucNorm.normDist/strucNorm.normTime;
            
            MATSAVE(IND,:) = [ idMoon, n, m, k, ra0, rp0, lambda, raB0, rpB0, raAm, rpAm, abs( vAk1 - vB0 ), 2*pi*n  ];
            IND            = IND + 1;

            if dv < 0.4 && dv > 0.2 
    
                if vAk1 - vB0 > 0
        
                    rp0*strucNorm.normDist/RJ
                    rpB0*strucNorm.normDist/RJ
                    raB0*strucNorm.normDist/RJ
    
                end
    
            end

        end

    end

end

%%

a      = 1.31037;
T      = 2.9789;
lambda = deg2rad( 2.76 );

% --> check that IC are within SigmaA
[x, y, xdot, ydot, isInSA] = isIC_InSigmaA( a, T, lambda, mu );
[ a, T, lambda, f ]        = phi_direct( x, y, xdot, ydot, mu );

opt       = odeset('RelTol', 3e-13, 'AbsTol', 1e-13 );
pars.mu   = mu;
xx0       = [ x, y, 0, xdot, ydot, 0 ];
[tt, yy2] = ode113( @(t, x) f_CR3BP(x, pars), linspace(0, tlim, 15e3), xx0, opt );

[ ttPostFB, yyPostFB, locsPostFB2, aa, TT, llambda, ff, ffstar,...
    RR2, RR2PostFB, Rhill, ffPostFB, ffstarPostFB ] = ...
    wrapFindEventsFBmap( tt, yy2, mu );

indStop = 1;

close all; clc;

figure( 'Color', [1 1 1] );
hold on; grid on; axis equal;
plot( strucNorm.x1, 0, 'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Yellow' );
plot( strucNorm.x2, 0, 'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Magenta' );
plot( yy1(1:locsPostFB1(indStop),1), yy1(1:locsPostFB1(indStop),2), 'linewidth', 2, 'Color', 'magenta' );
plot( yy1(locsPostFB1(indStop),1), yy1(locsPostFB1(indStop),2), 'd' );

plot( yy1(1,1), yy1(1,2), 'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'cyan' );

plot( yy2(1:locsPostFB2(indStop),1), yy2(1:locsPostFB2(indStop),2), 'linewidth', 2, 'Color', 'blue' );


figure( 'Color', [1 1 1] );
hold on; grid on; axis equal;
plot( tt, ff );
plot( ttPostFB, ffPostFB, 'LineWidth', 2 );
plot( ttPostFB, ffstarPostFB, 'LineWidth', 1 );
plot( tt(locsPostFB1), ff(locsPostFB1), 'o' );

%%

idcentral = 5;
idMoon    = 3;

% --> norm. var. CR3BP
strucNorm = wrapNormCR3BP(idcentral, idMoon);
mu        = strucNorm.normMu;

a      = 1.31037;
T      = 2.9789;
lambda = deg2rad( -2.95 );

% --> check that IC are within SigmaA
[x, y, xdot, ydot, isInSA] = isIC_InSigmaA( a, T, lambda, mu );
[ a, T, lambda, f ]        = phi_direct( x, y, xdot, ydot, mu );

tlim            = 100;
opt             = odeset('RelTol', 3e-13, 'AbsTol', 1e-13 );
pars.mu         = mu;
xx0             = [ x, y, 0, xdot, ydot, 0 ];
[tt, yy2]       = ode113( @(t, x) f_CR3BP(x, pars), linspace(0, tlim, 100e3), xx0, opt );

[ ttPostFB, yyPostFB, locsPostFB, aa, TT, llambda, ff, ffstar, RR2, RR2PostFB, Rhill, ffPostFB, ffstarPostFB ] = ...
    wrapFindEventsFBmap( tt, yy2, mu );

mat     = [ RR2(locsPostFB) locsPostFB ];
indexes = mat( mat(:,1) >= 5*Rhill,2 ); % --> this is for yy2

locs2       = islocalmin(ff, 'FlatSelection', 'all');


close all; clc;

figure( 'Color', [1 1 1] );
hold on; grid on; axis equal;
plot( tt, ff );
plot( ttPostFB, ffPostFB, 'LineWidth', 2 );
plot( ttPostFB, ffstarPostFB, 'LineWidth', 1 );
plot( tt(locsPostFB), ff(locsPostFB), 'o' );


plot( P(1,:), P(2,:), 'o' );

plot( tt, abs( ff - ffstar ), 'LineWidth', 1 );

plot( ttPostFB(indices), ffPostFB(indices), 'o' );
plot( ttPostFB(indicesNext), ffPostFB(indicesNext), 'o' );


plot( tt, ffstar );

plot( tt(indexes), ff(indexes), 'o' );
plot( tt(locs2), ff(locsPostFB), 'o' );

plot( tt(startFBind:endFBind), ff(startFBind:endFBind), 'LineWidth', 2 );



figure( 'Color', [1 1 1] );
hold on; grid on; axis equal;
plot( tt, RR2 );
plot( tt, Rhill*ones(length(tt),1) );

% figure( 'Color', [1 1 1] );
% hold on; grid on; axis equal;
% 
% plot( yy2(:,1), yy2(:,2), 'linewidth', 2, 'Color', 'blue' );
% plot( yy2(1,1), yy2(1,2), 'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'cyan' );
% 
% plot( yy2(indtosave,1), yy2(indtosave,2), 'o', 'MarkerSize', 5, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'red' );
% 
% plot( strucNorm.x1, 0, 'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Yellow' );
% plot( strucNorm.x2, 0, 'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Magenta' );

% yyt = yy2(indtosave(10),:);
% 
% [ at, Tt, lambdat, ft ] = phi_direct( yyt(1), yyt(2), yyt(4), yyt(5), mu );
% at * strucNorm.normDist

%%

close all; clc;

figure( 'Color', [1 1 1] );
hold on; grid on; axis equal;
plot( yy1(:,1), yy1(:,2), 'linewidth', 2, 'Color', 'magenta' );
plot( yy2(:,1), yy2(:,2), 'linewidth', 2, 'Color', 'blue' );

plot( strucNorm.x1, 0, 'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Yellow' );
plot( strucNorm.x2, 0, 'o', 'MarkerSize', 8, 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', 'Magenta' );


