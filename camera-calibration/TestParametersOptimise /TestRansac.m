
 % The number of calibration images to use
 nImages = 6;

%% Camera model
% 1. Construct the Camera model
p = BuildCamera ;
KMatrix = p.KMatrix;
CameraHeight = p.CameraHeight;
CameraWidth = p.CameraWidth;

%% Grid construction
% 2. Construct a 1m by 1m grid with 10 mm tiles in the grid frame
% The grid is a set of 4- element vectors [x y 0 1] '.
GridWidth = 1000;
GridIncrement = 10;
CalibrationGrid = BuildGrid ( GridIncrement , GridWidth );
n = length(CalibrationGrid);

%% Position
% 3. Choose somewhere in space for the grid
% T_ow is the 4x4 tranformation matrix from grid to world .
T_ow = PositionGrid ();

% Define the scaling to use
if CameraHeight > CameraWidth
    CameraScale = 2.0 / CameraHeight ;
else
    CameraScale = 2.0 / CameraWidth ;
end
GridScale = 2.0/ GridWidth ;

% Generate the calibration images and the homographies
% Store Homographies and concensus sets in a Matlab Cell Array
% called HomogData .
HomogData = cell ( nImages ,3);

%% While loop to ensure cholesky is positive definite and obtain Phi

Ensure = 1;
while Ensure ==1
        Ensure =0;
    
    for CalImage = 1: nImages
        
        % Keep looking for homographies until we get a non - zero result .
        % 'Estimating ' is a toggle .
        Estimating = 1;
        while Estimating == 1
            % The default is 'Success ', i.e. Estimating = 0
            Estimating = 0;
            
            % 4 Choose a 'random ' location for the camera that fills the image
            % T_cw is the 4x4 transformation matrix from camera to world
            T_cw = FillImage (T_ow , KMatrix , GridWidth , CameraHeight , CameraWidth );
            
            % 5 We now fill the camera with a noisy image of the grid and
            % generate the point correpondences .
            % Correspondences is a set of pairs of vectors of the form [[u v]' [x y]']
            % for each grid corner that lies inside the image .
            NoiselessCorrespond = BuildCorrespondences(T_ow ,T_cw , CalibrationGrid , ...
                KMatrix , CameraHeight , CameraWidth);
            
            % Now add noise and truncate
            [Correspond, TruncatedNoisyCorrespond] = BuildNoisyCorrespondences (NoiselessCorrespond,n,CameraHeight,CameraWidth,CameraScale);
            
            NoisyCorrespond = Correspond;
            
            %% Scaling and add outliers 
%             OutlierlessCorrespond (1:2 ,:) = OutlierlessCorrespond (1:2 ,:) * CameraScale - 1.0;
%             OutlierlessCorrespond (3:4 ,:) = OutlierlessCorrespond (3:4 ,:) * GridScale ;             
%             NoiselessCorrespond (1:2 ,:) = NoiselessCorrespond (1:2 ,:) * CameraScale - 1.0;
%             NoiselessCorrespond (3:4 ,:) = NoiselessCorrespond (3:4 ,:) * GridScale ;
%             TruncatedNoisyCorrespond (1:2 ,:) = TruncatedNoisyCorrespond (1:2 ,:) * CameraScale - 1.0;
%             TruncatedNoisyCorrespond (3:4 ,:) = TruncatedNoisyCorrespond (3:4 ,:) * GridScale ;
              
        % Switch to turn truncation on and off
        Correspond = TruncatedNoisyCorrespond;
        

            % 6. Add in some 'outliers ' by replacing [u v]' with a point
            % somewhere in the image .
            % Define the Outlier probability
            pOutlier = 0.05;
            for j = 1: length ( Correspond )
                r = rand ;
                if r < pOutlier
                    Correspond (1,j) = rand * ( CameraWidth -1);
                    Correspond (2,j) = rand * ( CameraHeight -1);
                end
            end
            
            % Now scale the grid and camera to [-1, 1] to improve
            % the conditioning of the Homography estimation .
            Correspond (1:2 ,:) = Correspond (1:2 ,:) * CameraScale - 1.0;
            Correspond (3:4 ,:) = Correspond (3:4 ,:) * GridScale ;
                 
            %% Plots
        % Test the results without outliers:
        % figure 1 tests noise
