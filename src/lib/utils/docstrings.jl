"""
    docstrings.jl

# Description
A collection of common docstrings and docstring templates for the project.

# Authors
- Sasha Petrenko <petrenkos@mst.edu> @AP6YC
"""

# -----------------------------------------------------------------------------
# DOCSTRING TEMPLATES
#   These templates tell `DocStringExtensions.jl` how to customize docstrings of various types.
# -----------------------------------------------------------------------------

# Constants template
@template CONSTANTS =
"""
$(FUNCTIONNAME)

# Description
$(DOCSTRING)
"""

# Types template
@template TYPES =
"""
$(TYPEDEF)

# Summary
$(DOCSTRING)

# Fields
$(TYPEDFIELDS)
"""

# Template for functions, macros, and methods (i.e., constructors)
@template (FUNCTIONS, METHODS, MACROS) =
"""
$(TYPEDSIGNATURES)

# Summary
$(DOCSTRING)

# Method List / Definition Locations
$(METHODLIST)
"""

# -----------------------------------------------------------------------------
# DOCSTRING CONSTANTS
#   This location is a collection of variables used for injecting into other docstrings.
# This is useful when many functions utilize the same arguments, etc.
# -----------------------------------------------------------------------------

"""
Docstring prefix denoting that the constant is used as a common docstring element for other docstrings.
"""
const COMMON_DOC = "Common docstring:"

"""
$COMMON_DOC the arguments to `DrWatson`-style directory functions.
"""
const DRWATSON_ARGS_DOC = """
# Arguments
- `args...`: the string directories to append to the directory.
"""

"""
$COMMON_DOC config filename argument.
"""
const ARG_CONFIG_FILE = """
- `config_file::AbstractString`: the config file name as a string.
"""

"""
$COMMON_DOC config dictionary argument.
"""
const ARG_CONFIG_DICT = """
- `config::ConfigDict`: the config parameters as a dictionary.
"""

"""
$COMMON_DOC argument for a split ratio `p`.
"""
const ARG_P = """
- `p::Float=0.8`: kwarg, the split ratio ∈ `(0, 1)`.
"""

"""
$COMMON_DOC argument for an existing `Plots.Plot` object to plot atop.
"""
const ARG_PLOT = """
- `p::Plots.Plot`: an existing `Plots.Plot` object.
"""

"""
$COMMON_DOC argument for a file name.
"""
const ARG_FILENAME = """
- `filename::AbstractString`: the full file path as a string.
"""

"""
$COMMON_DOC argument for a directory function
"""
const ARG_SIM_DIR_FUNC = """
- `dir_func::Function`: the function that provides the correct file path with provided strings.
"""

"""
$COMMON_DOC argument for the simulation options dictionary.
"""
const ARG_SIM_D = """
- `d::AbstractDict`: the simulation options dictionary.
"""

"""
$COMMON_DOC argument for the simulation [`MoverSplit`](@ref) dataset.
"""
const ARG_SIM_MS = """
- `ms::MoverSplit`: the [`MoverSplit`](@ref) dataset to train and test on.
"""

"""
$COMMON_DOC argument for additional simulation options.
"""
const ARG_SIM_OPTS = """
- `opts::AbstractDict`: additional options for the simulation.
"""
