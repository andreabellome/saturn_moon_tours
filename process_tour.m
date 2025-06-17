function [TOUR_struc, dvc] = process_tour(tour, t0, INPUT)

for indp = 2:size(tour,1)
    
    pathrow = tour(indp,:);

    if isnan(tour(indp,6)) % --> there is an intersection
        
        if tour(indp,7) == 0

        else

        end

    else

        TOUR_struc(indp-1) = pathRowVILTtoState_def_v2(pathrow, t0, INPUT);

        % --> check that everything is correct
        rr1 = TOUR_struc(indp-1).rr1;
        vv1 = TOUR_struc(indp-1).vvd;

        rr2 = TOUR_struc(indp-1).rr2;
        vv2 = TOUR_struc(indp-1).vva;

        tof1 = TOUR_struc(indp-1).tof1 * 86400;
        tof2 = TOUR_struc(indp-1).tof2 * 86400;
        
        idmoon = TOUR_struc(indp-1).id1;
        mu_planet      = constants(INPUT.idcentral, idmoon);
        [~, yy1]       = propagateKepler_tof(rr1, vv1, tof1, mu_planet);    
        [~, yy2]       = propagateKepler_tof(rr2, vv2, -tof2, mu_planet);   
        
        dvcheck = pathrow(end-1);
        dvc(indp-1,1) = abs(norm(yy2(end,4:6) - yy1(end,4:6)) - dvcheck);

        t0 = TOUR_struc(indp-1).t2;

    end

end

end