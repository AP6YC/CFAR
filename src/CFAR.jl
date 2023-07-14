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

using
    DocStringExtensions,
    DrWatson,
    Pkg

# Library code
include("lib/lib.jl")

export
    CFAR_VERSION

end
