close all;  % close all matlab windows
clc;  % clear command window
clear;  % clear workspace variables 

% Compute the squared distance of ith point to a line, which starts from
% origin and the anle with axis is denoted as theta
origin = [0, 0];
points = [[2, 0]; [1, 1]];
theta = pi/2;

squaredDistanceSum1 = computeSquaredDistanceSum(origin, points, theta);
squaredDistanceSum2 = computeSquaredDistanceSumVectorization(origin, points, theta);


% Optimize theta to minimize cost/objective function
% computeSquaredDistance with given origin and points
origin = [0, 0];
points = [[1, 0]; [0, 1]; [1, 1]; [0.3, -1]];
func = @(t)computeSquaredDistanceSum(origin, points, t);  % Objective function

% Plot objective function versus theta
theta = 0:(5 * pi/180):2*pi;
squaredDistanceSum = func(theta);
figure;
plot(theta, squaredDistanceSum);
axis equal;
title("Sum of squared distance vs theta");
xlabel("theta/radian");
ylabel("Squared distance sum/meter");
grid on;
% Search theta such that the objective function is minimized 
[optimalTheta, minSquaredDistanceSum] = fminbnd(func, 0, pi);

% Visualize optimal path and points
figure;
hold on;
plot(points(:, 1), points(:, 2), "*", "LineWidth", 2);
plot(origin(1), origin(2), "ro", "LineWidth", 3)

% plot optimal path line
factor = 0.2;
numSamples = 10;
maxR = max(sqrt((points(:, 1) - origin(1)).^2 + (points(:, 2) - origin(2)).^2));
r = linspace(0, (1 + factor) * maxR, numSamples);
xr = origin(1) + r .* cos(optimalTheta);
xl = origin(1) - r .* cos(optimalTheta);
yu = origin(2) + r .* sin(optimalTheta);
yd = origin(2) - r .* sin(optimalTheta);

plot([xl, xr], [yd, yu], "k-", "LineWidth", 1);
text(origin(1) + 0.1, origin(2) - 0.1, "Origin");
hold off;
grid on;
axis equal;
title("Optimal path and theta")
xlabel(sprintf("Optimal theta = %f/radian", optimalTheta));