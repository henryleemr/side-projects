function [T_ow] = PositionGrid()
%PositionGrid.m
% Defines a 4x4 homogenous transformation that places an object in space at
% a random locaiton in world coordinates and at a random orientation.
% Defines an `object frame' as tested in a previous task above.T_ow
% means T:O->W, i.e. the transformation of Points in object coordinates
% into Points in World coordinates.

T_ow = zeros(4,4);

% The bottom row is [0 0 0 1]
T_ow(4,:) = [0 0 0 1];

% Put at some random location
T_ow(1:3,4) = 2000*rand(3,1);

% With a random orientation
T_ow(1:3,1:3) = RandomRotationMatrix;

end
