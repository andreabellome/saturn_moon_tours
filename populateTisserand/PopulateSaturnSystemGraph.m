%% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%
%% Central body
% Garvitational parameter of the central body (in m3/s2)
centralBody = "saturn";
muCB = constants(6,1)*1e9; % --> Saturn in this case

%% Objects' names
objectNames = ["enceladus",...
               "tethys",...
               "dione",...
               "rhea",...
               "titan"
               ];

%% v-Infinities Range (m/s)
vInfLevels = struct();
vInfLevels.enceladus = 200:50:800; % --> From 200 m/s to 800 m/s in steps of 50 m/s
vInfLevels.tethys = 650:50:800;
vInfLevels.dione = 750:50:1000;
vInfLevels.rhea = 850:50:1850;
vInfLevels.titan = 1350:50:1460;

%% Radius of encounters
% Radius if the circular body of the gravity-assist bodies around the
% central body (in m)
rEncs = struct();
[~, ~, rEnc] = constants(6,1); rEncs.enceladus = rEnc*1e3;
[~, ~, rEnc] = constants(6,2); rEncs.tethys = rEnc*1e3;
[~, ~, rEnc] = constants(6,3); rEncs.dione = rEnc*1e3;
[~, ~, rEnc] = constants(6,4); rEncs.rhea = rEnc*1e3;
[~, ~, rEnc] = constants(6,5); rEncs.titan = rEnc*1e3;

%% Minimum Flyby Radius
% Minimum radius of periapsis for the flyby hiperbola for each of the
% gravity-assist bodies (in m)
minRps = {};
[~, ~, ~, radpl, hmin] = constants(6,1); minRps.enceladus = (radpl+hmin)*1e3;
[~, ~, ~, radpl, hmin] = constants(6,2); minRps.tethys = (radpl+hmin)*1e3;
[~, ~, ~, radpl, hmin] = constants(6,3); minRps.dione = (radpl+hmin)*1e3;
[~, ~, ~, radpl, hmin] = constants(6,4); minRps.rhea = (radpl+hmin)*1e3;
[~, ~, ~, radpl, hmin] = constants(6,5); minRps.titan = (radpl+hmin)*1e3;

%% Gravitational Parameters
% Gravitational parameter of each of the gravity-assist bodies (in m3/s2)
muFBs = {};
[~, muFB] = constants(6,1); muFBs.enceladus = muFB*1e9;
[~, muFB] = constants(6,2); muFBs.tethys = muFB*1e9;
[~, muFB] = constants(6,3); muFBs.dione = muFB*1e9;
[~, muFB] = constants(6,4); muFBs.rhea = muFB*1e9;
[~, muFB] = constants(6,5); muFBs.titan = muFB*1e9;

%% Maximum Revolutions
% Maximum number of revolutions for the resonances of each of the
% gravity-assist bodies
maxRevs = {};
maxRevs.enceladus = 25;
maxRevs.tethys = 35;
maxRevs.dione = 27;
maxRevs.rhea = 17;
maxRevs.titan = 3;

%% Compute Tisserand graph intersections

% Compute them with Airbus function
%intersections = findAllTissTransfers(objectNames,vInfLevels,rEncs,muCB);

% Compute them through AUTOMATE
intersections = findAllIntersectionsWithAUTOMATE(objectNames,vInfLevels,centralBody);

%% Populate Graph
resLists = populateTisserandGraph(objectNames,vInfLevels,rEncs,muCB,minRps,muFBs,maxRevs,[1 1],[3 1], intersections);


%% Check for Gaps
gapsTiss = findTisserandGraphGaps(objectNames,vInfLevels,rEncs,muCB,minRps,muFBs,resLists, intersections);
