function squaredDistanceSum = computeSquaredDistanceSumVectorization(origin, points, theta)
%Compute sum of squared point-to-path distance with vectorization
%   Given an origin point [x0, y0] and an array of points [[x1, y1], [x2,
%   y2], ..., [xn, yn]], compute the summation of squared distance from
%   point [xi, yi] to a line, which orginates from origin [x0, y0], and the
%   angle with x axis is denoted as theta.

% vectorization
% atan2(2, 1)
% atan2([2, 3], [1, 0]) <==> [atan2(2, 1), atan2(3, 0)]

alpha = atan2(points(:, 2) - origin(2), points(:, 1) - origin(1));
beta = theta - alpha;
point2Origin = sqrt((points(:, 1) - origin(1)).^2 + (points(:, 2) - origin(2).^2));
distance = point2Origin.*sin(beta);
squaredDistanceSum = sum(distance.^2);
end




