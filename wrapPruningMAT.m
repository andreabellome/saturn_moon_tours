function [MAT] = wrapPruningMAT(MAT, dvTol, strucNorm, down)

if nargin == 3
    down = 1;
end

% --> prune
[MAT, MATold2]   = pruneIsRealMAT(MAT);
[MAT, ~, MATold] = pruneMAT(MAT, dvTol, strucNorm);

if down == 1
    [MAT, MATold3]   = pruneGoDownMAT(MAT);
end


end