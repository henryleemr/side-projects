#%%Architecture of the neural network
from TFANN import ANNR
 
NC = B.shape[2]
#2 1-D conv layers with relu followed by 1-d conv output layer
ns = [('C1d', [8, NC, NC * 2], 4), ('AF', 'relu'), 
      ('C1d', [8, NC * 2, NC * 2], 2), ('AF', 'relu'), 
      ('C1d', [8, NC * 2, NC], 2)]
#Create the neural network in TensorFlow
cnnr = ANNR(B[0].shape, ns, batchSize = 32, learnRate = 2e-5, 
            maxIter = 64, reg = 1e-5, tol = 1e-2, verbose = True)
cnnr.fit(B, Y)
