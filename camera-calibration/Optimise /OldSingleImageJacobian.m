function [KMatJacob,FrameJacob] = SingleImageJacobian(KMatrix,Angle,...
    Translation,Correspond,Consensus)

% Add SimpleTestRange to ensure values are not out of range


% New: Only allow data in the consensus set to be used.
s = size(Correspond);
PassCorrespond = zeros(s(1),length(Consensus));

for n = 1:length(Consensus)
    j = Consensus(n);
    if j ~= 0 
    PassCorrespond(:,n) = Correspond(:,j);
    end
end

% Compute the forward difference of the parameters of the KMatrix.
PertubedKMatrix = KMatrix;
KMatJacob = zeros(1,5);
PertubationSize = 0.05; % Units:pixels
n = 1;

for i = 1:2
    for j = 1:3
        if i ~= 1 && j ~= 1
            PertubedKMatrix(i,j) = KMatrix(i,j) + PertubationSize;
            KMatJacob(n) = (PertubedKMatrix(i,j) - KMatrix(i,j))/PertubationSize;
            n = n+1;
        end
    end
end

% Compute the forward difference of the Frame Parameters.
FrameJacob = zeros(1,6);
PertubedAngleSize = 0.05; % in rad
PertubedAngle = Angle;
PertubedTranslationSize = 2; % in mm
PertubedTranslation = Translation;

for k = 1:3
    PertubedAngle(k) = Angle(k) + PertubedAngleSize;
    FrameJacob(k) = (PertubedAngle(k)-Angle(k))/PertubedAngleSize;
    PertubedTranslation(k) = Translation(k) + PertubedTranslationSize;
    FrameJacob(k+3) = (PertubedTranslation(k) - Translation(k))/PertubedTranslationSize;
end

end
    
   




