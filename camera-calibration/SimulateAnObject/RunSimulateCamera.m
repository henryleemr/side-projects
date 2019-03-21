% Simulates viewing a 3D object (a cube) to demonstrate the structures
% built up to calibarate a camera.

% Construct a Camera
% Modified from [KMatrix, CameraHeight, CameraWidth] = BuildCamera;
p = BuildCamera;

% Construct an object in its own frame
Cube = BuildCube;

% Position the object in space
T_ow = PositionObject;

% Position the camera so that it is likely that the object can be seen 
T_cw = PositionCamera(T_ow);

% Look at what we have
ViewCamera(Cube,T_ow,p,T_cw)

