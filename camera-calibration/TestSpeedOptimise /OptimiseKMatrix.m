function [ KMatrix ] = OptimiseKMatrix ( InitialKMatrix , Data )

 %% Section 1: Initialise
 % Carry out your sanity checks here .... Initialise the KMatrix
 KMatrix = InitialKMatrix ;

 % Normalize the K- matrix ( just in case0
 KMatrix = KMatrix / KMatrix (3 ,3);

 % Define the numbers to access the DataCell
 NHOMOGRAPHY = 1;
 NCORRESPOND = 2;
 NCONSENSUS = 3;

 % Extract the number of images used in the estimation
 s = size ( Data );
 nImages = s(1);

 % A rotation matrix to be constructed .
 RotMat = zeros (3);
 % end of cell 1
 %% Section 2: Obtaining Theta, Translation, RotAxis
 % 1. We first need to use the initial KMatrix to generate
 % a perspectivity for each image and hence the parameterization
 % of the grid 's frame in the camera frame .
 FrameParameters = cell ( nImages ,2);
 % Labels for accessing the cell
 NANGLE = 1;
 NTRANSLATION = 2;

 for nHomog = 1: nImages
     % Extract the homography from the data and convert to
     % a perspectivity
     Perspectivity = KMatrix \ Data { nHomog , NHOMOGRAPHY };

     % The Perspectivity is scaled so that its bottom right hand
     % is a unit vector - we need the first column to have a norm
     % of 1 (a column of a rotation matrix )
     Perspectivity = Perspectivity / norm ( Perspectivity (: ,1));

     % The translation part of the perspectivity in the camera frame
     Translation = Perspectivity (: ,3);

     % Start building the rotation matrix
     RotMat (: ,1:2) = Perspectivity (: ,1:2) ;
     % Project out the first column from the second
     RotMat (: ,2) = RotMat (: ,2) - ( RotMat (: ,1)'* RotMat (: ,2))* RotMat (: ,1);
     RotMat (: ,2) = RotMat (: ,2) / norm ( RotMat (: ,2));
     % And complete with a cross product
     RotMat (: ,3) = cross ( RotMat (: ,1) ,RotMat (: ,2));

     % Find the angle of rotation usng the trace identity
     CosTheta = ( trace ( RotMat ) -1) /2;

     % Make sure the answer is valid
     if CosTheta > 1
            CosTheta = 1;
     end

     if CosTheta < -1
            CosTheta = -1;
     end
     % Theta is the angle of rotation
     Theta = acos ( CosTheta );

     % Find the axis of rotation by finding the real eigenvector
     [V,D] = eig( RotMat );
     D = diag (D);
     % I will be the real vector .
     [M,I] = max( real (D));
     RotAxis = real (V(:,I));
     RotAxis = RotAxis / norm ( RotAxis );

     % We need to check if the axis is pointing in the 'right ' direction
     % consistent with Theta using Rodrigue 's formula
     Rplus = Rodrigues( RotAxis , Theta );
     Rminus = Rodrigues(- RotAxis , Theta );

     % Reverse the axis if minus Theta is the best match
     if norm ( RotMat - Rminus ) < norm (RotMat - Rplus )
        RotAxis = -RotAxis ;
     end

     % Now shift the angle by 4pi so that we can have negative as
     % well as positive angles
     Theta = Theta +4* pi;
     % Generate a shifted angle - axis representation of the rotation .
     RotAxis = RotAxis * Theta ;

     % Record the initial position of the grid
     FrameParameters {nHomog , NANGLE } = RotAxis ;
     FrameParameters {nHomog , NTRANSLATION } = Translation ;
 end
 %% Section 3.1: Initialise LM method
 % Now go through the LM steps . There are a variable number of
 % measrements , so use another Matlab cell structure to store the
 % various components .
 % The components are:
 % 1. Error Vector .
 % 2. KMatrixJacobian .
 % 3. FrameParametersJacobian .
 % The above correspond to the following cell entries .
 NERRORVECTOR = 1;
 NKMATJACOB = 2;
 NFRAMEJACOB = 3;

 OptComponents = cell ( nImages ,3);
 
 % Allocate space for J'J
 ProblemSize = 5+6* nImages ;
 JTransposeJ = zeros ( ProblemSize );

 % Initialise the total error
 CurrentError = 0.0;

 % Initialise the Gradient as a column vector
 Gradient = zeros ( ProblemSize ,1);
 %% Section 3.2: Obtain JJ' and Gradient
 % 2. Compute the inital error vector and the Jacobians and the inner
 % product
 for j = 1: nImages
     % The error vector for each image
     OptComponents {j, NERRORVECTOR } = ComputeImageErrors ( KMatrix , ...
        FrameParameters {j, NANGLE }, FrameParameters {j, NTRANSLATION } ,...
        Data {j, NCORRESPOND }, Data {j, NCONSENSUS });

     % Compute the initial error
     CurrentError = CurrentError + 0.5 * ...
        OptComponents {j, NERRORVECTOR }'* OptComponents {j, NERRORVECTOR };

     % The Jacobian for each image
     [ OptComponents{j, NKMATJACOB }, OptComponents{j, NFRAMEJACOB }]= SingleImageJacobian ( KMatrix ,...
        FrameParameters {j, NANGLE }, FrameParameters {j, NTRANSLATION } ,...
        Data {j, NCORRESPOND }, Data {j, NCONSENSUS });

     % The top 5x5 block is the sum of all the inner products of the
     % K- matrix Jacobian blocks .
     JTransposeJ(1:5 ,1:5) = JTransposeJ(1:5 ,1:5) + ... %top left block
        OptComponents{j, NKMATJACOB }' * OptComponents{j, NKMATJACOB };

     % The diagonal image block associated with the frame parameters
     StartRow = 6 + (j -1) *6;
     EndRow = StartRow +5;
     
     JTransposeJ ( StartRow :EndRow , StartRow : EndRow ) = ... % 2nd diag block  ie 2nd row 2nd col
        OptComponents {j, NFRAMEJACOB }' * OptComponents {j, NFRAMEJACOB };

     JTransposeJ (1:5 , StartRow : EndRow ) = ... % 1st row 2nd col block 
        OptComponents {j, NKMATJACOB }' * OptComponents {j, NFRAMEJACOB };

     JTransposeJ ( StartRow :EndRow ,1:5) = JTransposeJ (1:5 , StartRow : EndRow )'; % 2nd row 1st col block

     % Compute the gradient vector
     Gradient (1:5) = Gradient (1:5) + ...
        OptComponents {j, NKMATJACOB }'* OptComponents {j, NERRORVECTOR };
     Gradient ( StartRow : EndRow ) = OptComponents {j, NFRAMEJACOB }'*...
        OptComponents {j, NERRORVECTOR };

 end

 % The initial value of mu
 display(JTransposeJ);
 mu = max( diag ( JTransposeJ )) * 0.1;
 display(mu);

 % The initial value of the exponential growth factor nu
 % This variable is used to increase mu if the error goes up.
 nu = 2;
 
 %% Section 3.3: Optimisation
 % Now perform the optimisation
 Searching = 1;
 Iterations = 0;
 MaxIterations = 100;
 while Searching == 1

     Iterations = Iterations + 1;

     if Iterations > MaxIterations
        error (' Number of interations is too high ')
     end

     % 4. Test for convergence - choose a size for the gradient
     if norm ( Gradient )/ ProblemSize < 0.001
         break ; % Leave the loop
     end
    %%
     % 3. Solve for the change to parameters
     dp = -( JTransposeJ + mu*eye( ProblemSize )) \ Gradient ;

     % Step 5.
     PredictedChange = Gradient'* dp;

     % 6. Define the new test parameters
     KMatPerturbed = KMatrix ;
     FrameParametersPerturbed = FrameParameters ;

     KMatPerturbed (1 ,1) = KMatPerturbed (1 ,1) + dp (1);
     KMatPerturbed (1 ,2) = KMatPerturbed (1 ,2) + dp (2);
     KMatPerturbed (1 ,3) = KMatPerturbed (1 ,3) + dp (3);
     KMatPerturbed (2 ,2) = KMatPerturbed (2 ,2) + dp (4);
     KMatPerturbed (2 ,3) = KMatPerturbed (2 ,3) + dp (5);

     display(KMatPerturbed);
     
     % Initialise the error for the latest test
     NewError = 0;
     for j = 1: nImages

         % Perturb the image location
         StartRow = 6 + (j -1) *6;
         FrameParametersPerturbed {j, NANGLE } = ...
         FrameParametersPerturbed {j, NANGLE } + dp( StartRow : StartRow +2);

         FrameParametersPerturbed {j, NTRANSLATION } = ...
         FrameParametersPerturbed {j, NTRANSLATION } + ...
         dp( StartRow +3: StartRow +5);

         % ... And compute the error vector for this image
         OptComponents {j, NERRORVECTOR } = ...
         ComputeImageErrors ( KMatPerturbed , ...
         FrameParametersPerturbed {j, NANGLE } ,...
         FrameParametersPerturbed {j, NTRANSLATION } ,...
         Data {j, NCORRESPOND }, Data {j, NCONSENSUS });

         % Compute the error
         NewError = NewError + 0.5 * ...
         OptComponents {j, NERRORVECTOR }'* OptComponents {j, NERRORVECTOR };

    end

    ChangeInError = NewError - CurrentError ;
    % Step 7.
    Gain = ChangeInError / PredictedChange ;

    % Step 8.
 if ChangeInError > 0
     % Error has gone up. Increase mu
     mu = mu*nu;
     nu = nu *2;
 else
     % Error has gone down . Update mu
     nu = 2; % Default start value of nu
     mu = mu * max ([1/3 ,(1 -(2* Gain -1) ^3) ]);

     % Update the parameters
     KMatrix = KMatPerturbed ;
     FrameParameters = FrameParametersPerturbed ;

     % Update the error
     CurrentError = NewError ;

     % The Jacobian is expensive to compute - only recompute
     % if the gain is low , i.e. the Jacobian is not accurate
     if Gain < 1/3
         % The gain is poor - recompute the Jacobian and the Gradient
         JTransposeJ = zeros ( ProblemSize );
         for j = 1: nImages
             % The Jacobian
             [ OptComponents{j, NKMATJACOB } ,...
                 OptComponents{j, NFRAMEJACOB }] = ...
                 SingleImageJacobian ( KMatrix ,...
                 FrameParameters {j, NANGLE }, ...
                 FrameParameters {j, NTRANSLATION } ,...
                 Data {j, NCORRESPOND }, Data {j, NCONSENSUS });

             % The top 5x5 block is the sum of all the inner products
             % of the
             % K- matrix Jacobian blocks .
             JTransposeJ (1:5 ,1:5) = JTransposeJ (1:5 ,1:5) + ...
                 OptComponents {j, NKMATJACOB }' * ...
                 OptComponents {j, NKMATJACOB };

             % The diagonal image block associated with the frame
             % parameters
             StartRow = 6 + (j -1) *6;
             EndRow = StartRow +5;
             JTransposeJ ( StartRow :EndRow , StartRow : EndRow ) = ...
                 OptComponents {j, NFRAMEJACOB }' * ...
                 OptComponents {j, NFRAMEJACOB };

             JTransposeJ (1:5 , StartRow : EndRow ) = ...
                 OptComponents {j, NKMATJACOB }' * ...
                 OptComponents {j, NFRAMEJACOB };
             
             JTransposeJ ( StartRow :EndRow ,1:5) = ...
                  JTransposeJ (1:5 , StartRow : EndRow )';
         end
    end

    % Compute the new gradient
    Gradient = zeros ( ProblemSize ,1);
    for j = 1: nImages
        Gradient (1:5) = Gradient (1:5) + ...
            OptComponents {j, NKMATJACOB }'* OptComponents {j, NERRORVECTOR...
            };

        StartRow = 6 + (j-1)*6;
        EndRow = StartRow + 5;
         
        Gradient ( StartRow : EndRow ) = OptComponents {j, NFRAMEJACOB }'*...
            OptComponents {j, NERRORVECTOR };
    end

 end


 end

end
 


%OUTPUTS for jacobab us KMatrixJacobian 