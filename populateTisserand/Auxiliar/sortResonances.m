function sortedResonanceList = sortResonances(resonanceList)
%% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%
    % Check if the list is empty
    if ~isempty(resonanceList)

        % Compute the ratio of each resonance
        resRatios = resonanceList(:,1)./resonanceList(:,2);
    
        % Sort the matrix first based on the ratio and then on N to break
        % ties (so that 1:1 will be before 4:4)
        sortedResonanceList = sortrows([resRatios, resonanceList], [1, 2]);
    
        % Remove the ratios from the matrix
        sortedResonanceList = sortedResonanceList(:,2:3);

    else

        sortedResonanceList = resonanceList;

    end

end