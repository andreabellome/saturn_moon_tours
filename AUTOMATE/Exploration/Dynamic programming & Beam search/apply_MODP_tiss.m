function LEGSnext = apply_MODP_tiss(LEGSnext, INPUT)

% DESCRIPTION
% Fast multi-objective dynamic programming (MODP) step for the Tisserand
% exploration. Groups tours by DP state with a single sort (no repeated
% find over the whole matrix) and evaluates the cost function once.
%
% INPUT
% - LEGSnext : matrix of tours (each row a tour of 'next_nodes' rows)
% - INPUT    : structure with fields
%              - costFunction : handle returning [dvtot, toftot]
%              - useCrank     : (1) state (ID, alpha, vinf, kappa),
%                               (0) state (ID, alpha, vinf)   [default 1]
%              - tofBin       : ToF bin width [days], 0 = no binning [default 0]
%
% OUTPUT
% - LEGSnext : tours retained after MODP
% -------------------------------------------------------------------------

if isempty(LEGSnext), return; end

useCrank = 1; if isfield(INPUT, 'useCrank'), useCrank = INPUT.useCrank; end
tofBin   = 0; if isfield(INPUT, 'tofBin'),   tofBin   = INPUT.tofBin;   end

% --> DP state keys
keys = [ LEGSnext(:,end-11), LEGSnext(:,end-3), LEGSnext(:,end-2) ];
if useCrank
    typeLast = LEGSnext(:,end-10);
    kappa    = -1.*ones(size(typeLast));               % --> free (after intersections)
    kappa(typeLast == 88 | typeLast == 18) = 0;        % --> arrival outbound
    kappa(typeLast == 81 | typeLast == 11) = pi;       % --> arrival inbound
    keys = [ keys, kappa ];
end
[~, ~, g] = unique(keys, 'rows');

% --> cost functions evaluated once for all tours
[dvtot, toftot] = INPUT.costFunction(LEGSnext);
if tofBin > 0
    tofKey = round(toftot./tofBin).*tofBin;
else
    tofKey = toftot;
end

% --> sort by group, then ToF, then DV: a single pass extracts the PF per group
[~, order] = sortrows([ g, tofKey, dvtot ], [1 2 3]);
gs  = g(order);
tfs = tofKey(order);
dvs = dvtot(order);

keep    = false(numel(order),1);
bestDV  = Inf;
prevG   = -1;
prevTof = NaN;
for k = 1:numel(order)
    if gs(k) ~= prevG                      % --> new group: reset
        prevG   = gs(k);
        bestDV  = Inf;
        prevTof = NaN;
    end
    if tfs(k) == prevTof                   % --> same ToF (or bin): only first (lowest DV) kept
        continue
    end
    if dvs(k) < bestDV                     % --> non-dominated within the group
        keep(k) = true;
        bestDV  = dvs(k);
    end
    prevTof = tfs(k);
end

LEGSnext = LEGSnext(sort(order(keep)), :);


end
