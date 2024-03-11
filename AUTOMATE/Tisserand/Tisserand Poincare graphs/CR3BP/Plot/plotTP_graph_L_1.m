function [STRUC_LL_1] = plotTP_graph_L_1(LL, mu, ramaxAdim, npoints)

% DESCRIPTION
% This function is used to plot Tisserand-Poincare graph for the Lagrange
% points, in the region ra>=1.
%
% INPUT
% - LL : 5x3 matrix with coordinates of Lagrange points in normalized units
%        (L1, L2, L3, L4, L5) 
% - mu : normalized gravitational constant of the CR3BP 
% - ramaxAdim  : max. apoapsis in ADIMENSIONAL variables (if not given in
%                input, a default value of 5 is assumed)
% - npoints    : umber of points for the contours on the Tisserand-Poincare
%                map. Too high number can lead to high computational effort
%                (if not given in input, a default value of 1e3 is assumed)
% 
% OUTPUT
% - STRUC_LL_1 : not needed, will be removed from future releases.
% 
% -------------------------------------------------------------------------

if nargin == 2
    ramaxAdim = 5;
    npoints = 1e3;
elseif nargin == 3
    npoints = 1e3;
end

ra = linspace(1, ramaxAdim, npoints);
rp = linspace(0, ramaxAdim, npoints);

% --> add also the Libration points
JJ = zeros( size(LL,1), 1 );
for indl = 1:size(LL,1)
    JJ(indl,1) = jacobiConst(LL(indl,:), [0 0 0], mu);
end

colors = cool(size(JJ,1));

for indl = 1:size(JJ,1)
    
    JacCons = JJ(indl);
        
    indx  = 1;
    struc = [];
    for indra = 1:length(ra)
    
        df  = findRpfromJacobiConst( rp, ra(indra), JacCons );
        
        pp2 = find(diff(sign(df)))+1;
        pp1 = find(diff(sign(df)));
    
        if ~isempty(pp1)
            for indp = 1:length(pp1)
                
                xsol = fzero(@(rp) findRpfromJacobiConst( rp, ra(indra), JacCons ), [rp(pp1(indp)), rp(pp2(indp))]);

                % --> check that the point is not over the diagonal y = mx + b
                m = 1; % --> slope 
                b = 0; % --> y-intercept
                if (xsol > m * ra(indra) + b)
                    struc(indx).ra    = NaN;
                    struc(indx).rp    = NaN;
                    struc(indx).Jcons = NaN;
                else
                    struc(indx).ra    = ra(indra);
                    struc(indx).rp    = xsol;
                    struc(indx).Jcons = JacCons;
                end

                indx = indx + 1;
            end
        else
            struc(indx).ra    = NaN;
            struc(indx).rp    = NaN;
            struc(indx).Jcons = NaN;
            indx = indx + 1;
        end
    
    end
    
    mat = [ [struc.ra]', [struc.rp]' ];
    indxs = find(isnan(mat(:,1)));
    mat(indxs,:) = [];

    if indl < 4
        nameL = [ 'L' num2str(indl) ];
        plot( mat(:,1), mat(:,2), ...
            'Color', colors(indl,:),...
            'DisplayName', nameL);
    elseif indl == 4

    elseif indl == 5
        nameL = [ 'L4,L5' ];
        plot( mat(:,1), mat(:,2), ...
            'Color', colors(indl,:),...
            'DisplayName', nameL);
    end

    STRUC_LL_1(indl).rp   = mat(:,1);
    STRUC_LL_1(indl).ra   = mat(:,2);
    STRUC_LL_1(indl).Jcon = JacCons;
    STRUC_LL_1(indl).L    = LL(indl,:);

end

end