import matplotlib.pyplot as mpl
 
nt = 4
PF = cnnr.PredictFull(B[:nt])
for i in range(nt):
    fig, ax = mpl.subplots(1, 4, figsize = (16 / 1.24, 10 / 1.25))
    ax[0].plot(PF[0][i])
    ax[0].set_title('Input')
    ax[1].plot(PF[2][i])
    ax[1].set_title('Layer 1')
    ax[2].plot(PF[4][i])
    ax[2].set_title('Layer 2')
    ax[3].plot(PF[5][i])
    ax[3].set_title('Output')
    fig.text(0.5, 0.06, 'Time', ha='center')
    fig.text(0.06, 0.5, 'Activation', va='center', rotation='vertical')
    mpl.show()