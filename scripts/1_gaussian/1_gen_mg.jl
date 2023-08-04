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

# Visualize the data
CFAR.plot_mover(ms, config)

# CFAR.shift_mover!(ms, config, 0.1)
# CFAR.plot_mover(ms, config)
# data = vcat(
#     X',
#     mx',
# )

# writedlm(out_file, data)
