function [KMatJacob,FrameJacob] = SingleImageJacobian(KMatrix,Angle,...
    Translation,Correspond,Consensus)
%% Description
% SingleImageJacobian
% Computes the Jacobian of the KMatrix and FrameParameters by pertubing
% the elements one by one in turn.

%% Section 1: Initialise KMatJacob
% Pertubations:
KMatPertubationSize = 0.001; % Units: Pixels
FrameAnglePertubationSize = 0.1; % Units: Rad
FrameTransPertubationSize = 0.001;

% Compute the original error
OriginalErrorVector = ComputeImageErrors(KMatrix,Angle,...
    Translation,Correspond,Consensus);

% Constructing KMatJacob
% Pertub the elements in the K-Matrix one by one and recompute the
% NewPredictedImagePosiitons. Then, compute the forward derivative by
% dividing the difference between NewPredictedImagePositions and
% PredictedImagePositions by the PertubationSize.

% KMatPertubationSize = 0.001; % Units: Pixels
PertubedKMatrix = KMatrix;
KMatJacob = zeros(2,5);
KMatPositionCounter = 1;
s = size(KMatrix); % s = [3,3]
%% Section 2: Perturb KMatrix and Angle and store jacobians of KMatrix into KMatrixJacob
for i = 1:s(1)-1 % fix the row first, only take the first two rows
    for j = 1:s(2) % work across columns, the elements of that row
        if i == 2 && j == 1
            
        else
            ElementToBePertubed = KMatrix(i,j);
            PertubedElement = ElementToBePertubed + KMatPertubationSize;
            PertubedKMatrix(i,j) = PertubedElement;
            
            % Compute the PertubedErrorVector
            PertubedErrorVector = ComputeImageErrors(PertubedKMatrix,Angle,...
                Translation,Correspond,Consensus);
            
            % Compute the forward derivative
            ForwardDerivative_u = (PertubedErrorVector(1) ...
                - OriginalErrorVector(1)) / KMatPertubationSize;
            ForwardDerivative_v = (PertubedErrorVector(2) ...
                - OriginalErrorVector(2)) / KMatPertubationSize;
            
            % Store the derivatives in KMatJacob
            KMatJacob(1,KMatPositionCounter) = ForwardDerivative_u;
            KMatJacob(2,KMatPositionCounter) = ForwardDerivative_v;
            
            % Increment the position counter
            KMatPositionCounter = KMatPositionCounter + 1;
        end
    end
end
% Constructing FrameJacob
% Pertube the frame parameters one by one and recompute the
% NewPredictedImagePosiitons. Then, compute the forward derivative by
% dividing the difference between NewPredictedImagePositions and
% PredictedImagePositions by the PertubationSize.

% In my code, I have subdivided the frame parameters into two sections, the
% first 3 from Angle, and the last 3 terms are from the translation term

% Construct the Jacobian of the Frame Angles
% FrameAnglePertubationSize = 0.01; % Units: Rad
PertubedFrameAngle = Angle;
FrameAngleJacob = zeros(2,3);
FrameAnglePositionCounter = 1;

for j = 1:length(Angle) %length(Angle) is 3 since angle is the rotaxis
    ElementToBePertubed = Angle(j);
    PertubedElement = ElementToBePertubed + FrameAnglePertubationSize;
    PertubedFrameAngle(j) = PertubedElement;
    
    % Compute the PertubedErrorVector
    PertubedErrorVector = ComputeImageErrors(KMatrix,PertubedFrameAngle,...
        Translation,Correspond,Consensus);
    
    % Compute the forward derivative
    ForwardDerivative_u = (PertubedErrorVector(1) ...
        - OriginalErrorVector(1)) / FrameAnglePertubationSize;
    ForwardDerivative_v = (PertubedErrorVector(2) ...
        - OriginalErrorVector(2)) / FrameAnglePertubationSize;
    
    % Store the derivatives in FrameAngleJacob
    FrameAngleJacob(1,FrameAnglePositionCounter) = ForwardDerivative_u;
    FrameAngleJacob(2,FrameAnglePositionCounter) = ForwardDerivative_v;
    
    % Increment the position counter
    FrameAnglePositionCounter = FrameAnglePositionCounter + 1;
end
%% Section 4: Perturb and Compute FrameTransJacob
% Compute the Jacobian of the FrameTransJacob
% FrameTransPertubationSize = 0.02; % Units: Scaled units becasue gridspacing = 10, 10/500= 0.02 hence in the scaled image 0.02 is the minimum error
PertubedFrameTrans = Translation;
FrameTransJacob = zeros(2,3);
FrameTransPositionCounter = 1;

for j = 1:length(Translation)
    ElementToBePertubed = Translation(j);
    PertubedElement = ElementToBePertubed + FrameTransPertubationSize;
    PertubedFrameTrans(j) = PertubedElement;
    
    % Compute the PertubedErrorVector
    PertubedErrorVector = ComputeImageErrors(KMatrix,Angle,...
        PertubedFrameTrans,Correspond,Consensus);
    
    % Compute the forward derivative
    ForwardDerivative_u = (PertubedErrorVector(1) ...
        - OriginalErrorVector(1)) / FrameTransPertubationSize;
    ForwardDerivative_v = (PertubedErrorVector(2) ...
        - OriginalErrorVector(2)) / FrameTransPertubationSize;
    
    % Store the derivatives in FrameTransJacob
    FrameTransJacob(1,FrameTransPositionCounter) = ForwardDerivative_u;
    FrameTransJacob(2,FrameTransPositionCounter) = ForwardDerivative_v;
    
    % Increment the position counter
    FrameTransPositionCounter = FrameTransPositionCounter + 1;
    
end


FrameJacob = [FrameAngleJacob FrameTransJacob];

end



