function VILTstruc = plotPhasedPath(path, INPUT, t0, inphasing)

% DESCRIPTION 
% This function post-processes a moon tour for which the phasing problem
% has been solved and writes it in a nice structure.
% 
% INPUT
% - path : matrix containing the tour. Each row is made by 'next_nodes'
%           rows (see generateVILTSall.m). This has phasing DV and TOF
%           information in it.
% - INPUT : structure with the following mandatory fields:
%           - idcentral    : ID of the central body (see constants.m)
%           - phasingOptions : structure with phasing options (see
%           writeInPhasing.m for example)
% - t0    : initial date of the tour [MJD2000]
% - inphasing : structure with input for the phasing. The following fields
%               are required:
%        - path   : matrix containing the tour. Each row is made by
%        'next_nodes' rows (see generateVILTSall.m).
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
% - VILTstruc : structure with the following fields:
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
% -------------------------------------------------------------------------

specifyInputPhasingINPUT = 0;
if nargin == 3
    inphasing = [];
    specifyInputPhasingINPUT = 1;
end

for indp = 2:size(path,1)

    pathrow = path(indp,:);

    if isnan(pathrow(6)) % --> intersection on Tisserand graph --> then there is the solution of the phasing problem

        if specifyInputPhasingINPUT == 1
            idpl      = pathrow(3);
            inphasing = INPUT.phasingOptions(idpl);
        end

        in            = writeInPhasing(path, t0, inphasing.perct, inphasing.toflim,...
                         inphasing.maxrev, inphasing.toldv, INPUT);
        in.seq        = [pathrow(3) pathrow(1)];
        in.toldv      = Inf;
        in.maxVinfArr = Inf;
        in.toflim     = [ pathrow(end) pathrow(end) ];

        STRUC          = attachLambertInterMoonSat(statein, statega, in);
        diff           = vecnorm( abs( [ [STRUC.dv]' [STRUC.tof]' ] - pathrow(end-1:end))' )';
        [mindiff, row] = min(diff);

        VILTstruc(indp-1).id1       = in.seq(1);
        VILTstruc(indp-1).t1        = STRUC(row).t0;
        VILTstruc(indp-1).id2       = in.seq(2);
        VILTstruc(indp-1).t2        = STRUC(row).tf;
        VILTstruc(indp-1).rr1       = STRUC(row).rrd;
        VILTstruc(indp-1).vvd       = STRUC(row).vvd;
        VILTstruc(indp-1).rr2       = STRUC(row).rr2;
        VILTstruc(indp-1).vva       = STRUC(row).vva;
        VILTstruc(indp-1).vv1       = statega(4:6);
        VILTstruc(indp-1).vv2       = STRUC(row).vv2;
        VILTstruc(indp-1).vvinf_dep = STRUC(row).vvrel_D;
        VILTstruc(indp-1).vvinf_arr = STRUC(row).vvrel_A;
        VILTstruc(indp-1).alpha1    = STRUC(row).alphadep;
        VILTstruc(indp-1).vinf1     = STRUC(row).vinfdep;
        VILTstruc(indp-1).alpha2    = STRUC(row).alphain;
        VILTstruc(indp-1).vinf2     = STRUC(row).vinfin;
        VILTstruc(indp-1).dv        = STRUC(row).dv;
        VILTstruc(indp-1).tof       = STRUC(row).tof;
        VILTstruc(indp-1).tof1      = STRUC(row).tof;
        VILTstruc(indp-1).tof2      = 0;
        VILTstruc(indp-1).S         = pathrow( 2:6 );

    else % --> VILT --> no phasing problem needed, but a simple post-processing
        VILTstruc(indp-1) = pathRowVILTtoState_def(pathrow, t0, INPUT);
    end

    statein = [ VILTstruc(indp-1).rr2 VILTstruc(indp-1).vva ];
    statega = [ VILTstruc(indp-1).rr2 VILTstruc(indp-1).vv2 ];
    t0      = VILTstruc(indp-1).t2;

end

end
