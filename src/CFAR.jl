"""
    CFAR.jl

# Description
Definition of the `CFAR` module, which encapsulates experiment driver code.

# Authors
- Sasha Petrenko <petrenkos@mst.edu>
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

# Full usings (which supports comma-separated import notation)
using
    AdaptiveResonance,
    DocStringExtensions,
    DrWatson,
    Pkg

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
