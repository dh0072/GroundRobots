clc;
clear;
close all;


% Case - 1: circular points
origin = [0, 0];
radius = 6;
startPoint = [6, 0];  % first group point
home = [6, 0];  % start position of robot
maxStep = 0.5; % The max distance that the robot can go within 1 step
distanceBetweenPoints = 0.016;

% Sanity check
if distanceBetweenPoints > maxStep  
    error('Error: distanceBetweenPoints (%s) is greater than maxStep (%s)', distanceBetweenPoints, maxStep);
end

originalPoints = computePointsCoordinatesAndAngle(origin, startPoint, distanceBetweenPoints, radius);
offset1 = [-radius * 0.2, radius * 0.2];
radius1 = radius * 0.1;
numPoints1 = 150;
origin1 = [origin(1) + offset1(1), origin(2) + offset1(2)];
extraPoints1 = genCircularPoints(origin1, radius1, numPoints1);

offset2 = [radius * 0.4, -radius * 0.3];
radius2 = radius * 0.1;
numPoints2 = 150;
origin2 = [origin(1) + offset2(1), origin(2) + offset2(2)];
extraPoints2 = genCircularPoints(origin2, radius2, numPoints2);

offset3 = [-radius * 0.5, -radius * 0.45];
radius3 = radius * 0.2;
numPoints3 = 150;
origin3 = [origin(1) + offset3(1), origin(2) + offset3(2)];
extraPoints3 = genCircularPoints(origin3, radius3, numPoints3);
points = [originalPoints; extraPoints1; extraPoints2; extraPoints3];

% Check if points are inside specified area
minX = min(points(:, 1));
maxX = max(points(:, 1));
minY = min(points(:, 2));
maxY = max(points(:, 2));

gridWidth = 18 * 0.0254;
xRange = minX:gridWidth:maxX;
yRange = minY:gridWidth:maxY;

if xRange(end) ~= maxX
    xRange = [xRange, maxX];
end
if yRange(end) ~= maxY
    yRange = [yRange, maxY];
end

[x, y] = meshgrid(xRange, yRange);
gridPoints = [x(:), y(:)];

isInPolygon1 = inpolygon(gridPoints(:, 1), gridPoints(:, 2), ...
[originalPoints(:, 1); originalPoints(1, 1); NaN; flipud(extraPoints1(:, 1)); flipud(extraPoints1(1, 1))], ...
[originalPoints(:, 2); originalPoints(1, 2); NaN; flipud(extraPoints1(:, 2)); flipud(extraPoints1(1, 2))]);

isInPolygon2 = inpolygon(gridPoints(:, 1), gridPoints(:, 2), ...
[originalPoints(:, 1); originalPoints(1, 1); NaN; flipud(extraPoints2(:, 1)); flipud(extraPoints2(1, 1))], ...
[originalPoints(:, 2); originalPoints(1, 2); NaN; flipud(extraPoints2(:, 2)); flipud(extraPoints2(1, 2))]);

isInPolygon3 = inpolygon(gridPoints(:, 1), gridPoints(:, 2), ...
[originalPoints(:, 1); originalPoints(1, 1); NaN; flipud(extraPoints3(:, 1)); flipud(extraPoints3(1, 1))], ...
[originalPoints(:, 2); originalPoints(1, 2); NaN; flipud(extraPoints3(:, 2)); flipud(extraPoints3(1, 2))]);

isInPolygon = isInPolygon1 & isInPolygon2 & isInPolygon3;

figure;
hold on;
plot(points(:, 1), points(:, 2), ".b");
plot(x(isInPolygon), y(isInPolygon), "og");
plot(x, y, ".r");
axis equal;
hold off;
xlabel("X axis (m)", "FontSize", 16);
ylabel("Y axis (m)", "FontSize", 16);
lgd = legend("Input points", "Inside points", "Grid points");
lgd.FontSize = 14;

% Generate optimal path
[optimalPathPoints, criticalIndices] = generateOptimalPathPoints(points, maxStep);
transformedOptimalPathPoints = transformAndRotate(optimalPathPoints, points);

