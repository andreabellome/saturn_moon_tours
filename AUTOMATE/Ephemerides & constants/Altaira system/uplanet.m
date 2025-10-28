function  [kep] = uplanet(tad0, ibody)

% uplanet.m - Analytical ephemerides for planets
%
% PROTOTYPE:
%  [kep, ksun] = uplanet (mjd2000, ibody);
%
% DESCRIPTION:
%   Planetary orbital elements are restituited in a Altaira-centred ecliptic 
%   system.
%
%  INPUT :
%	t0days[1]   Time since day 0 in days
%	ibody[1]    Integer number identifying the celestial body (< 11)
%                   1:   Vulcan
%                   2:   Yavin
%                   3:   Eden
%                   4:   Hoth
%                   5:   Beyonce
%                   6:   Bespin
%                   7:   Jotunn
%                   8:   Wakonyingo
%                   9:   Rogue1
%                   10:  PlanetX
%
%  OUTPUT:
%	kep[6]    	Mean Keplerian elements of date
%                 kep = [a e i Om om theta] [km, rad]
%	ksun[1]     Gravity constant of the Sun [km^3/s^2]
%
%   Note: The ephemerides of the Moon are given by EphSS_kep, according to
%           to the algorithm in ephMoon.m
%
%  FUNCTIONS CALLED:
%   (none)
%

DEG2RAD=pi/180;
G=6.67259e-20; 
AU = 149597870.691; %[km]
muAlt=139348062043.343; % [km3/s2]
massAlt=muAlt/G;


AltairaPlanets=[13811982.9420000	0	0	0	315.372000000000	322.584000000000;
                128528229.968000	0.0500000000000000	3	110.499000000000	148.135000000000	155.310000000000;  
                179517444.840000	0.00700000000000000	1	107.472000000000	356.208000000000	51.897000000000;
                439627001.911000	0.0500000000000000	12	95.4970000000000	18.9230000000000	121.720000000000;
                1119105767.21800	0.0700000000000000	0	220.319000000000	116.863000000000	64.8200000000000;
                2138564173.38500	0.119000000000000	0.400000000000000	173.526000000000	333.322000000000	310.972000000000;
                2622318885.76300	0.150000000000000	5	209.170000000000	16.3670000000000	199.109000000000;
                5115499188.58700	0.0950000000000000	15	33.7230000000000	107.462000000000	158.153000000000;
                10048973262.5720	0.100000000000000	175	161.693000000000	318	280.461000000000;
                15955016885.3570	0.345000000000000	40	341.693000000000	30	133.427000000000];


T0=0; 
kep=AltairaPlanets(ibody,:);
  
%
%  CONVERSION OF AU INTO KM, DEG INTO RAD AND DEFINITION OF  XMU
%

kep(3:6) = kep(3:6)*DEG2RAD;    % Transform from deg to rad
kep(6)   = mod(kep(6),2*pi);

%===================================================== 
a  =kep(1);
e  =kep(2);
di =kep(3);
omm=kep(4);
om =kep(5);
m  =kep(6);
n  =sqrt(muAlt/a^3);

t0 =m/n;

t=tad0*86400+t0;


p=2*pi*sqrt(a^3/muAlt);
np=floor(t/p);
t=t-p*np;
phi=n*t;
M  = phi;
if M>pi
    M = M-2*pi;
end

% Ciclo di Newton: devo mandare a zero la funzione
%f=(M-E+esinE)...parto da E=M...deltaE=-fdot^-1*f
for i=1:5
    ddf=(e*cos(phi)-1);
    phi=phi-t*n/ddf+(phi-e*sin(phi))/ddf;
end

wom=2*atan(sqrt((1+e)/(1-e))*tan(phi*0.5)); % In radians
kep=[a e di omm om wom];




return