"""
    test_sets.jl

# Description
The main collection of tests for the `CFAR` project.
This file loads common utilities and aggregates all other unit tests files.
"""

# -----------------------------------------------------------------------------
# PREAMBLE
# -----------------------------------------------------------------------------

using Revise
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
    # @info CFAR
    @info "Dir is: " @__DIR__
    @info "File is: " @__FILE__
    using DrWatson
    @info projectdir()
    @info CFAR.work_dir()
    @info isdir(CFAR.work_dir())
    @info CFAR.work_dir(test_dir)
    @info CFAR.results_dir(test_dir)
    @info CFAR.data_dir(test_dir)
    @info CFAR.config_dir(test_dir)
    @info CFAR.paper_results_dir(test_dir)
end

@testset "Experiments" begin
    # CFAR.run_exp(config_file="art-dist.yml")

end