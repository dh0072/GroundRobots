close all;  % close all matlab windows
clc;  % clear command window
clear;  % clear workspace variables 
close all;

% The following section is for test purpose
origin = [1, 1];
startPosition = [6, 1];
d_between_two_points = 1.5;
radius = 5;


[points, angle] = computePointsCoordinatesAndAngle(origin, startPosition, d_between_two_points, radius);

figure;
hold on;
plot(points(:, 1), points(:, 2), "r*");
plot(origin(1), origin(2), "bo");
hold off;
grid on;
axis equal;
title("Points visualization");

figure;
plot(angle);
grid on;
xlabel("Point index");
ylabel("Angle to next point/radian");