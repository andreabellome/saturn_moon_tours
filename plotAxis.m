
function plotAxis(cmpos, verslen)

CMPos = cmpos;

% Axis
%--------------------------------------------------------------------------
% X Axis   
   p1=[verslen 0 0];
   line([ CMPos(1) p1(1)],[ CMPos(2) p1(2)],[ CMPos(3) p1(3)],'Color',[0 0 0])
%--------------------------------------------------------------------------
% Arrow head
% scale factor
H=gca;
xr=get(H,'xlim');
yr=get(H,'ylim');
zr=get(H,'zlim');
s=norm([xr(2)-xr(1),yr(2)-yr(1),zr(2)-zr(1)]);

r=s/750; % radius
h=6*r; % height
n=20; m=20; % grid spacing
[x,y,z]=cylinder(linspace(0,r,n),m);

H=surf(x+p1(1),y+p1(2),z*h+p1(3));
set(H,'FaceColor','k','EdgeColor','k')
P=p1-CMPos; % position vector
U=P/norm(P); % unit vector
D=cross([0,0,1],-U); % rotation axis
if norm(D)<eps, D=[1,0,0]; end
A=acos(dot([0,0,1],-U)); % rotation angle
rotate(H,D,A*180/pi,p1)
%--------------------------------------------------------------------------
% Y axis
   py=[0 verslen 0];
   line([ CMPos(1) py(1)],[ CMPos(2) py(2)],[ CMPos(3) py(3)],'Color',[0 0 0])
% Arrow head Y
% scale factor
H=gca;
xr=get(H,'xlim');
yr=get(H,'ylim');
zr=get(H,'zlim');
% s=norm([xr(2)-xr(1),yr(2)-yr(1),zr(2)-zr(1)]);

% r=s/750; % radius
% h=6*r; % height
% n=20; m=20; % grid spacing
[x,y,z]=cylinder(linspace(0,r,n),m);

H=surf(x+py(1),y+py(2),z*h+py(3));
set(H,'FaceColor','k','EdgeColor','k')
P=py-CMPos; % position vector
U=P/norm(P); % unit vector
D=cross([0,0,1],-U); % rotation axis
if norm(D)<eps, D=[1,0,0]; end
A=acos(dot([0,0,1],-U)); % rotation angle
rotate(H,D,A*180/pi,py)

%--------------------------------------------------------------------------
% Z axis
   pz=[0 0  verslen];
   line([ CMPos(1) pz(1)],[ CMPos(2) pz(2)],[ CMPos(3) pz(3)],'Color',[0 0 0])

   % Arrow head Z
% scale factor
H=gca;
xr=get(H,'xlim');
yr=get(H,'ylim');
zr=get(H,'zlim');
% s=norm([xr(2)-xr(1),yr(2)-yr(1),zr(2)-zr(1)]);

% r=s/750; % radius
% h=6*r; % height
% n=20; m=20; % grid spacing
[x,y,z]=cylinder(linspace(0,r,n),m);

H=surf(x+pz(1),y+pz(2),z*h+pz(3));
set(H,'FaceColor','k','EdgeColor','k')
P=pz-CMPos; % position vector
U=P/norm(P); % unit vector
D=cross([0,0,1],-U); % rotation axis
if norm(D)<eps, D=[1,0,0]; end
A=acos(dot([0,0,1],-U)); % rotation angle
rotate(H,D,A*180/pi,pz)
%--------------------------------------------------------------------------
% view(axes1,[0 90]);
% hold(axes1,'all');

end
