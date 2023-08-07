"""
    2a_analyze_sfam.jl

# Description
This script takes the results of the Monte Carlo and generates plots of their statistics.

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

using PythonCall
# using CondaPkg

# run(`python $pydeps`)
mlp = pyimport("mlp")

# Load the config dict
config = CFAR.get_gaussian_config("gaussians.yml")
ms = CFAR.gen_gaussians(config)

mlp.examine_data(ms)
