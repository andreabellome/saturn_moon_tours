function [man_prop] = heteroclinic_process_manifold( man_prop, strucNorm, lpoint )

% --> START: prune at the Poincare section
for ii = 1:length(man_prop)
    
    sv_complete_uns = man_prop(ii).yy;
    tt_complete_uns = man_prop(ii).tt;
    
    sv_uns_mod = zeros( size( sv_complete_uns,1 ) , size( sv_complete_uns,2 ) );
    t_uns_mod  = zeros( size( tt_complete_uns,1 ) , size( tt_complete_uns,2 ) );
    for jj = 1:size(sv_complete_uns,1)
        
        if strcmpi(lpoint, 'L1')

            if sv_complete_uns(jj,1) > ( 1 - strucNorm.normMu )
                break;
            else
                sv_uns_mod(jj,:) = sv_complete_uns(jj,:);
                t_uns_mod(jj,:)  = tt_complete_uns(jj,:);
            end

        elseif strcmpi(lpoint, 'L2')

            if sv_complete_uns(jj,1) < ( 1 - strucNorm.normMu )
                break;
            else
                sv_uns_mod(jj,:) = sv_complete_uns(jj,:);
                t_uns_mod(jj,:)  = tt_complete_uns(jj,:);
            end

        end
        
    end
    
    indxs               = find( t_uns_mod == 0 );
    sv_uns_mod(indxs,:) = [];
    t_uns_mod(indxs,:)  = [];

    man_prop(ii).sv_int = sv_uns_mod;
    man_prop(ii).t_int  = t_uns_mod;
end
% --> END: prune at the Poincare section


% --> START: prune w.r.t. the min. distance with the planet
[~, ~, ~, radpl, hmin] = constants(strucNorm.idcentral, strucNorm.idplPert);

for ii = 1:length(man_prop)
    
    sv_int = man_prop(ii).sv_int;
    t_int  = man_prop(ii).t_int;
    
    sv_uns_mod = zeros( size( sv_int,1 ) , size( sv_int,2 ) );
    t_uns_mod  = zeros( size( t_int,1 ) , size( t_int,2 ) );

    save_index = zeros( size(sv_uns_mod,1),1 );
    for jj = 1:size(sv_uns_mod,1)
        
        rr   =  sv_uns_mod(jj,1:3);
        dist = sqrt( (rr(1) - (1 - strucNorm.normMu))^2 + (rr(2))^2 + (rr(3))^2 );

        if dist > ( radpl + hmin )/strucNorm.normDist
            save_index(jj,1) = 1;
        end
    end

    if min(save_index) == 0
        % --> prune this
        man_prop(ii).sv_int = [];
        man_prop(ii).t_int  = [];
    end
    
end
% --> END: prune w.r.t. the min. distance with the planet

% --> START: prune w.r.t. moon distance at intersection
for ii = 1:length(man_prop)
    
    sv_int = man_prop(ii).sv_int;
    t_int  = man_prop(ii).t_int;
    
    rr   = sv_int(end,1:3);
    dist = sqrt( (rr(1) - strucNorm.x2)^2 );
    if dist > ( 150e3 )/strucNorm.normDist
        % --> prune this
        man_prop(ii).sv_int = [];
        man_prop(ii).t_int  = [];
    end
    
end
% --> END: prune w.r.t. moon distance at intersection

end
