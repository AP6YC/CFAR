"""
    test_sets.jl

# Description
The main collection of tests for the `CFAR` project.
This file loads common utilities and aggregates all other unit tests files.
"""

# -----------------------------------------------------------------------------
# PREAMBLE
# -----------------------------------------------------------------------------

using CFAR

# -----------------------------------------------------------------------------
# ADDITIONAL DEPENDENCIES
# -----------------------------------------------------------------------------

using
    Logging,
    Test

# -----------------------------------------------------------------------------
# DrWatson tests
# -----------------------------------------------------------------------------

@testset "DrWatson Modifications" begin
    # Temp dir for
    test_dir = "testing"
    @info CFAR.work_dir(test_dir)
    @info CFAR.results_dir(test_dir)
end
