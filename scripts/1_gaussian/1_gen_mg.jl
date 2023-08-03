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

# -----------------------------------------------------------------------------
# EXPERIMENT
# -----------------------------------------------------------------------------

N_POINTS = 1000

rng = MersenneTwister(1234)

config = CFAR.get_gaussian_config("gaussians.yml")
# X, y = CFAR.gen_gaussians("gaussians.yml")
X, y = CFAR.gen_gaussians(config, 1.0)

p1 = scatter(
    X[1, :],
    X[2, :],
)

# p1 = scatter(
#     X
# )

plot(
    p1
)
