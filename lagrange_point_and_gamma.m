function [ LagrPoint, gamma, vec ] = lagrange_point_and_gamma( strucNorm, lpoint )

if nargin == 1
    lpoint = 'L1';
end

x2  = strucNorm.x2;
xx2 = [ x2 0 0 ]; % --> secondary position

LagrangePoints = strucNorm.LagrangePoints;
Gammas         = vecnorm( [LagrangePoints - xx2]' )'; % --> distance between the secondary and the L-points

if strcmpi(lpoint, 'L1')
    LagrPoint = LagrangePoints(1,:);    % --> L-point
    gamma     = Gammas(1);              % --> distance between L-point and the secondary
    if nargout == 3
        vec = [ 1 0 0 ];                % --> direction from L-point to the secondary (positive along x)
    end
elseif strcmpi(lpoint, 'L2')
    LagrPoint = LagrangePoints(2,:);    % --> L-point
    gamma     = Gammas(2);              % --> distance between L-point and the secondary
    if nargout == 3
        vec = [ -1 0 0 ];               % --> direction from L-point to the secondary (negative along x)
    end
elseif strcmpi(lpoint, 'L3')
    LagrPoint = LagrangePoints(3,:);    % --> L-point
    gamma     = Gammas(3);              % --> distance between L-point and the secondary
    if nargout == 3
        vec = [ 1 0 0 ];                % --> direction from L-point to the secondary (positive along x)
    end
elseif strcmpi(lpoint, 'L4')
    LagrPoint = LagrangePoints(4,:);    % --> L-point
    gamma     = Gammas(4);              % --> distance between L-point and the secondary
    if nargout == 3
        vec = [ 1 0 0 ];                % --> direction from L-point to the secondary (positive along x)
    end
elseif strcmpi(lpoint, 'L5')
    LagrPoint = LagrangePoints(5,:);    % --> L-point
    gamma     = Gammas(5);              % --> distance between L-point and the secondary
    if nargout == 3
        vec = [ 1 0 0 ];                % --> direction from L-point to the secondary (positive along x)
    end
end

end
