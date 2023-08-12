"""
    lib.jl

# Description
Aggregates all types and functions that are used throughout the `CFAR` project.

# Authors
- Sasha Petrenko <petrenkos@mst.edu> @AP6YC
"""

# -----------------------------------------------------------------------------
# INCLUDES
# -----------------------------------------------------------------------------

# Top-level constants for various options and fields used in the project
include("constants.jl")

# Common experiment and file utilities
include("utils/lib.jl")

# Train/test data container definitions
include("data.jl")

# Gaussian data definitions
include("gaussians.jl")

# Plotting utilities
include("plot.jl")

# Experiment functions
include("experiments.jl")

# PythonCall utilities
include("py.jl")
