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

# N_MOVES = 10
OUT_FILENAME = "gaussians.h5"

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
# CFAR.plot_mover(ms, config)
CFAR.plot_mover(ms)

ms_new = deepcopy(ms)
for ix = 1:5
    global ms_new = CFAR.shift_mover(ms_new, 1.0)
    # CFAR.plot_mover(ms_new, config)
    CFAR.plot_mover(ms_new)
end


# writedlm(out_file, data)
