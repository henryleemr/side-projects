function [Correspond, TruncatedCorrespond] = BuildNoisyCorrespondences(Correspondences,n,CameraHeight,CameraWidth, CameraScale)
%BuildNoisyCorrespondences

% Fill the camera with a noisy image of the grid and generate
% the point correpondences.
% Check sizes
s = size(Correspondences);                                                
if s(1) ~=4 || s(2) ~=n
    error('Correspondences has an invalid size')
end

%%
% Add noise in the Correspondences 
Noise = normrnd(0,3,s);
% Noise = Noise * sqrt(1*CameraScale*0.5);
Correspond = Correspondences + Noise;

% % Add Gaussian noise to image points (variance = 0.5 of pixel value)
% RandomNoise = randn(4,s(2));
% % RandomNoise = RandomNoise * sqrt(1*CameraScale*0.5);
% RandomNoise(3:4, :) = 0;
% Correspondences = Correspondences + RandomNoise;

%% Truncation
% Then filter out the coordinates 2 x 2n^2 = 2 x (2*101^2) matrix that are not within the viewing range of
% the camera, add noise before filtering so that the noise does not put the
% points outside the originally defined image range
A = Correspond;
% All u,v cannot be less than 0 and % All u must be less than CameraWith-1 and v less than CameraHeight-1
points = 0;
for j=1:n
   if A(1,j)>=0 && A(2,j)>=0 && A(1,j)<=CameraWidth-1 && A(2,j)<=CameraHeight-1
       points = points+1;
       FilteredCorrespondence(:,points) = A(:,j);
   end
end
TruncatedCorrespond = FilteredCorrespondence(:,1:points);

%%
% 
% % Set all points u,v,x,y outside the range to equal [0:0]
% for j = 1:s(2)
%     % All u,v,x,y cannot be less than 0
%     if A(1,j) <= 0 | A(2,j) <= 0   
%         A(:,j) = [0;0];
%     end
%     
%     % All u,x must be less than CameraWith-1 and v,y less than CameraHeight-1
%     if A(1,j)>=CameraWidth-1 | A(2,j)>=CameraHeight-1
%         A(:,j)=[0;0];
%     end
% end
% plot( A(1 ,:) ,A(2 ,:) ,'.')
% axis ij
% 
% % Finally, return the noisy, filtered Correspondences as Correspondence in
% % output
% Correspondence = A;

    
% Alternative noise functions:
% OR add Gaussian white noise of mean 0 and variance 3 to the A.
% A = imnoise(A,'gaussian',0,3) ;

% OR add noise to the Correspondences matrix
% SampleSize = 2*2*n^2;    %number of elements in Correspondences
% Variance = ( sum(sum(A,1))-0)^2 /SampleSize;
% StandardDev = 10;
% Variance = StandardDev^2;
% Factor = 10;
% NoiseAddition = Factor*randn(size(A));
% 
% while NoiseAddition >= Variance 
%     Factor = Factor - 0.1;
%     
%         while Factor >0
%               Factor = Factor;
%         end
%         
%     NoiseAddition = Factor*randn(size(A));
% end
% 
% A = A + Factor*randn(size(A));


% OR logical indexing:
% Check that u, v values are within the viewing range, if not then set to 0
% To do this, create a logical array B that satisfies the condition of the elements in A
% having points within the camera view and uses the positions of ones in B to index into A
% B = (0 <= A <= CameraWidth - 1) & (0 <= A <= CameraHeight - 1);
% A(B) = 0;
% Note that Correspondences= [[u v]' [x y]'] = [(u1 u1 ... un^2) (x1 x2... xn^2)   
%                                                (v1 v2 ... vn^2) (y1 y2...yn^2)]

% % Want to remove all the elements u, v smaller than 0, hence set those elements to
% % logical 1s and then correspondingly to equal zero
% B   = A(:,n^2)<= 0; % i.e. sweep u, when u is out of range,
% A(B)= 0;                % then set the element to zero value
% plot( A(1 ,:) ,A(2 ,:) ,'.')
% axis ij
% 
% % Repeat logical indexing step for u, expressed more simply...
% A( A(1,n^2)>=CameraWidth-1 )= 0;
% plot( A(1 ,:) ,A(2 ,:) ,'.')
% axis ij
% 
% % Repeat logical indexing step for v...
% A( A(2,n^2)>=CameraHeight-1)= 0;
% plot( A(1 ,:) ,A(2 ,:) ,'.')
% axis ij

% % Repeat for x and y...                     %Need to filter out x and y too? if so what range??
% A( A(:,n^2:2*n^2)<= 0 )= 0;
% plot( A(1 ,:) ,A(2 ,:) ,'.')
% axis ij
% 
% A( A(:,n^2:2*n^2)>=GridWidth )= 0;
% % Alternatively, instead of GridWidth, can use max(CalibrationGrid(:)) which is
% % 1000 
% plot( A(1 ,:) ,A(2 ,:) ,'.')
% axis ij

