function [optimalPathPoints, criticalIndices] = generateOptimalPathPoints(points, maxStep)
%GENERATEOPTIMALPATHPOINTS Generate points on the optimal path
% param points: a vector of points that are fed into optimization function
% param maxStep: the max distance that robot can move in one step
% param optimalPathPoints: a vector of points that are on the optimal path

% Assumption 1: maxStep >= distance between two neighboring points for a
% certain group of poitns
% Assumption 2: the robot is placed at the first point, i.e. points(1, :)
% Assumption 3: cirtialDistance is the the critical distance to identify a
% new group of points
% Assumption 4: the robot moves maxStep for each step

numPoints = size(points, 1);
home = points(1, :);  % Assumption 2
criticalDistance = maxStep;  % Assumption 3

% Points that robot can reach within 1 step
reachablePoints = ones(numPoints, 2);
optimalPathPoints = ones(numPoints, 2) .* home;  

optimalPathPointIndex = 2;  % first optimal path point is at home
firstReachablePointIndex = 1;  % first reachable point index within 1 step
lastReachablePointIndex = 1; % last reachable point index within 1 step
criticalIndex = 1;  % index of first point of current group of points
criticalIndices = zeros(numPoints, 1);
isLastPointInGroup = 0;
groupIndex = 1;
i = 1;

figure;
axis equal;
grid on;
hold on;

while i <= numPoints
    distanceBetweenCurrentPoinAndHome = sqrt((points(i, 1) - home(1))^2 + (points(i, 2) - home(2))^2);

    if i < numPoints
        distanceBetweenNextPointAndCurrentPoint = sqrt((points(i + 1, 1) - points(i, 1)) ^ 2 + (points(i + 1, 2) - points(i, 2)) ^ 2);
    end
    
    % If it is the last point in current group of points, plot current
    % group of points
    if (distanceBetweenNextPointAndCurrentPoint > criticalDistance) || i == numPoints
        if i ~= criticalIndex - 1
            h = plot(points(criticalIndex:i, 1), points(criticalIndex:i, 2), '-ob');
            criticalIndex = i + 1;
        end
        isLastPointInGroup = 1;
        % Update criticalIndices for plotting optimalPathPoints
        criticalIndices(groupIndex) = optimalPathPointIndex;
        groupIndex = groupIndex + 1;
    end

    % If current point is reachable within 1 step, add it to reachablePoints
    if distanceBetweenCurrentPoinAndHome <= maxStep || distanceBetweenCurrentPoinAndHome - maxStep < 1e-6
        reachablePoints(i, :) = points(i, :);
        lastReachablePointIndex = i;
        i = i + 1;
    end

    % If current point is out of range that robot can reach within 1 step
    if distanceBetweenCurrentPoinAndHome > maxStep || (distanceBetweenCurrentPoinAndHome <= maxStep && isLastPointInGroup == 1)
        % If robot cannot reach any points at current location, move it to
        % the last reachable point
        if lastReachablePointIndex < firstReachablePointIndex
            currentReachablePoints = points(firstReachablePointIndex, :);
        else
            currentReachablePoints = reachablePoints(firstReachablePointIndex:lastReachablePointIndex, :);
        end

        % Calculate (optimal) theta
        [theta, ~] = findOptimalTheta(home, currentReachablePoints);
        
        % theta = 0 or pi is dependent on the direction in which the robot
        % is moving
        if abs(theta - pi) < 1e-6 && currentReachablePoints(end, 1) > home(1)
            theta = pi - theta;
        end

        % Calculate the next point that robot should go to
        pathLen = maxStep;  % Assumption 3
        home(1) = home(1) + pathLen * cos(theta);
        home(2) = home(2) + pathLen * sin(theta);

        % Save this point to pathPoints, which can be plotted latter
        optimalPathPoints(optimalPathPointIndex, :) = home;
        optimalPathPointIndex = optimalPathPointIndex + 1;

        % Special handling for last point in current group, i -> first
        % point in next group. If all points in current group have been
        % reached, then move robot to the first point of next group
        if isLastPointInGroup == 1 && lastReachablePointIndex == criticalIndex - 1
            % Move robot to the first point in the next group
            if i < numPoints
                firstReachablePointIndex = criticalIndex; 
                home = points(criticalIndex, :);
                optimalPathPoints(optimalPathPointIndex, :) = home;
                optimalPathPointIndex = optimalPathPointIndex + 1;
            end
            isLastPointInGroup = 0;
        else
            firstReachablePointIndex = i;
        end
    end
end

optimalPathPoints = optimalPathPoints(1:optimalPathPointIndex - 1, :);
g = plot(optimalPathPoints(:, 1), optimalPathPoints(:, 2), 'xr');
hold off;
lgd = legend([h, g], "Input points", "Optimal path points");
lgd.FontSize = 14;
xlabel("X axis (m)", "FontSize", 16);
ylabel("Y axis (m)", "FontSize", 16);
title("Input points and optimal path points", "FontSize", 16);


% Uncomment to plot optionalPathPoints (before transformation & rotation)
% figure;
% axis equal;
% grid on;
% hold on;
% drawOptimalPathPoints(optimalPathPoints);
% hold off;

end
