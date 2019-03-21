
% SingleVectorCameraModel
Parameters = [2000; 2500; 100; 0.001; 0.001; 0; 0.25; 0.25];
 
% RodriguesRotation
R = RandomRotationMatrix;
[U,W,V] = eig(R);
RotationAxis = U(:,1);
RotationAngle = 12*pi/27;
 
% PositionCamera
T_ow = PositionObject();
 
% ViewCamera
T_cw = PositionCamera(T_ow);
KMatrix = SingleVectorCameraModel(Parameters);
CameraHeight = Parameters(2);
CameraWidth = Parameters(1);
a = [0;0;0;1]; 
b = [0;0;1;1];
c = [0;1;1;1];
d = [0;1;0;1];
e = [1;0;0;1]; 
f = [1;0;1;1];
g = [1;1;1;1];
h = [1;1;0;1];
 
Cube = 1000 *[a,b,b,c,c,d,d,a ...
                     e,f,f,g,g,h,h,e ...
                     d,h,c,g,a,e,b,f];
                 
%function [objectLines]
% Define ObjectLines, which is a 4x16 matrix
% ObjectLines = zeros(4,16);
% ObjectLines(:,1) = [0 0 0 0]';
% ObjectLines(:,2) = [0 0 0 1]'; 
% ObjectLines(:,3) = [0 0 1 0]';
% ObjectLines(:,4) = [0 0 1 1]'; 
% ObjectLines(:,5) = [0 1 0 0]'; 
% ObjectLines(:,6) = [0 1 0 1]';
% ObjectLines(:,7) = [0 1 1 0]';
% ObjectLines(:,8) = [0 1 1 1]';
% ObjectLines(:,9) = [1 0 0 0]';
% ObjectLines(:,10) = [1 0 0 1]';
% ObjectLines(:,11) = [1 0 1 0]';
% ObjectLines(:,12) = [1 0 1 1]';
% ObjectLines(:,13) = [1 1 0 0]';
% ObjectLines(:,14) = [1 1 0 1]';
% ObjectLines(:,15) = [1 1 1 0]';
% ObjectLines(:,15) = [1 1 1 1]';
