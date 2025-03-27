function [unst_man_prop] = heteroclinic_process_unstable_manifold(unst_man_prop, strucNorm)

% --> START: prune at the Poincare section
for ii = 1:length(unst_man_prop)
    
    sv_complete_uns = unst_man_prop(ii).yy;
    tt_complete_uns = unst_man_prop(ii).tt;
    
    sv_uns_mod = zeros( size( sv_complete_uns,1 ) , size( sv_complete_uns,2 ) );
    t_uns_mod  = zeros( size( tt_complete_uns,1 ) , size( tt_complete_uns,2 ) );
    for jj = 1:size(sv_complete_uns,1)
        
        if sv_complete_uns(jj,1) > ( 1 - strucNorm.normMu )
            break;
        else
            sv_uns_mod(jj,:) = sv_complete_uns(jj,:);
            t_uns_mod(jj,:)  = tt_complete_uns(jj,:);
        end
        
    end
    
    indxs               = find( t_uns_mod == 0 );
    sv_uns_mod(indxs,:) = [];
    t_uns_mod(indxs,:)  = [];

    unst_man_prop(ii).sv_int = sv_uns_mod;
    unst_man_prop(ii).t_int  = t_uns_mod;
end
% --> END: prune at the Poincare section

% --> START: prune w.r.t. the min. distance with the planet
[~, ~, ~, radpl, hmin] = constants(strucNorm.idcentral, strucNorm.idplPert);

for ii = 1:length(unst_man_prop)
    
    sv_uns_L1_int = unst_man_prop(ii).sv_int;
    t_uns_L1_int  = unst_man_prop(ii).t_int;
    
    sv_uns_mod = zeros( size( sv_uns_L1_int,1 ) , size( sv_uns_L1_int,2 ) );
    t_uns_mod  = zeros( size( t_uns_L1_int,1 ) , size( t_uns_L1_int,2 ) );

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
        unst_man_prop(ii).sv_int = [];
        unst_man_prop(ii).t_int  = [];
    end
    
end
% --> END: prune w.r.t. the min. distance with the planet

end