%         figure (1)
%         ax1 = subplot(1,2,1);  % u,v,x,y without noise
%         ax2 = subplot(1,2,2);  % u,v,x,y with noise
%         plot(ax1, NoiselessCorrespond(1 ,:) ,NoiselessCorrespond(2 ,:) ,'.')
%         title(ax1,'u,v WITHOUT noise, unscaled ')
%         axis ij
%         plot(ax2, NoisyCorrespond(1 ,:) ,NoisyCorrespond(2 ,:) ,'.')
%         title(ax2,'u,v WITH noise, unscaled ')
%         
%         % figure 2  tests truncation
%         figure (2)
%         ax3 = subplot(1,2,1);  % u,v,x,y with noise (untruncated)
%         plot(ax3, NoisyCorrespond(1 ,:) ,NoisyCorrespond(2 ,:) ,'.')
%         title(ax3,'u,v WITH noise (untruncated), unscaled')
%         
%         ax4 = subplot(1,2,2);  % u,v,x,y truncated
%         plot(ax4, TruncatedNoisyCorrespond(1 ,:) ,TruncatedNoisyCorrespond(2 ,:) ,'.')
%         title(ax4,'Truncated WITH noise, unscaled u,v')
%         
%         % Now test with outliers implemented:
%         figure (3)
%         ax7 = subplot(1,2,1);  % without outliers
%         ax8 = subplot(1,2,2);  % with outliers 
%         
%         % Switch to turn truncation on and off
%         NoisyCorrespond = TruncatedNoisyCorrespond;
%         
%         NoisyCorrespond (1:2 ,:) = NoisyCorrespond (1:2 ,:) * CameraScale - 1.0;
%         NoisyCorrespond (3:4 ,:) = NoisyCorrespond (3:4 ,:) * GridScale ;
%         plot(ax7, NoisyCorrespond (1 ,:) ,NoisyCorrespond (2 ,:) ,'.')
%         title(ax7,'Outlierless, Noisy Correspond, scaled ')
%         axis ij
%         plot(ax8, Correspond (1 ,:) ,Correspond (2 ,:) ,'.')
%         title(ax8,'Outlier, Noisy Correspond, scaled ')
      %% Alternative plots (shortened)
        figure (1)
        ax1 = subplot(1,3,1);  % u,v,x,y without noise
        ax2 = subplot(1,3,2);  % u,v,x,y with noise
        ax3 = subplot(1,3,3);
        plot(ax1, NoiselessCorrespond(1 ,:) ,NoiselessCorrespond(2 ,:) ,'.')
        title(ax1,'u,v WITHOUT noise ')
        axis ij
        plot(ax2, NoisyCorrespond(1 ,:) ,NoisyCorrespond(2 ,:) ,'.')
        title(ax2,'u,v WITH noise, ENLARGED')
        plot(ax3, TruncatedNoisyCorrespond(1 ,:) ,TruncatedNoisyCorrespond(2 ,:) ,'.')
        title(ax3,'Truncated Correspond')
        
      
        % Switch to turn truncation on and off
        NoisyCorrespond = TruncatedNoisyCorrespond;
        
