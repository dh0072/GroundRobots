function drawOptimalPathPoints(optimalPathPoints)
%DRAWOPTIMALPATHPOINTS draw with quiver
%   Draw optimalPathPoints with quiver. Notes: call drawOptimalPath for 3 times
%   arrowVec1 = [1, 2, 3, 4]  ==> [1, 1, 1, -3]
%   arrowVec2 = [2, 3, 4, 1]
%   arrowVec = arrowVec2 - arrowVec1 = [1, 1, 1, -3]

arrowVec = optimalPathPoints(2:end, :) - optimalPathPoints(1:end - 1, :);
quiver(optimalPathPoints(1:end - 1, 1), optimalPathPoints(1:end - 1, 2), arrowVec(:, 1), arrowVec(:, 2), 0, '-b', 'LineWidth', 1, 'MaxHeadSize', 0.2);

end
