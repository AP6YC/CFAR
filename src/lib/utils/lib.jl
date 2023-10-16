"""
    lib.jl

# Description
Aggregates the utility files.

# Authors
- Sasha Petrenko <petrenkos@mst.edu> @AP6YC
"""

# -----------------------------------------------------------------------------
# INCLUDES
# -----------------------------------------------------------------------------

# Docstring templates and common variables
include("docstrings.jl")

# DrWatson extensions
include("drwatson.jl")

# Version of the project
include("version.jl")

# File operations
include("file.jl")

# Color definitions
include("colors.jl")

# Argparse, etc.
include("args.jl")

# # Local data loading utilities
# include("data_utils.jl")
