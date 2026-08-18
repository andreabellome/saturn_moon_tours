function [gaIndex,CBIndex] = namesToAUTOMATEIndex(gaNames,CBName)
%% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%

    % Number of planets or moons
    nObjects = length(gaNames);

    % Create the output vector
    gaIndex = zeros(1,nObjects);

    % Loop in the objects
    for i = 1:nObjects

        % Solar system
        if CBName == "sun"
    
            CBIndex = 1;
    
            if gaNames(i) == "mercury"
                gaIndex(i) = 1;
            elseif gaNames(i) == "venus"
                gaIndex(i) = 2;
            elseif gaNames(i) == "earth"
                gaIndex(i) = 3;
            elseif gaNames(i) == "mars"
                gaIndex(i) = 4;
            elseif gaNames(i) == "jupiter"
                gaIndex(i) = 5;
            elseif gaNames(i) == "saturn"
                gaIndex(i) = 6;
            end
    
        end
    
        % Saturn system
        if CBName == "saturn"
    
            CBIndex = 6;
    
            if gaNames(i) == "mimas"
                gaIndex(i) = 0;
            elseif gaNames(i) == "enceladus"
                gaIndex(i) = 1;
            elseif gaNames(i) == "tethys"
                gaIndex(i) = 2;
            elseif gaNames(i) == "dione"
                gaIndex(i) = 3;
            elseif gaNames(i) == "rhea"
                gaIndex(i) = 4;
            elseif gaNames(i) == "titan"
                gaIndex(i) = 5;
            end
    
        end

    end

end