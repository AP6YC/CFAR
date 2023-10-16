"""
    CFAR.jl

# Description
Definition of the `CFAR` module, which encapsulates experiment driver code.

# Authors
- Sasha Petrenko <petrenkos@mst.edu> @AP6YC
"""

"""
A module encapsulating the experimental driver code for the CFAR project.

# Imports

The following names are imported by the package as dependencies:
$(IMPORTS)

# Exports

The following names are exported and available when `using` the package:
$(EXPORTS)
"""
module CFAR

# -----------------------------------------------------------------------------
# DEPENDENCIES
# -----------------------------------------------------------------------------

# Imports
import YAML

# Full usings (which supports comma-separated import notation)
using
    AdaptiveResonance,
    ArgParse,
    Arrow,
    ColorSchemes,
    # CondaPkg,
    CSV,
    DataFrames,
    DataStructures,
    DelimitedFiles,
    DocStringExtensions,
    DrWatson,
    Distributed,
    Distributions,          # MvNormal
    ElasticArrays,
    # HDF5,
    JLD2,
    LazyModules,
    NumericalTypeAliases,
    Pkg,
    Plots,
    # PythonCall,
    Random,
    # Statistics,
    StatsPlots

# @lazy import CondaPkg = "992eb4ea-22a4-4c89-a5bb-47a3300528ab"
# @lazy import PythonCall = "6099a3de-0909-46bc-b1f4-468b9a2dfc0d"
import CondaPkg
import PythonCall

# Individual usings
using MLUtils: splitobs, shuffleobs
using DataStructures: OrderedDict

# Precompile concrete type methods
using PrecompileSignatures: @precompile_signatures

# -----------------------------------------------------------------------------
# VARIABLES
# -----------------------------------------------------------------------------

# Necessary to download data without prompts to custom folders
ENV["DATADEPS_ALWAYS_ACCEPT"] = true
# Suppress display on headless systems
ENV["GKSwstype"] = 100

# -----------------------------------------------------------------------------
# INCLUDES
# -----------------------------------------------------------------------------

# Library code
include("lib/lib.jl")

# -----------------------------------------------------------------------------
# INIT
# -----------------------------------------------------------------------------

# """
# Initialization function for the `CFAR` project.
# """
# function __init__()
#     # Run the conda setup
#     conda_setup()
# end

# -----------------------------------------------------------------------------
# EXPORTS
# -----------------------------------------------------------------------------

# Export all public names
export
    CFAR_VERSION

# -----------------------------------------------------------------------------
# PRECOMPILE
# -----------------------------------------------------------------------------

# Precompile any concrete-type function signatures
@precompile_signatures(CFAR)

end
