function points = computePointsCoordinatesAndAngle(origin, startPoint, d, r)
%Given a circle locates at origin with radius r, return a list of points on
%the circle that starts from startPoint, and the distance between each point
%is d

alpha = atan2(startPoint(2) - origin(2), startPoint(1) - origin(1));
beta = 2 * asin(d/2/r);
numPoints = ceil(2*pi/beta);

points = [startPoint; zeros(numPoints - 1, 2)];
angle = zeros(numPoints, 1);

for i = 2:numPoints
    theta = alpha + (i - 1) * beta;
    points(i, 1) = origin(1) + r * cos(theta);
    points(i, 2) = origin(2) + r * sin(theta);
    angle(i - 1) = atan2(points(i, 2) - points(i - 1, 2), points(i, 1) - points(i - 1, 1));
end
% the angle for last point is computed against first point
% angle(i) = atan2(startPoint(2) - points(i, 2), startPoint(1) - points(i, 1));

end