%         figure (2)
%         ax4 = subplot(1,2,1);
%         ax5 = subplot(1,2,2);
%         NoisyCorrespond (1:2 ,:) = NoisyCorrespond (1:2 ,:) * CameraScale - 1.0;
%         NoisyCorrespond (3:4 ,:) = NoisyCorrespond (3:4 ,:) * GridScale ;
%         plot(ax4, NoisyCorrespond (1 ,:) ,NoisyCorrespond (2 ,:) ,'.')
%         title(ax4,'Outlierless, Noisy Correspond, scaled ')
%         axis ij
%         plot(ax5, Correspond (1 ,:) ,Correspond (2 ,:) ,'.')
%         title(ax5,'Outlier, Noisy Correspond, scaled ')
       
            %% Ransac
            % Store to compare before and after
            BeforeRansacCorrespond = Correspond;
            
            % 7. Perform the Ransac estimation - output the result for inspection
            % If the Ransac fails it retuns a zero Homography
            Maxerror = 100.0;
            % The maximum error allowed before rejecting a point .
            % I am using a variance of 0.5 pixels so sigma is sqrt (0.5)
            % 3 pixels in the * NORM * is 3 sigma as there are 2 errors involved
            % in the norm (u and v).
            %
            % Note : The above is in pixels - so scale before Ransac !
            RansacRuns = 70; % The number of runs when creating the consensusset .
            [Homog , BestConsensus ] = ...
                RansacHomog ( Correspond , Maxerror * CameraScale , RansacRuns );
        %% Test after ransac
        % Truncate the Correspond now by ommiting outliers
        % Only allow data in the consensus set to be used.
        s = size(Correspond);
        PassCorrespond = zeros(s(1),length(BestConsensus));
        
        for k = 1:length(BestConsensus)
            j = BestConsensus(k);
            if j ~= 0
                PassCorrespond(:,k) = Correspond(:,j);
            end
        end

        figure (3)
        ax9 = subplot(1,2,1);  
        ax10 = subplot(1,2,2);  
        plot(ax9, BeforeRansacCorrespond(1 ,:) ,BeforeRansacCorrespond(2 ,:) ,'.')
        title('Before Ransac, scaled to 1,1')        
        axis ij
        plot(ax10, PassCorrespond(1 ,:) ,PassCorrespond(2 ,:) ,'.')
        title('After Ransac, scaled to 1,1')

            %% Build Homog
            if Homog (3 ,3) > 0
                % This image worked . So record the homography and the
                % consensus set
                HomogData { CalImage ,1} = Homog ;
                HomogData { CalImage ,2} = Correspond ;
                HomogData { CalImage ,3} = BestConsensus ;
            else
                % The estimate failed . So go around again .
                Estimating = 1;
            end
            
        end % end of the while Estimating == 1 loop
    end % end of the nImages loop
    
    %% Build regressor
    % 8. Build the regressor (12x6 matrix) for estimating the Cholesky product
    Regressor = zeros (2* nImages ,6);
    for CalImage = 1: nImages
        r1 = 2* CalImage -1;
        r2 = 2* CalImage ;
        Regressor (r1:r2 ,:) = KMatrixRowPair ( HomogData { CalImage ,1});
    end
    
    %% Kernel and cholesky computation
    % % Find the kernel i.e. the solution of Phi that gives Si*Phi = 0
    % [U,D,V] = svd ( Regressor ,'econ');
    % % Convert the diagonal matrix into vector form
    % D = diag (D);
    % % M is the minimum value element, I is the index i.e. the Ith element in
    % % the vector, so that the chance of ill-conditioning (hence getting an
    % % inaccurate V from the estimared Regressor is lower)
    % [M,I] = min (D);
    % % K is the estimate of the kernel
    % K = V(:,I);
    % % The K is like the eigenvector corresponding to the minimum eigenvalue m,
    % % which is the Ith eigenvector where V is a 6x6
 
    % % Find the kernel where K is the KernelEstimate
    K= FindKernelEstimate(Regressor);
    
    % The matrix to be constructed needs to be positive definite
    % It is necessary that K (1) be positive .
    if K (1) < 0
        K = -K;
    end
    % the elements in the K matrix represents a pixel, and pixels must be
    % positive
    
    % Construct the matrix Phi from the kernel
    Phi = zeros (3);
    
    Phi (1 ,1) = K (1);
    Phi (1 ,2) = K (2);
    Phi (1 ,3) = K (3);
    Phi (2 ,2) = K (4);
    Phi (2 ,3) = K (5);
    Phi (3 ,3) = K (6);
    
    % Add in the symmetric components
    Phi (2 ,1) = Phi (1 ,2);
    Phi (3 ,1) = Phi (1 ,3);
    Phi (3 ,2) = Phi (2 ,3);
    
    % Check if the matrix is positive definite, now Phi is a symmetric 3x3
    e = eig(Phi);  % eigenvalue decomposition
    for j = 1:3
        if e(j) <= 0  % checks if any elements(eigenvalue) is negative
            warning ('The Cholesky product is not positive definite ')
            Ensure = 1;
        end
    end
    
end % End of the while loop ensuring Cholesky is positive definite


%% Compute KMatEstimated
% 9. Carry out the Cholesky factorization, where KMatEstimated is the upper
% triangular matrix of the Cholesky decomposition, K^-1
% where K is KMatrix now, not the kernel as before
KMatEstimated = chol (Phi);

% Invert the factor to obtain K
KMatEstimated = KMatEstimated \ eye (3);

% The scaling of the grid has no impact on the scaling of
% the K- matrix as the vector 't' takes no part in the estimate
% of Phi. Only the image scaling has an impact .

% first normalize the KMatrix
KMatEstimated = KMatEstimated / KMatEstimated (3 ,3);

% Optimize the K-matrix
OptKMatrix = OptimiseKMatrix(KMatEstimated , HomogData );

% Add 1.0 to the translation part of the image
OptKMatrix (1 ,3) = OptKMatrix (1 ,3) + 1;
OptKMatrix (2 ,3) = OptKMatrix (2 ,3) + 1;

% Rescale back to pixels
OptKMatrix (1:2 ,1:3) = OptKMatrix (1:2 ,1:3) / CameraScale ;

% % Now scale the theoretical KMatrix as well to [-1, 1] 
% Correspond (1:2 ,:) = Correspond (1:2 ,:) * CameraScale - 1.0;
% Correspond (3:4 ,:) = Correspond (3:4 ,:) * GridScale ;

OptKMatError = OptKMatrix - KMatrix;


