function plotFontSizeAxesDim(labelsDim, axesDim, fig, ax)

if nargin == 2
    fig = gcf;
    ax  = gca;
elseif nargin == 3
    ax = gca;
end

set(findall(fig,'-property','FontSize'),'FontSize', labelsDim)
h = findall(fig, 'type', 'text');
set(h, 'fontsize', axesDim);
ax.FontSize = axesDim; 

end