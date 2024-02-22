function [STRUC] = attachLambertInterMoonSat(statein, statega, in)

% DESCRIPTION
% This function solves the Lambert arcs between two states (i.e.,
% spacecraft position and velocity at initial and final moons) for
% specified inputs (e.g., time of flight, number of revolutions and so on).
% DV defects are computed to estimate the cost of a given Lambert arc.
%
% INPUT
% - statein : 1x6 vector with position [km] and velocity [km/s] vectors
%             incoming (i.e., immediately before the flyby) at the first
%             flyby body. 
% - statega : 1x6 vector with position [km] and velocity [km/s] vectors of
%             the flyby body.
% - in : structure with the following fields:
%        - path   : matrix containing the tour. Each row is made by 'next_nodes'
%           rows (see generateVILTSall.m).
%        - idcentral : ID of the central body (see constants.m)
%        - seq    : 1x2 vector with initial and final moon IDs (see
%        constants.m)
%        - t0     : inital epoch [MJD2000]
%        - perct  : percentage of orbital period of next moon for step size
%        in TOF 
%        - toflim : max. integer number of revolutions for Lambert problem
%        - maxrev : max. integer number of revolutions for Lambert problem
%        - toldv  : max. DV defect [km/s]
%        - maxVinfArr : max. arrival infinity velocity at next moon [km/s]
%
% OUTPUT
% - STRUC : structure where each row is a Lambert leg compatible with the
%           constraints in input. The fields are the following: 
%           - t0 : initial epoch [MJD2000]
%           - tf : final epoch [MJD2000]
%           - tof : time of flight [days]
%           - vvrel_A : 1x3 vector with incoming relative velocity [km/s]
%           - vvrel_D : 1x3 vector with outgoing relative velocity [km/s]
%           - dv      : DV defect manoeuvre [km/s]
%           - rrd     : 1x3 vector with initial position [km]
%           - vvd     : 1x3 vector with initial velocity (solution of
%           Lambert problem) [km/s]
%           - vva     : 1x3 vector with final velocity (solution of
%           Lambert problem) [km/s]
%           - rr2      : 1x3 vector with final position [km]
%           - vv2      : 1x3 vector with velocity of the arrival moon [km/s]
%           - vvinfin  : 1x3 vector with infinity velocity at the arrival
%           moon [km/s]
%           - vinfin   : norm of vvinfin [km/s] 
%           - vvinfdep :  1x3 vector with infinity velocity at the starting 
%           moon [km/s] --> same as vvrel_D
%           - vinfdep  : norm of vvinfdep [km/s] 
%           - alphadep : pump angle at the starting moon [rad]
%           - alphain  : pumpa angle at the arrival moon [rad]
%           - types    : type of transfer (11, 18, 81, 88) = (II, IO, OI, OO)
%           - path     : matrix with the tour. Each row is made by 'next_nodes'
%           rows (see generateVILTSall.m).
%           - optMR    : 1x2 vector with number of revolutions and case for
%           Lambert problem (see also lambertMR_MEXIFY.m)
%           - dvCum    : cumulative DV for the tour (i.e., including the
%           defect) [km/s] 
%           - tofCum   : cumulative time of flight for the tour (i.e.,
%           the one for the Lambert problem solution)
% 
% -------------------------------------------------------------------------          

% --> the function starts here
[muCentral, mupl, ~, radpl, hmin] = constants(in.idcentral, in.seq(1));
[~, ~, ~, ~, ~, Tpl2]             = constants(in.idcentral, in.seq(2));
rpmin = radpl + hmin;

% --> map all the possible revs.
RevMax = differentRuns_v2(in.seq, in.maxrev);

dvold  = sum(in.path(:,end-1));
tofold = sum(in.path(:,end));

tnew   = in.t0;
tst    = in.perct*Tpl2/86400;
tofs   = in.toflim(1):tst:in.toflim(2);

rrin = statein(1:3);
vvin = statein(4:6);
rr   = statega(1:3);
vv   = statega(4:6);

t0      = zeros( length(RevMax)*length(tofs), 1 );
tf      = zeros( length(RevMax)*length(tofs), 1 );
vvrel_A = zeros( length(RevMax)*length(tofs), 3 );
vvrel_D = zeros( length(RevMax)*length(tofs), 3 );
dv      = zeros( length(RevMax)*length(tofs), 1 );
Nrev    = zeros( length(RevMax)*length(tofs), 2 );
rr2     = zeros( length(RevMax)*length(tofs), 3 );
vv2     = zeros( length(RevMax)*length(tofs), 3 );
vvd     = zeros( length(RevMax)*length(tofs), 3 );
vva     = zeros( length(RevMax)*length(tofs), 3 );

ind = 1;

