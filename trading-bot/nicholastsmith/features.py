from PastSampler import PastSampler
 
#%%Features are channels
C = np.hstack((Di[CN] for Di in D))[:, None, :]
HP = 16                 #Holdout period
A = C[0:-HP]                
SV = A.mean(axis = 0)   #Scale vector
C /= SV                 #Basic scaling of data
#%%Make samples of temporal sequences of pricing data (channel)
NPS, NFS = 256, 16         #Number of past and future samples
ps = PastSampler(NPS, NFS)
B, Y = ps.transform(A)
