"""
    1_gen_mg.jl

# Description
This script implements an experiment using multivariate gaussian samples for illustrating apparent catastrophic forgetting.

# Authors
- Sasha Petrenko <petrenkos@mst.edu> @AP6YC
"""

# -----------------------------------------------------------------------------
# PREAMBLE
# -----------------------------------------------------------------------------

using Revise
using CFAR

# -----------------------------------------------------------------------------
# ADDITIONAL DEPENDENCIES
# -----------------------------------------------------------------------------

using ClusterValidityIndices

ch = CH()

config = CFAR.get_gaussian_config("gaussians.yml")
ms = CFAR.gen_gaussians(config)

ms
# get_cvi!(ch, m)