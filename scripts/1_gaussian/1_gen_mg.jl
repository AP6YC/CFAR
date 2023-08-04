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
# using MLDataUtils
using Plots
using DelimitedFiles

# -----------------------------------------------------------------------------
# VARIABLES
# -----------------------------------------------------------------------------

N_MOVES = 10
OUT_FILENAME = "gaussians.csv"

# -----------------------------------------------------------------------------
# DEPENDENT SETUP
# -----------------------------------------------------------------------------

out_dir(args...) = CFAR.results_dir("1_gaussian", args...)
mkpath(out_dir())
out_file = out_dir(OUT_FILENAME)

# -----------------------------------------------------------------------------
# EXPERIMENT
# -----------------------------------------------------------------------------

# Load the config dict
config = CFAR.get_gaussian_config("gaussians.yml")

# Generate the Gaussian samples
# X, y, mx, my = CFAR.gen_gaussians(config)
ms = CFAR.gen_gaussians(config)
# X, y = CFAR.gen_gaussians("gaussians.yml")

# Get the mover line for visualization
ml = CFAR.get_mover_line(config)

# Init a plot object
p = plot()

# Plot the original Gaussians samples
CFAR.scatter_gaussian!(p, ms.static)

# Plot the samples from the mover
CFAR.scatter_gaussian!(p, ms.mover)

# Plot the mover's line
plot!(
    p,
    ml[1, :],
    ml[2, :],
    linewidth = 3,
)

display(p)

# data = vcat(
#     X',
#     mx',
# )

# writedlm(out_file, data)