n     = length(RevMax)*length(tofs);
STRUC = struct( 't0', cell(1,n), 'tf', cell(1,n), 'tof', cell(1,n), ...
    'vvrel_A', cell(1,n), 'vvrel_D', cell(1,n), 'dv', cell(1,n), ...
    'rrd', cell(1,n), 'vvd', cell(1,n), 'vva', cell(1,n), 'rr2', cell(1,n), 'vv2', cell(1,n), ...
    'vvinfdep', cell(1,n), 'vinfdep', cell(1,n), 'alphadep', cell(1,n), ...
    'vvinfin', cell(1,n), 'vinfin', cell(1,n), 'alphain', cell(1,n), ...
    'legs', cell(1,n), 'types', cell(1,n), 'path', cell(1,n), 'Nrev', cell(1,n), ...
    'dvCum', cell(1,n), 'tofCum', cell(1,n));

for indr = 1:length(RevMax)

    optMR = rev2RevOpt(RevMax(indr), [], 1);

    for indt = 1:length(tofs)

        % --> state of the next moon
        [rr2(ind,:), vv2(ind,:)] = approxEphem_CC(in.seq(2), tnew+tofs(indt), in.idcentral);
        
        % --> solve the Lambert problem
        try
            [vvd(ind,:), vva(ind,:)] = lambertMR_MEXIFY(rrin, rr2(ind,:), tofs(indt)*86400, muCentral, optMR(1), optMR(2));
        catch
            [vvd(ind,:), vva(ind,:)] = lambertMR_vM_MEXIFY(rrin, rr2(ind,:), tofs(indt)*86400, muCentral, optMR(1), optMR(2));
        end

        % --> compute DV defect
        t0(ind,1)      = tnew;
        tf(ind,1)      = tnew+tofs(indt);
        vvrel_A(ind,:) = vvin - vv;
        vvrel_D(ind,:) = vvd(ind,:) - vv;
        dv(ind,:)      = findDV(vvrel_A(ind,:), vvrel_D(ind,:), mupl, rpmin);
        Nrev(ind,:)    = optMR(1:2);

        % --> check inbound-outbound transfers
        kepsta = car2kep([rrin, vva(ind,:)], muCentral);
        kepend = car2kep([rr2(ind,:), vva(ind,:)], muCentral);
        if kepend(end) >= 0 && kepend(end) < pi
            if kepsta(end) >= 0 && kepsta(end) < pi
                type = 88;
            else
                type = 18;
            end
        else
            if kepsta(end) >= 0 && kepsta(end) < pi
                type = 81;
            else
                type = 11;
            end
        end
        
        % --> save the result
        STRUC(ind).t0      = tnew;
        STRUC(ind).tf      = tnew+tofs(indt);
        STRUC(ind).tof     = tofs(indt);
        STRUC(ind).vvrel_A = vvin - vv;
        STRUC(ind).vvrel_D = vvd(ind,:) - vv;
        STRUC(ind).dv      = dv(ind,:);
        STRUC(ind).rrd     = rr;
        STRUC(ind).vvd     = vvd(ind,:);
        STRUC(ind).vva     = vva(ind,:);
        STRUC(ind).rr2     = rr2(ind,:);
        STRUC(ind).vv2     = vv2(ind,:);
        STRUC(ind).vvinfin = STRUC(ind).vva - STRUC(ind).vv2;
        STRUC(ind).vinfin  = vecnorm(STRUC(ind).vvinfin')';
        STRUC(ind).vvinfdep = STRUC(ind).vvrel_D;
        STRUC(ind).vinfdep  = vecnorm(STRUC(ind).vvrel_D')';
        STRUC(ind).alphadep = wrapToPi(acos( dot(STRUC(ind).vvinfdep, vv)/(norm(STRUC(ind).vvinfdep)*norm(vv)) ));
        
        STRUC(ind).alphain = wrapToPi(acos( dot(STRUC(ind).vvinfin, STRUC(ind).vv2)/(norm(STRUC(ind).vvinfin)*norm(STRUC(ind).vv2)) ));
        STRUC(ind).types   = type;
        STRUC(ind).path    = in.path;
        STRUC(ind).Nrev    = optMR(1:2);
        STRUC(ind).dvCum   = dvold + dv(ind,:);
        STRUC(ind).tofCum  = tofold + tofs(indt);

        ind                = ind + 1;

    end

end
STRUC(isnan([ STRUC.dv ]')) = [];

% --> sort w.r.t. best DV and prune
if ~isempty(STRUC(1).dv)

    dvs  = [ STRUC.dv ]';
    tofs = [ STRUC.tf ]' - [ STRUC.t0 ]';
    MAT2 = sortrows( [dvs tofs [1:1:size(dvs,1)]'], [1 2] );
    
    STRUC = STRUC(MAT2(:,end));
    
    % --> prune w.r.t. max. DV
    dvs  = [ STRUC.dv ]';
    STRUC(dvs > in.toldv) = [];

    if ~isempty(STRUC)
    
        % --> prune w.r.t. max. vinfArr
        vinfa = [ STRUC.vinfin ]';
        STRUC(vinfa > in.maxVinfArr) = [];

    end

    if ~isempty(STRUC)
        
        types        = cell2mat({STRUC.types}');
        indxs        = find(types == 11);
        STRUC(indxs) = [];

    end

end

end
