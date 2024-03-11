function [RES, RES_struc] = findResonances(IDlist, vinflevels, idcentral)

% DESCRIPTION : 
% find all possible resonant orbits for Solar System planets and contours
% in the Tisserand map (circular co-planar orbits).
%
% INPUT : 
% IDlist : list of IDs for flyby bodies (see constants.m)
% vinflevels : list of infinity velocities (km/s)
% idcentral : ID of the central body (see constants.m)
% 
% OUTPUT : 
% RES : matrix containing the following information :
%       - RES(:,1) : planet
%       - RES(:,2) : alpha angle of the resonant point on Tisserand (rad)
%       - RES(:,3) : inf. vel. of the resonant point on Tisserand (km/s)
%       - RES(:,4) : N (planet revolutions)
%       - RES(:,5) : M (spacecraft revolutions)
% RES_struc : the same as RES but with structure
%
% -------------------------------------------------------------------------

if nargin == 2
    idcentral = 1;
end

% --> find all possible resonant orbits for planets and contours
RES = [];
for indpl = 1:length(IDlist)
    pl_res = IDlist(indpl);

    list = resonanceList(pl_res, idcentral);

    for indres = 1:size(list,1)

        N = list(indres,1);
        M = list(indres,2);
        for indvinf = 1:length(vinflevels)
            [res] = build_Resonances(N, M, vinflevels(indvinf), pl_res, idcentral);
            RES   = [RES; res];
        end

    end
end

% --> RES_struc
for indres = 1:size(RES,1)
    RES_struc(indres,:).pl    = RES(indres,1);
    RES_struc(indres,:).alpha = RES(indres,2);
    RES_struc(indres,:).vinf  = RES(indres,3);
    RES_struc(indres,:).N     = RES(indres,4);
    RES_struc(indres,:).M     = RES(indres,5);
    RES_struc(indres,:).TOFs  = RES(indres,6);
end

end