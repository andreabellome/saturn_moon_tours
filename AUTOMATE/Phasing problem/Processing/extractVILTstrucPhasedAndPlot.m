function [VILTstruc, TOUR, fig] = extractVILTstrucPhasedAndPlot(path, INPUT, t0, plotTraj)

% DESCRIPTION
% This function is used to post-process a phased tour from Tisserand
% exploration and to plot it.
% 
% INPUT
% - path : structure where each row is a tour for a different moon phase.
%          This is considered to have phasing!
%            It has the following fields:
%            - path : matrix with tour on specific phase. 
%            - dvPhase : DV total for the given phase [km/s]
%            - tofPhase : time of flight for the given phase [days]
%            - dvOI     : DV for orbit insertion only valid for the last
%            phase (see also orbitInsertion.m)
% - INPUT : structure with the following mandatory fields:
%           - idcentral    : ID of the central body (see constants.m)
%           - phasingOptions : structure with phasing options (see
%           writeInPhasing.m for example)
% - t0       : initial date of the tour [MJD2000]
% - plotTraj : optional input. If 1, the phased trajectory is plotted.
%              Default is 0.
% 
% OUTPUT
% - VILTstruc : structure with the following fields (each row is a leg):
%           - id1 : ID of the first flyby body (see constants.m)
%           - t1 : initial epoch [MJD2000]
%           - id2 : ID of the arrival flyby body (see constants.m)
%           - t2 : final epoch [MJD2000]
%           - rr1     : 1x3 vector with initial position [km]
%           - vvd     : 1x3 vector with initial velocity [km/s]
%           - rr2     : 1x3 vector with final position [km]
%           - vva     : 1x3 vector with final velocity [km/s]
%           - vv1     : 1x3 vector with velocity of the first moon [km/s]
%           - vv2     : 1x3 vector with velocity of the arrival moon [km/s]
%           - vvinf_dep :  1x3 vector with infinity velocity at the
%           starting moon [km/s]
%           - vvinf_arr : 1x3 vector with infinity velocity at the
%           arrival moon [km/s]
%           - alpha1 : pump angle at the starting moon [rad]
%           - vinf1  : norm of vvinf_dep [km/s] 
%           - alpha2 : pump angle at the arrival moon [rad]
%           - vinf2  : norm of vvinf_arr [km/s] 
%           - dv     : DV manoeuvre of the DSM [km/s]
%           - tof    : time of flight [days]
%           - tof1   : time of flight from first flyby to DSM [days]
%           - tof2   : time of flight from DSM to next flyby [days]
%           - S      : anatomy of the VILT (see wrap_VILT.m)
% 
% - TOUR : this will be removed from future developments.
% - fig  : figure of the trajectory
% -------------------------------------------------------------------------

% --> check the input
if nargin == 3
    plotTraj = 0;
    fig      = [];
elseif nargin == 4
    if isempty(plotTraj)
        plotTraj = 0;
        fig      = [];
    end
end

% --> you are passing the structure, thus you need to convert it
if isstruct(path) 
    
    PATHphNew = path;
    path = [];
    for indp = 1:length(PATHphNew)
        
        if indp == length(PATHphNew)
            path = [ path; PATHphNew(indp).path ];
        else
            path = [ path; PATHphNew(indp).path(1:end-1,:) ];
        end
    
    end

end
% --> end: you are passing the structure, thus you need to convert it

