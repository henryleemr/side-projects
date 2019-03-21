import numpy as np
from scipy.stats import norm
from scipy.stats import uniform
from scipy.stats import expon
import matplotlib.pyplot as plt

# target distribution mixture components (doing this here for efficiency)
MIX = []
MU1 = 20
SIGMA1 = 3
MIX.append(norm(MU1, SIGMA1))
MU2 = 40
SIGMA2 = 10
MIX.append(norm(MU2, SIGMA2))
# component weights (weighing them all equally... i.e. w = 0.5 each in this case)
W = 1.0/len(MIX)

def evalTarget(x):
     """
     Evaluate the (often unnormalised) target distribution, p. Here, a mixture of Gaussians
     """
     # compute weighted sum of all components
     p_x = 0.0
     for component in MIX:
         p_x = p_x + W * component.pdf(x)
     return p_x

def main():
    q = uniform(0, 100).pdf
    q_sample = uniform(0, 100).rvs
    k = 8
    #-------------------------------
    # how many samples to draw?

    N = 50000

    # perform N rounds of rejection sampling now...
    x = []
    accepted = 0.0
    for i in range(N):
        # produce a status output in a defined interval
        if i % 1000 == 0:
            print ("...running iteration %d..." % i)

        # ...sample from q
        x_0 = q_sample()
        # sample from uniform distribution in range [0, k * q(s)]
        z = uniform.rvs()

        # ... check whether to accept x_0
        if z <= evalTarget(x_0):
            x.append(x_0)
            accepted = accepted + 1.0

    print("Acceptance rate: %f%%" % (accepted / N * 100))

    # ... plot a histrogram of samples
    plt.hist(x, 50, normed=1, alpha=0.75)

    # show actual target distribution
    state_space = np.linspace(0, 100, 1000)
    p_x = evalTarget(state_space)
    plt.plot(state_space, p_x, linewidth=2.0)
    plt.xlabel("x")
    plt.ylabel("pdf")

    plt.show()


if __name__ == "__main__":
    main()
