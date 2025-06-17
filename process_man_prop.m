function [ man_prop ] = process_man_prop( man_prop )

[man_prop.yy] = man_prop.sv_int;  % Copy data
[man_prop.tt] = man_prop.t_int;  % Copy data

man_prop = rmfield(man_prop, 'sv_int'); % Remove old field
man_prop = rmfield(man_prop, 't_int'); % Remove old field

end