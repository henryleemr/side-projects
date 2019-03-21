function [T_cw] = PositionCamera(T_ow)
%PositionCamera
% Generates a 'random' camera frame that has a good chance of the object
% being visible in the camera when the object is a 1m cube
%
% Input T_ow is the 4x4 object frame in world coordinates 
% T_cw is the 4x4 camera frame in world coordinates. 

% Assign space for the camera frame
T_cw = zeros(4);

% Set the homogenous multiplier to 1
T_cw(4,4) = 1;

% extract the object origin (position of the new coordinates wrt the origin you want to transform INTO
% i.e. in this case, wrt world origin)
ObjectOrigin = T_ow(1:3,4);

% View the camera from about 10 metres or so (unrelated to the object
% frame)                                                                ?? this would be the object position perhaps??
InitialViewVector = 10000*rand(3,1);                                    %can use 20000 which gives better results

% Define the origin of the camera frame in world coordinates
T_cw(1:3,4) = ObjectOrigin - InitialViewVector;                        %how to visualize physically?

% Define the camera z-axis as pointing at the camera origin
Normz = norm(InitialViewVector);                                       %how to visualize physically?
if Normz < eps
    error('Unable to normalize the caemra z-axis');
end
% Define a unit vector
InitialCameraz = InitialViewVector / Normz;

% Perturb the inital z axis a bit
CameraZ = InitialCameraz - 0.01*rand(3,1);                             %reason for perturbing?

% ...and normalize again (no need to check norm)
CameraZ = CameraZ / norm(CameraZ);

% Define a random camera x-axis
CameraX = rand(3,1);
% project out the z-axis
CameraX = CameraX - (CameraZ'*CameraX)*CameraZ;
% normalize the x-axis
Normx = norm(CameraX);
if Normz < eps
    error('Unable to normalize the camera x-axis')
end
CameraX = CameraX/Normx;

% Define the y-axis
CameraY = cross(CameraZ, CameraX);

% Complete the transformation matrix
T_cw(1:3,1:3) = [CameraX CameraY CameraZ];

end



