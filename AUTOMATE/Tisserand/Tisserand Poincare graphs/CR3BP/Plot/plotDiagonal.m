function [] = plotDiagonal()

% DESCRIPTION
% This function plots diagonal line in an existing plot.

ax   = gca;
xlim = ax.XLim;
yLim = ax.YLim;
xd   = linspace(min([xlim ylim]), max([xlim ylim]));
yd   = xd;
hold on;
plot(xd, yd, '--k', 'HandleVisibility', 'off');

end