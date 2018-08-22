function transformedOptimalPathPoints = transformAndRotate(optimalPathPoints, points)
%TRANSFORMANDROTATE Translation & rotation
[~, ~, eigenVector, xBar, yBar] = calculateInertiaMatrix(points);
if eigenVector(1, 1) < 0
    eigenVector = eigenVector .* -1;
end

optimalPathPointsDummy = optimalPathPoints - [xBar, yBar];
rotationMatrix = [eigenVector(1, 2), -eigenVector(1, 1); eigenVector(1, 1), eigenVector(1, 2)];
transformedOptimalPathPoints = optimalPathPointsDummy * rotationMatrix;
end

