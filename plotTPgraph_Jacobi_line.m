function fig = plotTPgraph_Jacobi_line( JacCons, ra, rp, strucNorm, param_plot, holdon )

if nargin == 5
    holdon = 0;
end

if holdon == 0
    fig = figure( 'Color', [1 1 1] );
else
    fig = gcf;
end

idcentral = strucNorm.idcentral;
mu        = strucNorm.normMu;
normDist  = strucNorm.normDist;

if ~isfield(param_plot, 'adim')
    param_plot.adim = 0;
end

if ~isfield(param_plot, 'color')
    param_plot.color = 'black';
end

if ~isfield(param_plot, 'linewidth')
    param_plot.linewidth = 1;
end


if param_plot.adim == 0
    param_plot.normDist = normDist;
    if isfield(param_plot, 'AU')
        param_plot.normDist = param_plot.normDist/param_plot.AU;
    else
        if idcentral == 1
            AU = 149597870.7;
        else
            [~, AU] = planetConstants(idcentral);
        end
        param_plot.AU = AU;
        param_plot.normDist = param_plot.normDist/param_plot.AU;
    end
end

% --> plot a line of the TP graph using Jacobi constant
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

if param_plot.adim == 1
    hold on; grid on;
    plot( mat(:,1), mat(:,2), 'black', 'HandleVisibility', 'off',...
        'Color', param_plot.color, ...
        'LineWidth', param_plot.linewidth);
else
    hold on; grid on;
    plot( mat(:,1).*param_plot.normDist, mat(:,2).*param_plot.normDist, ...
        'HandleVisibility', 'off', 'Color', param_plot.color, 'LineWidth', param_plot.linewidth);
end

end
