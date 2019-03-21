function [Cube] = BuildCube ()

%BuildCube
% Defines the vertices of the cube by returning 8 coordinates corresponding
% to the 8 vertices of the cube
% This returns 4x2n where n=12 matrix because n is the number of lines in
% the cube

% Define length of cube to be 1m, hence 1000mm
SideLength = 1000;
x = SideLength;

% Define the coordinates of the vertices of the cube
V1 = [0 0 0 1]';
V2 = [x 0 0 1]';
V3 = [x x 0 1]';
V4 = [0 x 0 1]';
V5 = [0 0 x 1]';
V6 = [x 0 x 1]';
V7 = [x x x 1]';
V8 = [0 x x 1]';


% Draw the lines of the cube, for vertex V1, starting from point V1 to V2, 
% then V1 to V5, V1 to V4 and so on for the other vertices
Cube = [V1 V2 V1 V5 V1 V4 V2 V3 V2 V6 V3 V7 V3 V4 V4 V8 V5 V6 V5 V8 V6 V7 V7 V8];

% Check sizes
s = size(Cube);                                                
if s(1) ~=4 || s(2) ~= 24
    error('Cube has an invalid size, must be a 4x24 matrix')
end

