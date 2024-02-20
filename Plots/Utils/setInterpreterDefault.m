function setInterpreterDefault

% DESCRIPTION
% This function sets the interpreter for MATLAB plot as default
%
% INPUT
% //
%
% OUTPUT
% //
% 
% -------------------------------------------------------------------------

list_factory      = fieldnames(get(groot,'factory'));
index_interpreter = find(contains(list_factory,'Interpreter'));
for i = 1:length(index_interpreter)
    default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
    set(groot, default_name, 'default');
end

% --> set the default font size
set(groot,'DefaultAxesFontSize', 12);

end