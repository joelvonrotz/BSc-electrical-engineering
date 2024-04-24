import numpy as np
import matplotlib.pyplot as plt

def monte_carlo_simulation(num_simulations, load_params, strength_params):
    # Generate random samples for load and strength
    load_samples = np.random.uniform(load_params[0], load_params[1], num_simulations)
    strength_samples = np.random.normal(strength_params[0], strength_params[1], num_simulations)
    
    # Calculate the reliability for each simulation
    interference = strength_samples - load_samples
    reliability = load_samples / strength_samples
    return load_samples, strength_samples, reliability, interference

def plot_simulation_results(load_samples, strength_samples, reliability, interference):
    # Plot the load and strength distributions
    plt.figure(figsize=(12, 12))
    plt.subplot(4, 1, 1)
    plt.hist(load_samples, bins=50, density=True, alpha=0.7, color='blue', label='Load Distribution')
    plt.title('Load Distribution')
    plt.xlabel('Load')
    plt.ylabel('Probability Density')
    plt.legend()

    plt.subplot(4, 1, 2)
    plt.hist(strength_samples, bins=50, density=True, alpha=0.7, color='green', label='Strength Distribution')
    plt.title('Strength Distribution')
    plt.xlabel('Strength')
    plt.ylabel('Probability Density')
    plt.legend()


    # Plot the reliability distribution
    
    plt.subplot(4, 1, 3)
    plt.hist(reliability, bins=50, density=True, alpha=0.7, color='red', label='Reliability')
    plt.title('Reliability Distribution')
    plt.xlabel('Reliability (Load/Strength)')
    plt.ylabel('Probability Density')
    plt.legend()
    plt.tight_layout()
    plt.show()

    plt.subplot(4, 1, 3)
    plt.hist(reliability, bins=50, density=True, alpha=0.7, color='red', label='Reliability')
    plt.title('Reliability Distribution')
    plt.xlabel('Reliability (Load/Strength)')
    plt.ylabel('Probability Density')
    plt.legend()
    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    # Set the parameters
    num_simulations = 10000
    load_params = (90, 110)
    strength_params = (150, 195)

    # Run the Monte Carlo simulation
    load_samples, strength_samples, reliability, interference = monte_carlo_simulation(num_simulations, load_params, strength_params)

    # Plot the simulation results
    plot_simulation_results(load_samples, strength_samples, reliability, interference)
