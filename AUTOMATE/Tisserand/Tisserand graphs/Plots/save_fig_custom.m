function save_fig_custom( fig, dpi, type, name_including_folder, width_cm, height_cm )
% DESCRIPTION
% This function saves a given MATLAB figure in either PDF or SVG format with
% specified resolution and filename. If width_cm (and optionally height_cm)
% are provided, the figure is first resized to that PHYSICAL size, so that
% when it is included in LaTeX at its natural size (no width scaling) the
% font sizes set in MATLAB match the ones in the paper.
%
% INPUT
% - fig                   : handle to the figure to be saved. If empty or not
%                           provided, the current figure (gcf) is used.
% - dpi                   : resolution in dots per inch (DPI). Default 600.
% - type                  : 'pdf' or 'svg'. Default 'pdf'.
% - name_including_folder : full file name including folder and extension.
%                           The extension must match the specified type.
%                           Default 'my_plot.<type>'.
% - width_cm              : (optional) final width of the figure [cm].
%                           Typically equal to \textwidth or \columnwidth
%                           of the paper (print \the\textwidth in LaTeX).
% - height_cm             : (optional) final height [cm]. Default is
%                           0.75*width_cm.
%
% OUTPUT
% - none : the figure is saved to file.
%
% -------------------------------------------------------------------------

% --> defaults
if nargin < 1 || isempty(fig),  fig  = gcf;   end
if nargin < 2 || isempty(dpi),  dpi  = 600;   end
if nargin < 3 || isempty(type), type = 'pdf'; end
if nargin < 4 || isempty(name_including_folder)
    name_including_folder = ['my_plot.' lower(type)];
end
if nargin < 5, width_cm  = []; end
if nargin < 6 || isempty(height_cm)
    if ~isempty(width_cm)
        height_cm = 0.75*width_cm;
    end
end

type = lower(type);
if ~ismember(type, {'pdf', 'svg'})
    error('Type must be either ''pdf'' or ''svg''.');
end

% --> check extension
[~, ~, ext] = fileparts(name_including_folder);
if ~strcmpi(ext, ['.' type])
    error('Extension in selected name does not match the selected type');
end

% --> make sure output folder exists
outFolder = fileparts(name_including_folder);
if ~isempty(outFolder) && ~exist(outFolder, 'dir')
    mkdir(outFolder);
end

drawnow;

% --> resize the figure to its final physical size (if requested)
oldUnits = fig.Units;
fig.Units = 'centimeters';
if ~isempty(width_cm)
    if strcmp(fig.WindowStyle, 'docked')
        fig.WindowStyle = 'normal';
    end
    pos          = fig.Position;
    fig.Position = [pos(1) pos(2) width_cm height_cm];
    drawnow;
end
pos = fig.Position;

% --> paper size = figure size, so the exported page has no margins/scaling
fig.PaperUnits        = 'centimeters';
fig.PaperPositionMode = 'auto';
fig.PaperSize         = pos(3:4);

% --> export
switch type
    case 'pdf'
        print(fig, name_including_folder, '-dpdf', ['-r' num2str(dpi)]);
    case 'svg'
        print(fig, name_including_folder, '-dsvg', ['-r' num2str(dpi)]);
end

fig.Units = oldUnits;

fprintf('Saved %s (%.1f x %.1f cm)\n', name_including_folder, pos(3), pos(4));

end