% --> start: check if phasing options are specified in INPUT
if ~isfield(INPUT, 'phasingOptions')
    
    % --> Titan-to-Rhea
    inphasing.perct  = 1.5/100;
    inphasing.toflim = [ 10 45 ];
    inphasing.maxrev = 30;
    inphasing.toldv  = 0.1;
    INPUT.phasingOptions(5) = inphasing;
    
    % --> Rhea-to-Tethys
    inphasing.perct  = 2/100;
    inphasing.toflim = [ 5 25 ];
    inphasing.maxrev = 30;
    inphasing.toldv  = 0.1;
    INPUT.phasingOptions(4) = inphasing;
    
    % --> Tethys-to-Dione
    inphasing.perct  = 2/100;
    inphasing.toflim = [ 5 25 ];
    inphasing.maxrev = 30;
    inphasing.toldv  = 0.05;
    INPUT.phasingOptions(3) = inphasing;
    
    % --> Dione-to-Enceladus
    inphasing.perct  = 2/100;
    inphasing.toflim = [ 5 25 ];
    inphasing.maxrev = 30;
    inphasing.toldv  = 0.05;
    INPUT.phasingOptions(2) = inphasing;

end
% --> end: check if phasing options are specified in INPUT

% --> post-process the structure with all the info
VILTstruc = plotPhasedPath(path, INPUT, t0);

% --> plot the path
[mu, radius] = planetConstants(INPUT.idcentral);

