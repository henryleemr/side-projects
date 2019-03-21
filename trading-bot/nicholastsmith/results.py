CI = list(range(C.shape[0]))
AI = list(range(C.shape[0] + PTS.shape[0] - HP))
NDP = PTS.shape[0] #Number of days predicted
for i, cli in enumerate(cl):
    fig, ax = mpl.subplots(figsize = (16 / 1.5, 10 / 1.5))
    hind = i * len(CN) + CN.index('high')
    ax.plot(CI[-4 * HP:], C[-4 * HP:, hind], label = 'Actual')
    ax.plot(AI[-(NDP + 1):], A[-(NDP + 1):, hind], '--', label = 'Prediction')
    ax.legend(loc = 'upper left')
    ax.set_title(cli + ' (High)')
    ax.set_ylabel('USD')
    ax.set_xlabel('Time')
    ax.axes.xaxis.set_ticklabels([])
    mpl.show()