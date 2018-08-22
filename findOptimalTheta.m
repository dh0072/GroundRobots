function [theta, s] = findOptimalTheta(home, points)
%Find the optimal and second optimal theta which minimizes the sum of 
% squared distance of each point to candidate path
theta1 = 0;
theta2 = 0;
s1 = 0;
s2 = 0;

thetaStep = 1 * pi / 180;
theta = (0:thetaStep:2 * pi).';

verticalTheta1 = find(abs(theta - pi / 2) < 1e-6);
verticalTheta2 = find(abs(theta - 3 * pi / 2) < 1e-6);

a = tan(theta);
b = -1 .* ones(size(a, 1), 1);
c = home(2) - tan(theta) .* home(1);

% Special handling for vertical line (pi/2 and 3*pi/2)
a([verticalTheta1; verticalTheta2]) = 1;
b([verticalTheta1; verticalTheta2]) = 0;
c([verticalTheta1; verticalTheta2]) = -home(1);

s = sum((abs(a .* points(:, 1).' + b .* points(:, 2).' + c) ./ sqrt(a .^ 2 + b .^ 2)) .^ 2, 2);

% Sort and find first minimum and second minimum values of s
thetaSum = [theta, s];
sortedthetaSum = sortrows(thetaSum, 2);

% Return first and second minimum s and their corresponding theta values
if size(sortedthetaSum, 1) > 0
    theta1 = sortedthetaSum(1, 1);
    s1 = sortedthetaSum(1, 2);
end

if size(sortedthetaSum, 1) > 1
    theta2 = sortedthetaSum(2, 1);
    s2 = sortedthetaSum(2, 2);
end

% Keep theta that has the minimal distance from last point to path 
% (whose angle is theta1 and theta2 respectively)
lastPoint2HomeTheta = atan2(points(end, 2) - home(2), points(end, 1) - home(1));
if points(end, 2) - home(2) < 0
    lastPoint2HomeTheta = lastPoint2HomeTheta + 2 * pi;
end

if abs(lastPoint2HomeTheta - theta1) < abs(lastPoint2HomeTheta - theta2)
    theta = theta1;
    s = s1;
else
    theta = theta2;
    s = s2;
end

end

