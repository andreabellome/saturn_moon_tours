function [ tof_dim, tof_dim_days ] = from_time_nondim_to_dim( tof_non_dim, strucNorm )

tof_dim      = tof_non_dim.*strucNorm.normTime;
tof_dim_days = tof_dim./86400;

end