"""
    1_gen_mg.jl

# Description
This script implements an experiment using multivariate gaussian samples for illustrating apparent catastrophic forgetting.

# Authors
- Sasha Petrenko <petrenkos@mst.edu>
"""

# -----------------------------------------------------------------------------
# PREAMBLE
# -----------------------------------------------------------------------------

using Revise
using CFAR

# -----------------------------------------------------------------------------
# ADDITIONAL DEPENDENCIES
# -----------------------------------------------------------------------------

using Distributions, Random
using MLDataUtils
using Plots
using DelimitedFiles

# -----------------------------------------------------------------------------
# VARIABLES
# -----------------------------------------------------------------------------

N_MOVES = 10

# -----------------------------------------------------------------------------
# EXPERIMENT
# -----------------------------------------------------------------------------

# Load the config dict
config = CFAR.get_gaussian_config("gaussians.yml")

# Generate the Gaussian samples
X, y, mx, my = CFAR.gen_gaussians(config)
# X, y = CFAR.gen_gaussians("gaussians.yml")

# Get the mover line for visualization
ml = CFAR.get_mover_line(config)

# Init a plot object
p = plot()

# Plot the original Gaussians samples
scatter!(
    p,
    X[1, :],
    X[2, :],
    group=y,
)

# Plot the samples from the mover
scatter!(
    p,
    mx[1, :],
    mx[2, :],
    group=my,
)

# Plot the mover's line
plot!(
    p,
    ml[1, :],
    ml[2, :],
    linewidth = 3,
)

data = vcat(
    X',
    mx',
)

writedlm("asdf.csv", data)
