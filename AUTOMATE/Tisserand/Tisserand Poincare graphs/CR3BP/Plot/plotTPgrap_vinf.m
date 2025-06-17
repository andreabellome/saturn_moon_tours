function [STRUC, fig] = plotTPgrap_vinf(vinf, mu, ramaxAdim, npoints, param)

% DESCRIPTION 
% This function is used to plot Tisserand-Poincarè graphs in adimensional
% variables for given infinity velocity values.
% 
% INPUT
% - vinf       : list of infinity velocity magnitudes [adimensional]
% - mu         : normalized gravitational constant of the CR3BP 
% - ramaxAdim  : max. apoapsis in ADIMENSIONAL variables (if not given in
%                input, a default value of 5 is assumed)
% - npoints    : umber of points for the contours on the Tisserand-Poincare
%                map. Too high number can lead to high computational effort
%                (if not given in input, a default value of 1e3 is assumed) 
% - param       : Structure with the following fields:
%                param.adim: if 0, the DIMENSIONAL-unit plot is provided,
%                otherwise, ADIMENSIONAL-unit plot is provided. Default is 1. 
%                param.normDist: dimensionalization unit (distance from
%                central body).
%
% OUTPUT
% - STRUC : not needed, will be removed from future releases.
% - fig   : figure class showing the Tisserand-Poincare map
% 
% -------------------------------------------------------------------------

if nargin == 1
    ramaxAdim  = 5;
    npoints    = 1e3;
    param.adim = 1;
elseif nargin == 2
    npoints    = 1e3;
    param.adim = 1;
elseif nargin == 3
    param.adim = 1;
end

ra = linspace(0.01, ramaxAdim, npoints);
rp = linspace(0, ramaxAdim, npoints);

JJ = jacobi_from_vinf( vinf, mu );

for indl = 1:length(JJ)
    
    JacCons = JJ(indl);
        
    indx  = 1;
    struc = [];
    for indra = 1:length(ra)
    
        df  = findRpfromJacobiConst( rp, ra(indra), JacCons, mu );
        
        pp2 = find(diff(sign(df)))+1;
        pp1 = find(diff(sign(df)));
    
        if ~isempty(pp1)
            for indp = 1:length(pp1)
                
                xsol = fzero(@(rp) findRpfromJacobiConst( rp, ra(indra), JacCons, mu ), [rp(pp1(indp)), rp(pp2(indp))]);

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
    mat(isnan(mat(:,1)),:) = [];
    
    if param.adim == 1
        hold on; grid on;
        plot( mat(:,1), mat(:,2), 'black', 'HandleVisibility', 'off');
    else
        hold on; grid on;
        plot( mat(:,1).*param.normDist, mat(:,2).*param.normDist, ...
            'black', 'HandleVisibility', 'off');
    end

    STRUC(indl).rp   = mat(:,1);
    STRUC(indl).ra   = mat(:,2);
    STRUC(indl).Jcon = JacCons;
    STRUC(indl).vinf = vinf(indl);

end

end
