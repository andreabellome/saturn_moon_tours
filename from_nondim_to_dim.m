function sv0_dim = from_nondim_to_dim( sv0_non_dim, strucNorm )

normDist = strucNorm.normDist;
normTime = strucNorm.normTime;

sv0_dim      = zeros(1,6);
sv0_dim(1:3) = sv0_non_dim(1:3).*normDist;
sv0_dim(4:6) = sv0_non_dim(4:6).*normDist./normTime;

end