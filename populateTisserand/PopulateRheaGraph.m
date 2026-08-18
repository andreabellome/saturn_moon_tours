%% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%

% vInf levels
vInfLevels = 850:50:1850;

% Low Pump Bounds
lowBounds = [zeros(15,1);
             deg2rad(21);
             deg2rad(21);
             deg2rad(30);
             deg2rad(30);
             deg2rad(36.5);
             deg2rad(36.5)];

% Upper Pump Bounds
upBounds = [deg2rad(148.5);
            deg2rad(143);
            deg2rad(138);
            deg2rad(134);
            deg2rad(132);
            deg2rad(129);
            deg2rad(126.5);
            deg2rad(124);
            deg2rad(122.5);
            deg2rad(120);
            deg2rad(118.5);
            deg2rad(117);
            deg2rad(116);
            deg2rad(114);
            deg2rad(113);
            deg2rad(113);
            deg2rad(110);
            deg2rad(110);
            deg2rad(107.5);
            deg2rad(107.5);
            deg2rad(105.5);];

AUTOMATEResList = resonanceList_Original(4, 6);

%resList = populateObjectContours(vInfLevels,(763.8+50)*1e3,153.94*1e9,527108*1e3,37931005.114*1e9,20,'pumpBounded',[lowBounds upBounds]);
resList = populateObjectContours(vInfLevels,(763.8+50)*1e3,153.94*1e9,527108*1e3,37931005.114*1e9,15,'resBounded',[4 5; 17 8]);

%gapsAUTOMATE = findObjectContoursGaps(vInfLevels,(763.8+50)*1e3,153.94*1e9,527108*1e3,37931005.114*1e9,AUTOMATEResList,'pumpBounded',[lowBounds upBounds]);
gapsAUTOMATE = findObjectContoursGaps(vInfLevels,(763.8+50)*1e3,153.94*1e9,527108*1e3,37931005.114*1e9,AUTOMATEResList,'resBounded',[4 5; 17 8]);

%gapsResList = findObjectContoursGaps(vInfLevels,(763.8+50)*1e3,153.94*1e9,527108*1e3,37931005.114*1e9,resList,'pumpBounded',[lowBounds upBounds]);
gapsResList = findObjectContoursGaps(vInfLevels,(763.8+50)*1e3,153.94*1e9,527108*1e3,37931005.114*1e9,resList,'resBounded',[4 5; 17 8]);

