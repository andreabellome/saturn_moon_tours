function list = resonanceList(idMO, idcentral)

% DESCRIPTION
% This provides the list of resonant ratios for different moons/planets.
%
% INPUT
% - idMO      : ID of the flyby body to compute the resonances (see also
%               constants.m)
% - idcentral : ID of the central body (see also constants.m)
%
% OUTPUT
% - list : Nx2 matrix with the following:
%          - list(:,1) : integer number of flyby body revolutions
%          - list(:,2) : integer number of spacecraft revolutions
%          this matrix is sorted in descend order with respect to the
%          resonant ratio, i.e., list(:,1)./list(:,2)
% 
% -------------------------------------------------------------------------

if idcentral == 1 % --> central body : SUN

    if idMO == 1     % --> MERCURY
        list = [[1 1]; [6 5]; [5 4]; [4 3]; [3 2]];
    elseif idMO == 2 % --> VENUS
        list = [[1 1]; [2 1]; [3 4]; [2 3]; [1 2]];
    elseif idMO == 3 % --> EARTH
        list = [[1 1]; [2 1]; [3 1]; [3 2]; [2 3]];
    elseif idMO == 4 % --> MARS
        list = [[1 1]; [2 1]; [3 1]];
    elseif idMO == 5 % --> JUPITER
        list = [];
    elseif idMO == 6 % --> SATURN
        list = [];
    elseif idMO == 7 % --> URANUS
        list = [];
    elseif idMO == 8 % --> NEPTUNE
        list = [];
    elseif idMO == 9 % --> PLUTO
        list = [];
    end

elseif idcentral == 6 % --> central body : SATURN

    if idMO == 0
        list = [ 2 1; 3 1; 4 1; 4 3; 20 14; [7 6]; [20 17]; [15 13]; [8 7]; [17 15]; [9 8]; [19 17]; [10 9];...
            [21 19]; [11 10]; [12 11]; [13 12]; [14 13]; [15 14]; [16 15];...
            [19 18]; [24 23]; 17 16; 21 20; 13 11; 22 19; 15 13; 25 22;...
            18 17; 1 1;[1 2]; [19 21]; [10 11]; [11 12]; [13 14]; [14 15]; [15 16]; [18 19]; [23 24] ];
    elseif idMO == 1
        % --> ENCELADUS
        list = [
            [7 6]; [20 17]; [15 13]; [8 7]; [17 15]; [9 8]; [19 17]; [10 9];...
            [21 19]; [11 10]; [12 11]; [13 12]; [14 13]; [15 14]; [16 15];...
            [19 18]; [24 23]; 17 16; 21 20; 13 11; 22 19; 15 13; 25 22;...
            18 17; 1 1;
            ];
%         ... % --> cancel the next ones because they are not strictly needed...
%             [1 2]; 8 9; 7 8; 6 7;  5 6; 4 5; [19 21]; [10 11]; [11 12]; [13 14]; [14 15]; [15 16]; [18 19]; [23 24]; 1 3; 2 5]; 

    elseif idMO == 2

        % --> TETHYS

        % % --> this is the old without the constraints
        % list = [[11 9]; [6 5]; [7 6]; [8 7]; [9 8]; [10 9]; [11 10]; [12 11];...
        %     [13 12]; [14 13]; [15 14]; [1 1]; [13 14]; [10 11]; [9 10]; [7 8]; [14 15]; [13 15]];
        
        % --> this is the new with the constraints
        list = [1   1
                11	9
                6	5
                7	6
                8	7
                9	8
                10	9
                11	10
                12	11
                13	12
                14	13
                15	14
                19	18
                25	24

                35	34
                34	35
                
                24	25
                18	19
                14	15
                13	14
                10	11
                9	10
                7	8
                13	15
                
                % --> from here
                4 4
                5 5
                6 6

                34 33
                33 32

                33 32
                32 33

                32 31
                31 32

                31 30
                30 31

                30 29
                29 30

                29 28
                28 29

                28 27
                27 28];

    elseif idMO == 3
        % --> DIONE

        % % --> this is the old without the constraints
        % list = [[4 3]; [9 7]; [5 4]; [6 5]; [7 6]; [8 7]; [9 8]; [10 9]; [11 10];...
        %     [12 11]; [1 1]; [11 12]; [10 11]; [9 10]; [8 9]; ...
        %     [7 8]; [6 7]; [14 15]; [13 12]; [12 13]]; 
        
        % --> this is the new with the constraints
        list = [1     1
                4	    3
                9	    7
                5	    4
                6	    5
                7	    6
                8	    7
                9	    8
                10	    9
                11	    10
                12	    11
                13	    12
                19	    18
%                 30	    29
%                 29	    30
                18	    19
                14	    15
                12	    13
                11	    12
                10	    11
                9	    10
                8	    9
                7	    8
                6	    7
                
                % --> from here
                3 3
                4 4
                5 5

                27 26
                26 27
                
                26 25
                25 26

                25 24
                24 25];

    elseif idMO == 4
        % --> RHEA

        % % --> this is the old without the constraints
        % list = [ 4    3
        %          5	4
        %          7	6
        %          1	1
        %          6	7
        %          3	2
        %          7	5
        %          5	3
        %          8	5
        %          7	4
        %          2	1
        %         15	8 
        %         17    8
        %         8     9 
        %         6     5 ]; 

        % --> this is the new with the constraints
        list = [1     1
                13 7
                9 7 
                4 5
                5 3
                3 1
                7 6
                3	  2
                7	  5
                4	  3
                5	  4
                6	  5

                15	  14
                14	  15

                2 2
                3 3
                4 4

                6	  7
                2	  1
                5	  3
                8	  5
                7	  4
                15	  8

                17	  8
                
                % --> from here
                9  8
                8  9

                8  7
                7  8
                
                10 9
                9  10
                
                11 10
                10 11
                
                12 11
                11 12
                
                13 12
                12 13];


    elseif idMO == 5
        % --> TITAN
        list = [ 3 1; 2 1; 1 1 ];
    end

