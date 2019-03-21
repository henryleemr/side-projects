# Rejection Sampling

Samples from a Gaussian mixture p(x) of two distributions such that:
p(x) = ∑ { k * N(x, mu, sigma)}

where k1 = k2 = 0.5, and mu1 = 20, sigma1 = 3 ,mu2 = 40 , sigma2 = 10

Run "rejection_sampling.py" to obtain a histogram that represents the sampling  
of the combined gaussian distributions

# Metropolis Hastings sampling

Run Metropolis_Hasttings_sampling.py to obtain the histogram of the sampled data

-to tune the efficiency of the sampling process, we set the variance of the proposal
distribution such that the rejection rate lies somewhere between 50-85%