% Plot transformedOptimalPathPoints
figure;
hold on;
lastCriticalIndex = 1;
i = 1;
while criticalIndices(i) ~= 0
    drawOptimalPathPoints(transformedOptimalPathPoints(lastCriticalIndex:criticalIndices(i), :));
    lastCriticalIndex = criticalIndices(i) + 1;
    i = i + 1;
end
grid on;
axis equal;
xlabel("X axis (m)", "FontSize", 16);
ylabel("Y axis (m)", "FontSize", 16);
lgd = legend("Optimal path");
lgd.FontSize = 14;
title("Case 1 - circular points", "FontSize", 16);


% Case - 2: loaded points
maxStep = 0.03;
pointsStruct = load("points.mat");
points = pointsStruct.points.';

% % Remove adjacent duplicated points
% points = points(any(diff([[0, 0]; points]) ~= [0, 0], 2), :);

% Find index of point which is closest to first point
squaredDistance2FirstPoint = sum((points - points(1, :)) .^ 2, 2);
startIndex = find(squaredDistance2FirstPoint > (maxStep / 10) ^ 2);
[~, shiftedClosestPointIndex] = min(squaredDistance2FirstPoint(startIndex(1):end));
closestPointIndex = shiftedClosestPointIndex + startIndex(1) - 1;

% Find critical index to distinguish outer or inner contour
criticalDistance = maxStep;
criticalIndex = find(sum(diff(points) .^ 2, 2) > criticalDistance .^ 2);

% Remove redundant points ranging from (closestPointIndex + 1) to critical
points(closestPointIndex + 1:criticalIndex, :) = [];

% Copy first inner point to the last position to form a closed inner loop
points = [points; points(closestPointIndex + 1, :)];

outerContourPoints = points(1:closestPointIndex, :);
innerContourPoints = points(closestPointIndex + 1:end, :);

% Check if points are inside specified area
minX = min(points(:, 1));
maxX = max(points(:, 1));
minY = min(points(:, 2));
maxY = max(points(:, 2));

gridWidth = 0.5 * 0.0254;
xRange = minX:gridWidth:maxX;
yRange = minY:gridWidth:maxY;

if xRange(end) ~= maxX
    xRange = [xRange, maxX];
end
if yRange(end) ~= maxY
    yRange = [yRange, maxY];
end

[x, y] = meshgrid(xRange, yRange);
gridPoints = [x(:), y(:)];

isInPolygon = inpolygon(gridPoints(:, 1), gridPoints(:, 2), ...
[outerContourPoints(:, 1); outerContourPoints(1, 1); NaN; flipud(innerContourPoints(:, 1)); flipud(innerContourPoints(1, 1))], ...
[outerContourPoints(:, 2); outerContourPoints(1, 2); NaN; flipud(innerContourPoints(:, 2)); flipud(innerContourPoints(1, 2))]);

figure;
hold on;
plot(points(:, 1), points(:, 2), ".b");
plot(x(isInPolygon), y(isInPolygon), "og");
plot(x, y, ".r");
axis equal;
hold off;
xlabel("X axis (m)", "FontSize", 16);
ylabel("Y axis (m)", "FontSize", 16);
lgd = legend("Input points", "Inside points", "Grid points");
lgd.FontSize = 14;

% Generate optimal path
[optimalPathPoints, criticalIndices] = generateOptimalPathPoints(points, maxStep);
transformedOptimalPathPoints = transformAndRotate(optimalPathPoints, points);

% Plot transformedOptimalPathPoints
figure;
hold on;
lastCriticalIndex = 1;
i = 1;
while criticalIndices(i) ~= 0
    drawOptimalPathPoints(transformedOptimalPathPoints(lastCriticalIndex:criticalIndices(i), :));
    lastCriticalIndex = criticalIndices(i) + 1;
    i = i + 1;
end
grid on;
axis equal;
xlabel("X axis (m)", "FontSize", 16);
ylabel("Y axis (m)", "FontSize", 16);
lgd = legend("Optimal path");
lgd.FontSize = 14;
title("Case 2 - custom points", "FontSize", 16);