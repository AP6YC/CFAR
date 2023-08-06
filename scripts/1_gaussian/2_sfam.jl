"""
    2_sfam.jl

# Description
Trains and tests Simplified FuzzyARTMAP on the Gaussian dataset.

# Authors
- Sasha Petrenko <petrenkos@mst.edu>
"""

# -----------------------------------------------------------------------------
# PREAMBLE
# -----------------------------------------------------------------------------

using Revise
using CFAR

# -----------------------------------------------------------------------------
# ADDITIONAL DEPENDENCIES
# -----------------------------------------------------------------------------

using Distributed
using DrWatson
using ProgressMeter

# -----------------------------------------------------------------------------
# PARSE ARGS
# -----------------------------------------------------------------------------

# Parse the arguments provided to this script
pargs = CFAR.dist_exp_parse(
    "1_gaussian/2_sfam: Simplfied FuzzyARTMAP on the gaussian dataset."
)

pargs["procs"] = 2

# Start several processes
if pargs["procs"] > 0
    addprocs(pargs["procs"], exeflags="--project=.")
end

# Set the simulation parameters
sim_params = Dict{String, Any}(
    "m" => "sfam",
    "travel" => collect(range(0, 10, 100))
)

# -----------------------------------------------------------------------------
# PARALLEL DEFINITIONS
# -----------------------------------------------------------------------------

@everywhere begin
    # Activate the project in case
    using Pkg
    Pkg.activate(".")

    # Modules
    using Revise
    using CFAR
    # using ProgressMeter

    # Point to the sweep results
    sweep_results_dir(args...) = CFAR.results_dir(
        "1_gaussian",
        "2_sfam",
        "linear_sweep",
        args...
    )

    # Make the path
    mkpath(sweep_results_dir())

    # Load the config dict
    config = CFAR.get_gaussian_config("gaussians.yml")
    ms = CFAR.gen_gaussians(config)

    # local_sim(dict) = train_test_mc;
    local_sim(dict) = CFAR.train_test_mc(dict, ms, sweep_results_dir)
end

# -----------------------------------------------------------------------------
# EXPERIMENT
# -----------------------------------------------------------------------------

# Log the simulation scale
@info "START: $(dict_list_count(sim_params)) simulations across $(nprocs()) processes."

# Turn the dictionary of lists into a list of dictionaries
dicts = dict_list(sim_params)

# Parallel map the sims
pmap(local_sim, dicts)
# progress_pmap(local_sim, dicts)

# -----------------------------------------------------------------------------
# CLEANUP
# -----------------------------------------------------------------------------

# Close the workers after simulation
if pargs["procs"] > 0
    rmprocs(workers())
end

println("--- Simulation complete ---")
