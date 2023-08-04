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
Common docstring, the arguments to `DrWatson`-style directory functions.
"""
const DRWATSON_ARGS_DOC = """
# Arguments
- `args...`: the string directories to append to the directory.
"""

"""
Common docstring: config filename argument.
"""
const ARG_CONFIG_FILE = """
- `config_file::AbstractString`: the config file name as a string.
"""

"""
Common docstring: config dictionary argument.
"""
const ARG_CONFIG_DICT = """
- `config::ConfigDict`: the config parameters as a dictionary.
"""

"""
Common docstring: argument for a split ratio `p`.
"""
const ARG_P = """
- `p::Float=0.8`: kwarg, the split ratio ∈ `(0, 1)`.
"""

"""
Common docstring: argument for an existing `Plots.Plot` object to plot atop.
"""
const ARG_PLOT = """
- `p::Plots.Plot`: an existing `Plots.Plot` object.
"""
