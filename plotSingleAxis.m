function plotSingleAxis(cmpos, p1, radius, color)

if nargin == 2 || nargin == 3
    color = 'black';
end

CMPos = cmpos;

% Axis
%--------------------------------------------------------------------------
% X Axis   
   line([ CMPos(1) p1(1)],[ CMPos(2) p1(2)],[ CMPos(3) p1(3)],'Color',color, 'HandleVisibility','off')
%--------------------------------------------------------------------------
% Arrow head
% scale factor
H=gca;
xr=get(H,'xlim');
yr=get(H,'ylim');
zr=get(H,'zlim');
if nargin == 2
    s=norm([xr(2)-xr(1),yr(2)-yr(1),zr(2)-zr(1)]);
    r=s/150; % radius
elseif nargin == 3
    r = radius;
end

h=6*r; % height
n=20; m=20; % grid spacing
[x,y,z]=cylinder(linspace(0,r,n),m);

H=surf(x+p1(1),y+p1(2),z*h+p1(3));

set(H,'FaceColor',color,'EdgeColor',color, 'HandleVisibility', 'off')

P=p1-CMPos; % position vector
U=P/norm(P); % unit vector
D=cross([0,0,1],-U); % rotation axis
if norm(D)<eps, D=[1,0,0]; end
A=acos(dot([0,0,1],-U)); % rotation angle
rotate(H,D,A*180/pi,p1)
%--------------------------------------------------------------------------

end
