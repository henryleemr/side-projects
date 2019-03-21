function [CalibrationGrid] = BuildGrid (GridIncrement, GridWidth)
%Buildgrid
% Returns a list of points that correspond to the corners of a grid

 GridWidth = 1000;
 GridIncrement = 10;

% Define n as the number of points corresponding to each point in grid
n = GridWidth / GridIncrement +1; 

% Assign space for the matrix A, where A's leftmost vector is the
% bottom left point of grid corresponding to vector (0 0 0 1)'
A = zeros(4, n^2);

for j = 0:(n-1)
    % j represents the jth set of vectors, {Rj}, corresponding to the jth set of
    % horizontal points in the grid.
    % Start constructing from the bottom-most row of the grid as j = 0.
    
    for i = 0:(n-1)
        % i represents the ith vector within the vector set {Rj},
        % constructing each vector from left(i=0) to right consecutively.
        
        % Assign each element one by one in each vector    
        A(1,n*j+i+1) = i*GridIncrement;
        A(2,n*j+i+1) = j*GridIncrement;   
        A(3,n*j+i+1) = 0;
        A(4,n*j+i+1) = 1;
    end
end
    
% Transpose origin (0,0,0,1) to (GridWidth/2, GridWidth/2,0,0)
A(1,:) = A(1,:) - GridWidth/2;
A(2,:) = A(2,:) - GridWidth/2;

% Set CalibrationGrid matrix output to be A, where A is in the format of     
% A = [{R0} {R1} {R2} ... {Rn-1}]
CalibrationGrid = A;




