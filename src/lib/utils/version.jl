"""
    version.jl

# Description
Borrowed from MLJ.jl, this defines the version of the package as a constant in the module.

# Authors
- Sasha Petrenko <petrenkos@mst.edu> @AP6YC

# Credits
- MLJ.jl: https://github.com/alan-turing-institute/MLJ.jl
"""

# -----------------------------------------------------------------------------
# DEPENDENCIES
# -----------------------------------------------------------------------------

using Pkg

# -----------------------------------------------------------------------------
# CONSTANTS
# -----------------------------------------------------------------------------

"""
A constant that contains the version of the installed CFAR package.

This value is computed at compile time, so it may be used to programmatically verify the version of `CFAR` that is installed in case a `compat` entry in your Project.toml is missing or otherwise incorrect.
"""
const CFAR_VERSION = VersionNumber(
    Pkg.TOML.parsefile(joinpath(dirname(@__DIR__), "..", "..", "Project.toml"))["version"]
)
