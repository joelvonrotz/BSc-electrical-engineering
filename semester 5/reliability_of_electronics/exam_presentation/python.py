import numpy as np
import matplotlib.pyplot as plt

# [Parameters]
x = 100
num_simulations = 5000
a = 0.9 * x # uniform distribution
b = 1.1 * x
mu = x + 0.5 * x # normal distribution
sigma = mu + 0.3 * mu

# [Simulation]
load = np.random.uniform(a,b,num_simulations);
strength = np.random.normal(a,b,num_simulations);
interference = strength - load
failure_prob = np.sum(interference < 0) / num_simulations;
print(f"The change of failure is approximately {failure_prob * 100:.2f}%")

plt.hist(interference, bins=50, density=True, alpha=0.75, color='blue')
plt.title('Distribution of Load-Strength Interference');
plt.xlabel('Interference');
plt.ylabel('Probability Density');
plt.show()
