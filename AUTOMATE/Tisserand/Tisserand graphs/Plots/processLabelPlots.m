function processLabelPlots( idcentral, IDS )

% DESCRIPTION:
% This function allows to automatically scale the plot for a moon tour
% problem. 
% 
% INPUT:
% - idcentral : ID of the central body (see constants.m)
% - IDS       : list of IDS of fly-by bodies (see constants.m)
%
% OUTPUT:
% //
% 
% -------------------------------------------------------------------------

if idcentral == 1
    
    idMIN = min(IDS);
    idMAX = max(IDS);
    XLIM(:,1) = [0.38 0.7 0.9 2 4 9.7 19]';
    XLIM(:,2) = [0.74  2   2.8 6 6 15  30]';  
    xlim([XLIM(idMIN,1) XLIM(idMAX,2)]);
    if idMAX == 5
        ylim([0 3]);
    elseif idMAX == 6
        ylim([0 4]);
    elseif idMAX == 7
        ylim([0 6.5]);
    elseif idMAX == 1
        ylim([0.3 0.4]);
    end
    
    xlabel('r_a [AU]'); ylabel('r_p [AU]');

elseif idcentral == 5

    if max(IDS) == 4
        ylim([0 30]);
        xlim([5 200]);
    elseif max(IDS) == 3
        ylim([0 16]);
        xlim([5 200]);
    end

    xlabel('r_a [R_J]'); ylabel('r_p [R_J]');

elseif idcentral == 6

    if (max(IDS) == 5 && min(IDS) == 4) || ( max(IDS) == 5 && length(IDS) == 1 )

        ylim([2 22]);
        xlim([20 80]);

%         ylim([8 22]);
%         xlim([20 350]);
    
    elseif max(IDS) == 5 && min(IDS) == 0

        ylim([1.5 9.5]);
        xlim([3.8 35.5]);

    elseif max(IDS) == 5 && min(IDS) == 1

        ylim([1.5 9.5]);
        xlim([3.8 35.5]);


    elseif max(IDS) == 4 && min(IDS) == 3

%         ylim([2 9.5]);
%         xlim([5 26]);

        ylim([6 9.5]);
        xlim([8 24.5]);

    elseif max(IDS) == 3 && min(IDS) == 2

        xlim([6.4 9.8]);
        ylim([4.8 6.5]);

    elseif max(IDS) == 2 && min(IDS) == 1

        xlim([5 6.8]);
        ylim([3.8 5.1]);

    elseif max(IDS) == 1

        ylim([4 4.1]);
        xlim([4 5.2]);

    elseif max(IDS) == 4 && length(IDS) == 1
        
        ylim([5.5 9.5]);
        xlim([8.5 40.0]);

    end

    xlabel('r_a [R_S]'); ylabel('r_p [R_S]');

elseif idcentral == 7

%     ylim();
    xlim([0 150]);

    xlabel('r_a [R_U]'); ylabel('r_p [R_U]');

end


end