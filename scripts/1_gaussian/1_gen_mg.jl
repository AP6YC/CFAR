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
data = CFAR.gen_gaussians("gaussians.yml")

dist1 = MvNormal(
    [0.0, 6.0],
    [1.0 0.0; 0.0 1.0]
)

dist2 = MvNormal(
    [4.5, 6.0],
    [2.0 -1.5; -1.5 2.0]
)

dist3 = MvNormal(
    [4.5, 6.0],
    [2.0 -1.5; -1.5 2.0]
)

slope = -1
intercept = -1

X = hcat(
    rand(rng, dist1, N_POINTS),
    rand(rng, dist2, N_POINTS)
)

y = vcat(
    ones(Int64, N_POINTS),
    zeros(Int64, N_POINTS)
)

p1 = scatter(
    X[1, :],
    X[2, :],
)

plot(
    p1
)
