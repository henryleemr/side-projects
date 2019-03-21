PTS = []                        #Predicted time sequences
P = B[[-1]]                     #Most recent time sequence
for i in range(HP // NFS + 1):  #Repeat prediction
    YH = cnnr.predict(P)
    P = np.concatenate([P[:, NFS:], YH], axis = 1)
    PTS.append(YH)
PTS = np.hstack(PTS).transpose((1, 0, 2))
A = np.vstack([A, PTS]) #Combine predictions with original data
A = np.squeeze(A) * SV  #Remove unittime dimension and rescale
C = np.squeeze(C) * SV