if plotTraj == 1
    fig = figure( 'Color', [1 1 1] );
    hold on; grid off; axis off;

    greyCol  = [0.800000011920929 0.800000011920929 0.800000011920929];
    greyCol2 = [0.50,0.50,0.50];

    % --> then plot the moons
    plotMoons(unique([VILTstruc.id1]'), INPUT.idcentral, 1);

end

YY   = [];
TT   = [];
indlegend = 1;
for indv = 1:length(VILTstruc)
    
    % --> departing state (outgoing)
    rrd = VILTstruc(indv).rr1;
    vvd = VILTstruc(indv).vvd;

    % --> arrival state (incoming)
    rra = VILTstruc(indv).rr2;
    vva = VILTstruc(indv).vva;

    % --> time of flight
    tof  = VILTstruc(indv).tof;
    tof1 = VILTstruc(indv).tof1;
    tof2 = VILTstruc(indv).tof2;

    if tof2 == 0

        % --> there is no manoeuvre --> pure forward propagation
        [tt, yy] = propagateKepler(rrd, vvd, linspace(0, tof*86400, 1e3), mu);

        if plotTraj == 1
            plot3( yy(:,1), yy(:,2), yy(:,3), 'Color', greyCol2, 'HandleVisibility', 'off');
        end
        
    else
        
        % --> there is a manoeuvre
        [tt1, yy1] = propagateKepler(rrd, vvd, linspace(0, tof1*86400, 2e3), mu);
        [~, yy2c]   = propagateKepler(rra, vva, linspace(0, -tof2*86400, 2e3), mu);
        rrdn       = yy2c(end,1:3);
        vvdn       = yy2c(end,4:6);
        [tt2, yy2] = propagateKepler(rrdn, vvdn, linspace(0, tof2*86400, 2e3), mu);

        tt         = [ tt1; tt1(end)+tt2 ];
        yy         = [ yy1; yy2 ];

        if plotTraj == 1
            plot3( yy1(:,1), yy1(:,2), yy1(:,3), 'Color', greyCol2, 'HandleVisibility', 'off');
            plot3( yy2(:,1), yy2(:,2), yy2(:,3), 'Color', greyCol2, 'HandleVisibility', 'off');
            if indlegend == 1
                plot3( yy1(end,1), yy1(end,2), yy1(end,3), 'x', 'MarkerSize', 8,...
                    'LineWidth', 2, 'Color', 'black', 'DisplayName', 'DSM');
                indlegend = 0;
            else
                plot3( yy1(end,1), yy1(end,2), yy1(end,3), 'x', 'MarkerSize', 8,...
                    'LineWidth', 2, 'Color', 'black', 'HandleVisibility', 'off');
            end
        end

    end

    if indv == 1
        TT = [TT; tt];
    else
        TT = [TT; TT(end)+tt];
    end
    YY = [YY; yy];

end
TT        = TT./86400;
[YY, ind] = unique( YY, 'rows', 'stable' );
TT        = TT(ind);
EPOCHS    = t0 + TT;

% --> start: save the TOUR
TOUR.idcentral           = INPUT.idcentral;
TOUR.muCentral           = mu;
TOUR.radiusCentral       = radius;
[muCentral, muMoon, rpl] = constants(INPUT.idcentral, unique([VILTstruc.id1]'));
TOUR.radiusMoon          = rpl;
TOUR.velMoon             = sqrt( muCentral./rpl );
TOUR.hillRadiusMoon      = rpl.*( muMoon./( 3.*( muCentral + muMoon ) ) ).^(1/3);

TOUR.YY            = YY;
TOUR.TT            = TT;
TOUR.EPOCHS        = EPOCHS;
TOUR.RR            = vecnorm( YY(:,1:3)' )';
TOUR.VV            = vecnorm( YY(:,4:6)' )';
TOUR.SEQ           = [ [VILTstruc.id1]'; VILTstruc(end).id2 ];
TOUR.FB_EPOCHS     = [ [VILTstruc.t1]'; VILTstruc(end).t2 ];
TOUR.FB_TOFS       = cumsum([0; diff(TOUR.FB_EPOCHS)]);

KEP = zeros( size(TOUR.YY,1),6 );
for indy = 1:size(TOUR.YY,1)
    state       = TOUR.YY(indy,:);
    KEP(indy,:) = car2kep(state, muCentral);
end
TOUR.KEP = KEP;

IDS = unique([VILTstruc.id1]');

for inds = 1:length(IDS)
    TOUR.StateMoon(inds).IDmoon = IDS(inds);
    
    [~, fullName] = planet_names_GA(IDS(inds), INPUT.idcentral);
    TOUR.StateMoon(inds).Name   = fullName;

    rr  = zeros( length(TOUR.EPOCHS),3 );
    vv  = zeros( length(TOUR.EPOCHS),3 );
    kep = zeros( length(TOUR.EPOCHS),6 );
    for indep = 1:length(TOUR.EPOCHS)
        [rr(indep,:), vv(indep,:), kep(indep,:)] = ...
            approxEphem_CC(IDS(inds), TOUR.EPOCHS(indep), INPUT.idcentral);
    end
    TOUR.StateMoon(inds).state     = [rr, vv];
    TOUR.StateMoon(inds).keplerian = kep;
end

% --> check the distance of the SC-moon at every day of the propagation
YY = TOUR.YY;
for inds = 1:length(TOUR.StateMoon)
    TOUR.moonSC(inds).IDmoon   = TOUR.StateMoon(inds).IDmoon;
    TOUR.moonSC(inds).Name     = TOUR.StateMoon(inds).Name;

    stateMoon                  = TOUR.StateMoon(inds).state;
    TOUR.moonSC(inds).Distance = vecnorm( [YY(:,1:3) - stateMoon(:,1:3)]' )';
end

% --> end: save the TOUR

if plotTraj == 1
    
    
    % --> start: then plot the flybys
    for indv = 1:length(VILTstruc)
    
        % --> departing state (outgoing)
        rrd = VILTstruc(indv).rr1;
        vvd = VILTstruc(indv).vvd;
    
        % --> arrival state (incoming)
        rra = VILTstruc(indv).rr2;
        vva = VILTstruc(indv).vva;
        
        if indv == 1
            plot3( rrd(:,1), rrd(:,2), rrd(:,3),...
                'o', 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', greyCol, ...
                'DisplayName', 'Fly-by');
    
            plot3( rra(:,1), rra(:,2), rra(:,3),...
                'o', 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', greyCol, ...
                'HandleVisibility', 'Off');
        else
            plot3( rrd(:,1), rrd(:,2), rrd(:,3),...
                'o', 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', greyCol, ...
                'HandleVisibility', 'Off');
    
            plot3( rra(:,1), rra(:,2), rra(:,3),...
                'o', 'MarkerEdgeColor', 'Black', 'MarkerFaceColor', greyCol, ...
                'HandleVisibility', 'Off');
        end
    
    end
    % --> end: then plot the flybys

    % --> specify the legend
    legend('Location', 'Best');
end

end
