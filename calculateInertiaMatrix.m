function [inertiaMatrix, eigenValue, eigenVector, xBar, yBar] = calculateInertiaMatrix(points)
% This function is to calculate xBar, yBar, Ixx, Iyy and Ixy
%   It would return a matrix including Ixx, Iyy and Ixy

numPoints = size(points, 1);
x = points(:, 1);
y = points(:, 2);

xBar = sum(x) / numPoints;
yBar = sum(y) / numPoints;

Ixx = sum((x - xBar) .^ 2) ./ numPoints;
Iyy = sum((y - yBar) .^ 2) ./ numPoints;
Ixy = -sum((x - xBar) .* (y - yBar)) ./ numPoints;

inertiaMatrix = [Ixx, Ixy; Ixy, Iyy];
eigenValue = eig(inertiaMatrix);
[eigenVector, ~] = eig(inertiaMatrix);

end