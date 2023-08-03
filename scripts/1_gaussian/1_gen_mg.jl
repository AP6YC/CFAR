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
X, y, mx, my = CFAR.gen_gaussians(config)
ml = CFAR.get_mover_line(config)

# Init a plot object
p = plot()

scatter!(
    p,
    X[1, :],
    X[2, :],
    group=y,
)

scatter!(
    p,
    mx[1, :],
    mx[2, :],
    group=my,
)

plot!(
    p,
    ml[1, :],
    ml[2, :],
    linewidth = 3,
)
