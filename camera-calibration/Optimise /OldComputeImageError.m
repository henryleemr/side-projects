function [ErrorVector] = ComputeImageErrors(KMatrix,Angle,...
    Translation,Correspond,Consensus)
%ComputeImageErrors
% Computes the coordinates of the u,v points based on the estimated KMatrix
% then compares this coordinates with the actual coordinates to find an
% error

% What is the use of consensus vector?

% Write a code to check the size of the matrices
% KMatrix is a 3x3 matrix
% Angle is a 3x1 matrix describing the rotation matrix as a shifted
% angle axis
% Translation is a 3x1 matrix
% Correspond is a 4x4 matrix
% Consensus is a 1x4 matrix

% Extract rotation information from shifted angle-axis representation.
NormAxis = norm(Angle);
Theta = NormAxis - 4*pi;
RotAxis = Angle/NormAxis;

% Reconstruct the rotation matrix used in the transformation matrix to
% convert Points in the object coordinate to Points in the unit camera
% coordinates.
RotMatrix = RodriguesRotation(RotAxis,Theta);

% New: Only allow data in the consensus set to be used.
s = size(Correspond);
PassCorrespond = zeros(s(1),length(Consensus));

for n = 1:length(Consensus)
    j = Consensus(n);
    if j ~= 0 
    PassCorrespond(:,n) = Correspond(:,j);
    end
end


% 1. Predict the positions of the points in the image using the
%transformation matrices and the current best camera K-matrix.
PredictedImagePositions = KMatrix*[RotMatrix(:,1:2) Translation]*...
    [PassCorrespond(3:4,:);ones(1,length(PassCorrespond))];

% Normalize the PredictedImagePositions by the scale
for i =1:length(PredictedImagePositions)
    PredictedImagePositions(1:2,i) = PredictedImagePositions(1:2,i)/ ...
        PredictedImagePositions(3,i);
end

% 2. Subtract the positions of the actual image positions from the
% predicted image positions to generate a set of image errors in pixels.
ErrorVector = PredictedImagePositions(1:2,:) - PassCorrespond(1:2,:);

end

