function T = save_tour_excel_file( PATHph, idcentral, file_name )

% DESCRIPTION: 
% This function saves the moon tour to an Excel file to better display the
% values. 
%
% INPUT: 
% - PATHph : structure where each row is a tour for a different moon phase.
%            It has the following fields:
%            - path : matrix with tour on specific phase. 
%            - dvPhase : DV total for the given phase [km/s]
%            - tofPhase : time of flight for the given phase [days]
%            - dvOI     : DV for orbit insertion only valid for the last
%            phase (see also orbitInsertion.m)
% - idcentral : ID of the central body (see also constants.m)
% - file_name : (str) string with name of the file to be saved
% 
% OUTPUT: 
% - T     : table with all the details of the tour
%
% -------------------------------------------------------------------------


path_ph   = PATHph;

mat = {};
for indp = 1:length(path_ph)

    path = path_ph(indp).path;

    for indl = 2:size(path,1)
        
        if isnan(path(indl,6))

            % --> name of the flyby body
            [~, arr_moon] = planet_names_GA(path(indl,1), idcentral);
            [~, dep_moon] = planet_names_GA(path(indl-1,1), idcentral);
            
            dv  = 0;
            tof = 0;
            
            vinf1 = path(indl,8) * 1e3;
            vinf2 = path(indl,10) * 1e3;
            
            % Append row
            mat = [mat; {dep_moon, arr_moon, '', '', '', vinf1, vinf2, dv, tof}];

        else
            % Translate type code
            switch path(indl,2)
                case 88, type = 'OO';
                case 81, type = 'OI';
                case 18, type = 'IO';
                case 11, type = 'II';
                otherwise, type = 'Unknown';
            end
    
            % Numeric values kept as numbers, NOT strings
            kei = path(indl,3);
            N   = path(indl,4);
            M   = path(indl,5);
            L   = path(indl,6);
            
            vinf1 = path(indl,8) * 1e3;
            vinf2 = path(indl,10) * 1e3;
    
            % n:m(L) is still a string
            nml = sprintf('%d:%d(%d)', N, M, L);
    
            dv  = path(indl,11) * 1e3;   % m/s
            if dv < 1e-6
                dv = 0;
            end
            tof = path(indl,12);         % days (numeric)
            
            % --> name of the flyby body
            [~, dep_moon] = planet_names_GA(path(indl,1), idcentral);
            [~, arr_moon] = planet_names_GA(path(indl,1), idcentral);
    
            % Append row
            mat = [mat; {dep_moon, arr_moon, type, kei, nml, vinf1, vinf2, dv, tof}];

        end

    end

end

% Build table with proper variable names
T = cell2table(mat, 'VariableNames', ...
    {'Dep. Moon', 'Arr. Moon', ...
    'Type','kei','N:M(L)', ...
    'Dep. Vinf [m/s]', 'Arr. Vinf [m/s]', ...
    'DV [m/s]','ToF [days]'});

% Write to excel sheet "indp"
writetable(T, file_name, 'Sheet', num2str(indp));

end