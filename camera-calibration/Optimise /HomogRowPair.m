function [Regressor, DataVec] = HomogRowPair(Correspond)
%HomogRowPair
% HomogRowPair generates 2 rows of the 8 column matrix
% that multiplies the unknown vector of homography element
% to get the vector of measurements .
% Where Correspond = [[u v]';[x y]'] = [ u v x y]'
u =  Correspond(1,1);
v =  Correspond(2,1);
x =  Correspond(3,1);
y =  Correspond(4,1);

Regressor = [x y 1 0 0 0 -u*x -u*y;
             0 0 0 x y 1 -v*x -v*y];
         
DataVec = [u,v];

% 
% 
% % Find out the number or points there is in ModifiedCorrespond
% s = length(ModifiedCorrespond);             
% 
% % Now define the operation
% % RowPairMatrix = {[x] [y] 1  0   0  0 -u*x -u*y;
% %                   0   0  0 [x] [y] 1 -v*x -v*y};
% 
% % RowPairMatrix = { [ x1 x2 ... xn^2] [y1 y2...yn^2]    [1] ...
% %                   [ 0  0  ... 0   ] [0  0 ...0   ]    [0] ...}
% 
% % Assign space for the matrix
% A = zeros(2, 6*s+2);
% 
% % Then extract the u,v,x,y vectors from the input
% u = ModifiedCorrespond(1,s/2);
% v = ModifiedCorrespond(2,s/2);
% x = ModifiedCorrespond(1,s/2:s);
% y = ModifiedCorrespond(2,s/2:s);
%     
% % Entering in all the values...
% for j= 1:s/2
%     A(:,j)   = [x(j);0];
%     A(:,j+1) = [y(j);0];
%     A(:,j+2) = [1;0];
%     A(:,j+3) = [0;x(j)];
%     A(:,j+4) = [0;y(j)];
%     A(:,j+5) = [0;1];
%     A(:,j+6) = [-u(j)*x(j);-v(j)*x(j)];
%     A(:,j+7) = [-u(j)*y(j);-v(j)*y(j)];
% end
% 
% % Finally, return result as output
% RowPairMatrix = A;
% 
% %%%%%
% 
% % If suppose now RowPairMatrix, A = [h1 h2 ... hs]
% % where   h  = { x   y  1  0   0  0 -u*x -u*y;
% %                0   0  0  x   y  1 -v*x -v*y};
% 
% A = zeros(2,s);
% % Then extract the u,v,x,y vectors from the input
% u = ModifiedCorrespond(1,s/2);
% v = ModifiedCorrespond(2,s/2);
% x = ModifiedCorrespond(1,s/2:s);
% y = ModifiedCorrespond(2,s/2:s);
% 
% % Entering in all the values...
% for j= 1:s/2  
%     A(:,j)  = [ x(j)   y(j)  1  0      0     0 -u(j)*x(j) -u(j)*y(j);
%                 0      0     0  x(j)   y(j)  1 -v(j)*x(j) -v(j)*y(j)];
% end
% 
% RowPairMatrix = A;
% 
