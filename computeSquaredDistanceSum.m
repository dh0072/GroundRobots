function squaredDistanceSum = computeSquaredDistanceSum(origin, points, theta)
%Compute sum of squared point-to-path distance
%   Given an origin point [x0, y0] and an array of points [[x1, y1], [x2,
%   y2], ..., [xn, yn]], compute the summation of squared distance from
%   point [xi, yi] to a line, which orginates from origin [x0, y0], and the
%   angle with x axis is denoted as theta.
squaredDistanceSum = 0;
numPoints = size(points, 1);
for i = 1:numPoints
    ithPoint = points(i, :);
    ithAlpha = atan2(ithPoint(2) - origin(2), ithPoint(1) - origin(1));
    ithBeta = theta - ithAlpha;
    ithPoint2Origin = sqrt((ithPoint(1) - origin(1)).^2 + (ithPoint(2) - origin(2)).^2);
    ithDistance = ithPoint2Origin.*sin(ithBeta);
    squaredDistanceSum = squaredDistanceSum + ithDistance.^2;
end
end

