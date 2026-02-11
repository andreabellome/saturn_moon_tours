function intersections = findAllIntersectionsWithAUTOMATE(objectNames,vInfLevels,centralBody)

    % Get the index of the central body
    [~,CBIndex] = namesToAUTOMATEIndex(objectNames,centralBody);
    
    % Intersections output
    LEGS_inter = {};
    
    % Loop on the departure planet
    for indDepObj = 1:length(objectNames)
    
    ga_dep = objectNames(indDepObj);
    
    % Loop on the arrival planet
    for indArrObj = 1:length(objectNames)
    
        ga_arr = objectNames(indArrObj);
    
        if indArrObj ~= indDepObj
            % --> generate inputs
            INPUT.pl1          = namesToAUTOMATEIndex(ga_dep,centralBody);
            INPUT.vinf_dep_lev = vInfLevels.(ga_dep)/1000;
            INPUT.planetlist   = namesToAUTOMATEIndex(ga_arr,centralBody);
            INPUT.vinflevels   = vInfLevels.(ga_arr)/1000;
            INPUT.idcentral    = CBIndex;
    
            % --> generate intersections
            legs_inter = generateFirstLegs(INPUT);
    
            % Change index for names
            %nIntersections = size(legs_inter,1);
            if ~isempty(legs_inter)
                names1 = cellstr(AUTOMATEIndex2Names(legs_inter(:,1),CBIndex));
                names2 = cellstr(AUTOMATEIndex2Names(legs_inter(:,4),CBIndex));
                legs_inter = [names1, num2cell(legs_inter(:,2:3)), names2, num2cell(legs_inter(:,5:6))];
            else
                legs_inter = {};
            end
        else
            legs_inter = {};
        end
    
        % Store intersections
        LEGS_inter  = [LEGS_inter; legs_inter];
    
    end
    
    end
    
    % Transform vInf to m/s
    LEGS_inter(:,3) = num2cell(cell2mat(LEGS_inter(:,3)) * 1000);
    LEGS_inter(:,6) = num2cell(cell2mat(LEGS_inter(:,6)) * 1000);
    
    % Reformat
    intersections = [LEGS_inter(:,1) LEGS_inter(:,3) LEGS_inter(:,2),...
                 LEGS_inter(:,4) LEGS_inter(:,6) LEGS_inter(:,5)];

end