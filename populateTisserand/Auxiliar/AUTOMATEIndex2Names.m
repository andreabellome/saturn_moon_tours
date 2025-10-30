function [gaNames,CBName] = AUTOMATEIndex2Names(gaIndex,CBIndex)
%% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%

    % Number of planets or moons
    nObjects = length(gaIndex);

    % Create the output vector
    gaNames = [];

    % Loop in the objects
    for i = 1:nObjects

        % Solar system
        if CBIndex == 1
    
            CBName = "sun";
    
            if gaIndex(i) == 1
                gaNames = [gaNames "mercury"];
            elseif gaIndex(i) == 2
                gaNames = [gaNames "venus"];
            elseif gaIndex(i) == 3
                gaNames = [gaNames "earth"];
            elseif gaIndex(i) == 4
                gaNames = [gaNames "mars"];
            elseif gaIndex(i) == 5
                gaNames = [gaNames "jupiter"];
            elseif gaIndex(i) == 6
                gaNames = [gaNames "saturn"];
            end
    
        end
    
        % Saturn system
        if CBIndex == 6
    
            CBName = "saturn";
    
            if gaIndex(i) == 0
                gaNames = [gaNames "mimas"];
            elseif gaIndex(i) == 1
                gaNames = [gaNames "enceladus"];
            elseif gaIndex(i) == 2
                gaNames = [gaNames "tethys"];
            elseif gaIndex(i) == 3
                gaNames = [gaNames "dione"];
            elseif gaIndex(i) == 4
                gaNames = [gaNames "rhea"];
            elseif gaIndex(i) == 5
                gaNames = [gaNames "titan"];
            end
    
        end

    end

end