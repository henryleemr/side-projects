function [Correspondences, CameraWidth, CameraHeight] = BuildCorrespondences (T_ow ,T_cw , CalibrationGrid , ...
 KMatrix , CameraHeight , CameraWidth )
%BuildCorrespondences

% Tranforms the object (grid) coordinates from object to camera sensor
% coordinates

%ViewCamera
% Takes an object described by a set of lines passed in CalibrationGrid 
% and draws a picture of the camera's view of the object.
%
% CalibrationGrid is 4x2n (n = 8 for a cube) where each column is a homogenous Point in 
% the objects frame. The object is defined as pairs of Points that 
% should have a line drawn between them.
% T_ow is a 4x4 homogenous transformation matrix describing the
% object's frame.
% KMatrix is the K-Matrix of the camera in pixels.
% CameraHeight is the number of vertical pixels.
% CameraWidth is the number of horizontal pixels/
% T_cw is the 4x4 Camera frame in world coordinates.

% Check sizes
s = size(CalibrationGrid);
if s(1) ~=4 || mod(s(2)+1 ,2) ~= 0             % -Changed s(2) to s(2) + 1 . Checks if the dimensions are correct, and if the column dimension is an odd number
    error('Calibration grid has an invalid size') % s(1) means the row dimension of s
end

s = size(T_ow);                                                
if s(1) ~=4 || s(2) ~= 4
    error('T_ow has an invalid size')
end

s = size(KMatrix);
if s(1) ~=3 || s(2) ~= 3
    error('KMatrix has an invalid size')
end

s = size(T_ow);                                 %Should changed from T_ow to T_oc? But there is no need for T_oc here think it is an error
if s(1) ~=4 || s(2) ~= 4
    error('T_oc has an invalid size')
end

% Now construct the u,v points in camera sensor frame where 
% CameraPoints = [[u v]'] 
CameraPoints = CalibrationGrid;

% Transform the object into world coordinates
CameraPoints = T_ow*CalibrationGrid;                     % -Changed all ObjectLines into CalibrationGrid

% Transform the object into camera coordinates using the backslash
% operator to indicate inv
CameraPoints = T_cw\CameraPoints;

% Project (extract) out the 4th coordinate and multiply by the KMatrix
CameraPoints = KMatrix * CameraPoints(1:3,:);                        

% We now have a set of homogenous Points representing 2D points.
% We need to normalise these Points to get 2D points.
% Note that 1:s(2) produces a series of integers starting from 1 up till
% the first element in row 2 of the s matrix, hence j is a series of
% integers
% Also note that size(A) gives the (row columns) i.e. dimensions of the
% matrix A, and length(A) is max[size(A)] i.e. i.e. the largest dimension
% of the matrix
s = size(CameraPoints);
for j = 1:s(2) 
    % for each column vector of CalibrationGrid i.e. each vector of the
    % grid
        CameraPoints(1:2,j) = CameraPoints(1:2,j) / CameraPoints(3,j);     
end

% Throw away the normalising components i.e. the z and p components in the
% vectors, we now have the x, y points transformed into the camera
% coordinates , i.e. the u, v points 
CameraPoints = CameraPoints(1:2,:);

% Also throw away the normalising components i.e. the z and p components in the
% vectors in object coordinates x, y to get CalibrationGrid = [[x y]']
CalibrationGrid = CalibrationGrid(1:2,:);

% Now construct the Correspondences of the form [[u v]'; [x y]']
Correspondences = [CameraPoints; CalibrationGrid];

% % Test to see if results are visually reasonable
%  figure (1)
%  plot( Correspondences (1 ,:) ,Correspondences (2 ,:) ,'.')
%  title('The noisy measurements of the tile corners ')
%  axis ij

end                                                                     %is this needed?