elseif idcentral == 5 % --> central body : JUPITER

    if idMO == 1
        % --> Io
%         list = [ [1 1]; [2 1]; [3 2]; [3 1]; 5 4; 4 5; 6 5; 5 6; 4 3; 3 4; ];
        list = [ 1 1; 5 4; 4 3 ];
    elseif idMO == 2
        % --> Europa
        list = [ 11 10; 7 5; 8 5; 5 3; 5 4; 3 2; 4 1; 7 2; 3 1; 5 2; 2 1; 7 4; 3 2; 4 3; 6 5; 10 9; 7 3;
                   1 1; 1 2; 1 3; 2 3; 1 4; 5 8 ]; 
%         list = [ 1 1; 4 5; 5 4; 4 3 ];
%         list = [8	5
%                 3	2
%                 4	3
%                 7	5
%                 5	3];
%         listc     = list;
%         list(:,1) = listc(:,2);
%         list(:,2) = listc(:,1);
        
    elseif idMO == 3
        % --> Ganimede
        list = [[8 1]; [31 1]; [4 1]; [5 2]; [ 3 2 ] ];
        % [[16 1]; [5 1]; [3 1]; [2 1]; [1 1]; [3 2]; [5 4]; [5 6]; [5 2]; [31 1] ];
        %  [12 1]; [10 1]; [8 1]; [6 1]; [5 1]; [4 1]; [3 1]; [2 1]; [1 1]; [1 2]; [3 2]];
    elseif idMO == 4
        % --> Callisto
        list = [[1 1]; [2 3]; [3 2]; [2 1]; [3 1]; [4 1]];
    end

elseif idcentral == 7 % --> central body : URANUS

    if idMO == 1
        % --> XXXXX
        list = [
            [7 6]; [20 17]; [15 13]; [8 7]; [17 15]; [9 8]; [19 17]; [10 9];...
            [21 19]; [11 10]; [12 11]; [13 12]; [14 13]; [15 14]; [16 15]; [19 18]; [24 23]; [1 1]
            ];
    elseif idMO == 2
        % --> XXXXX
        list = [[11 9]; [6 5]; [7 6]; [8 7]; [9 8]; [10 9]; [11 10]; [12 11];...
            [13 12]; [14 13]; [15 14]; [1 1]; [13 14]; [10 11]; [9 10]; [7 8]; [14 15]];
    elseif idMO == 3
        % --> XXXXX
        list = [[4 3]; [9 7]; [5 4]; [6 5]; [7 6]; [8 7]; [9 8]; [10 9]; [11 10];...
            [12 11]; [1 1]; [11 12]; [10 11]; [9 10]; [8 9]; [7 8]; [6 7]; [14 15]]; 
    elseif idMO == 4
        % --> XXXXX
        list = [[10 11]; [3 1]; [8 3]; [5 2]; [7 3]; [9 4]; [11 5]; [2 1]; 
            [11 6]; [7 4]; [8 5]; [3 2]; [10 7]; [7 5]; [9 7]; [6 5]; [9 8];
            [1 1]; [5 6]];
    elseif idMO == 5
        % --> XXXXX
        list = [[4 1]; [3 1]; [2 1]; [1 1]];
    end

end

% --> order by resonant ratio
if ~isempty(list)
    
    list = unique(list, "rows", "stable");
    ratios = sortrows( [-list(:,1)./list(:,2), [1:1:size(list,1)]'] );
    list   = list( ratios(:,2), :);

end

end

