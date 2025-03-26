function tof_non_dim = from_time_dim_to_nondim( tof_dim, strucNorm )

tof_non_dim = tof_dim./strucNorm.normTime;

end