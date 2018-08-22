function cirularPoints = genCircularPoints(origin, radius, numPoints)
%GENCIRCULARPOINTS Generate points on a circle described by origin and radius
%   Generate points starting at [origin(1) + radius, origin(2)]
theta0 = 2 * pi / numPoints;
cirularPoints = zeros(numPoints, 2);

for i = 1:numPoints
    theta = theta0 * (i - 1);
    cirularPoints(i, 1) = origin(1) + radius * cos(theta);
    cirularPoints(i, 2) = origin(2) + radius * sin(theta);
end

end

