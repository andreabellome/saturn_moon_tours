function plotFontSizeAxesDim(labelsDim, axesDim, fig, ax)

% DESCRIPTION
% This function sets the font sizes for all labels and axes in a given figure.
% It updates all text objects and axes within the figure to use the specified
% font sizes for consistent and clear visualization.
%
% INPUT
% - labelsDim : font size for all labels and figure text
% - axesDim   : font size for axes tick labels
% - fig       : (optional) handle to the target figure (default is current figure)
% - ax        : (optional) handle to the target axes (default is current axes)
%
% OUTPUT
% - None (the function modifies the properties of the given figure and axes)
%
% -------------------------------------------------------------------------


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