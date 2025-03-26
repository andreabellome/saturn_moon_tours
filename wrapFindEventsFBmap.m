function [ ttPostFB, yyPostFB, locsPostFB, aa, TT, llambda, ff, ffstar, ...
    RR2, RR2PostFB, Rhill, ffPostFB, ffstarPostFB ] = ...
    wrapFindEventsFBmap( tt, yy2, mu )

% locsPostFB correspond to the points AFTER the flyby at which the SC
% crosses the SigmaB

% --> find the evolution of the parameters
[ aa, TT, llambda, ff, ffstar, RR2, Rhill ] = wrapParamEvolution( tt, yy2, mu );

% --> only take the first flyby
indxs      = find( RR2 <= Rhill );

if isempty(indxs) % --> no flyby occurred
    
    ttPostFB = NaN; yyPostFB = NaN; locsPostFB = NaN; aa = NaN; TT = NaN; 
    llambda = NaN; ff = NaN; ffstar = NaN;
    RR2 = NaN; RR2PostFB = NaN; Rhill = NaN; ffPostFB = NaN; ffstarPostFB = NaN;

else

    indtocheck = find(diff(indxs) > 1);
    indxsToThrow = [];
    if ~isempty(indtocheck)
        if indtocheck(1) < length(indxs)
            indtocheck   = indtocheck(1);
            indxsToThrow = indxs(indtocheck+1:end);
            indxs        = indxs(1:indtocheck);
        end
    end
    startFBind = indxs(1);
    endFBind   = indxs(end);
    
    % --> states after the FB
    ttPostFB = tt(endFBind:end,:);
    yyPostFB = yy2(endFBind:end,:);
    
    aaPostFB      = aa(endFBind:end,:);
    TTPostFB      = TT(endFBind:end,:);
    llambdaPostFB = llambda(endFBind:end,:);
    ffPostFB      = ff(endFBind:end,:);
    ffstarPostFB  = ffstar(endFBind:end,:);
    RR2PostFB     = RR2(endFBind:end,:);
    
    if aaPostFB(1) > 1 % --> this is pi
    
        locs = islocalmin(abs( ff - ffstar ), 'FlatSelection', 'all');
        locs = find(locs > 0);
        pks  = ff(locs);
    
    elseif aaPostFB(1) < 1 % --> this is 2pi
        [pks, locs] = findpeaks(ff); % --> 2pi
    end
    
    locsPostFB = locs;
    if ~isempty(indxsToThrow)
        locsPostFB(locsPostFB >= indxsToThrow(1),:) = []; % --> these are POST fly-by
    end

    RR2peaks   = RR2(locsPostFB,:);

end

end
