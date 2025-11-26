function T = save_phased_tour_excel_file( PATHphNew, idcentral, INPUT, t0, file_name )

% DESCRIPTION:
% XXXXX
% 
% INPUT: 
% - path : structure where each row is a tour for a different moon phase.
%          This is considered to have phasing!
%            It has the following fields:
%            - path : matrix with tour on specific phase. 
%            - dvPhase : DV total for the given phase [km/s]
%            - tofPhase : time of flight for the given phase [days]
%            - dvOI     : DV for orbit insertion only valid for the last
%            phase (see also orbitInsertion.m)
% - INPUT : structure with the following mandatory fields:
%           - idcentral    : ID of the central body (see constants.m)
%           - phasingOptions : structure with phasing options (see
%           writeInPhasing.m for example)
% - t0       : initial date of the tour [MJD2000]
% - file_name : (str) string with name of the file to be saved
%
% OUTPUT:
% - T     : table with all the details of the tour
%
% -------------------------------------------------------------------------

mu_central = constants(idcentral, 1);

% --> process the phased solution
VILTstruc = extractVILTstrucPhasedAndPlot(PATHphNew, INPUT, t0);

for indv = 1:length(VILTstruc)
    
    cart_dep = [VILTstruc(indv).rr1, VILTstruc(indv).vvd];
    cart_arr = [VILTstruc(indv).rr2, VILTstruc(indv).vva];

    kep_dep  = car2kep( cart_dep, mu_central );
    kep_arr  = car2kep( cart_arr, mu_central );
    
    th_dep = wrapTo2Pi(kep_dep(6));
    th_arr = wrapTo2Pi(kep_arr(6));
    
    type = [];
    if th_dep > 0 && th_dep <= pi
        type(1) = 8;
    elseif th_dep > 0 && th_dep > pi && th_dep <= 2*pi
        type(1) = 1;
    end
    if th_arr > 0 && th_arr <= pi
        type(2) = 8;
    elseif th_arr > 0 && th_arr > pi && th_arr <= 2*pi
        type(2) = 1;
    end

    VILTstruc(indv).type = str2double(sprintf('%d%d', type(1), type(2)));

end

mat = [];
for indv = 1:length(VILTstruc)

    % Translate type code
    switch VILTstruc(indv).type
        case 88, type = 'OO';
        case 81, type = 'OI';
        case 18, type = 'IO';
        case 11, type = 'II';
        otherwise, type = 'Unknown';
    end

    S     = VILTstruc(indv).S;
    
    if isnan(S(end))
        kei = '';
        nml = '';
    else
        kei   = S(2);
        nml   = sprintf('%d:%d(%d)', S(3), S(4), S(5));
    end
    vinf1 = VILTstruc(indv).vinf1 * 1e3;
    vinf2 = VILTstruc(indv).vinf2 * 1e3;
    
    dv  = VILTstruc(indv).dv * 1e3;
    tof = VILTstruc(indv).tof; 

    % --> name of the flyby body
    [~, dep_moon] = planet_names_GA(VILTstruc(indv).id1, idcentral);
    [~, arr_moon] = planet_names_GA(VILTstruc(indv).id2, idcentral);

    % Append row
    mat = [mat; {dep_moon, arr_moon, type, kei, nml, vinf1, vinf2, dv, tof}];

end

% Build table with proper variable names
T = cell2table(mat, 'VariableNames', ...
    {'Dep. Moon', 'Arr. Moon', ...
    'Type','kei','N:M(L)', ...
    'Dep. Vinf [m/s]', 'Arr. Vinf [m/s]', ...
    'DV [m/s]','ToF [days]'});

writetable(T, file_name, 'Sheet', num2str(1));

end