"""
    2_art.jl

# Description
Trains and tests Simplified FuzzyARTMAP on the Gaussian dataset.

# Authors
- Sasha Petrenko <petrenkos@mst.edu> @AP6YC
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

# -----------------------------------------------------------------------------
# VARIABLES
# -----------------------------------------------------------------------------

exp_top = "1_gaussian"
# exp_name = "2_art.jl"
exp_name = basename(@__FILE__)
config_file = "art.yml"

@info PROGRAM_FILE
# @info CFAR.exp_name

# -----------------------------------------------------------------------------
# PARSE ARGS
# -----------------------------------------------------------------------------

# Parse the arguments provided to this script
pargs = CFAR.dist_exp_parse(
    "$(exp_top)/$(exp_name): Simplfied FuzzyARTMAP on the Gaussian dataset."
)

# Load the simulation options
opts = CFAR.load_art_sim_opts(config_file)

pargs["procs"] = 0

# Start several processes
if pargs["procs"] > 0
    addprocs(pargs["procs"], exeflags="--project=.")
end

# Set the simulation parameters
sim_params = Dict{String, Any}(
    "m" => "sfam",
    "travel" => collect(range(
        opts["travel_lb"],
        opts["travel_ub"],
        opts["n_points"],
    )),
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

    # Point to the sweep results
    sweep_results_dir(args...) = CFAR.results_dir(
        "1_gaussian",
        "2_art",
        "linear_sweep",
        args...
    )

    # Make the path
    mkpath(sweep_results_dir())

    # Load the config dict
    config = CFAR.get_gaussian_config("gaussians.yml")
    ms = CFAR.gen_gaussians(config)

    # Load the simulation options
    opts = CFAR.load_art_sim_opts("art.yml")

    # Define the single-parameter function used for pmap
    local_sim(dict) = CFAR.train_test_sfam_mc(
        dict,
        ms,
        sweep_results_dir,
        opts,
    )
end

# -----------------------------------------------------------------------------
# EXPERIMENT
# -----------------------------------------------------------------------------

# Log the simulation scale
@info "CFAR: $(dict_list_count(sim_params)) simulations across $(nprocs()) processes."

# Turn the dictionary of lists into a list of dictionaries
dicts = dict_list(sim_params)

# Parallel map the sims
pmap(local_sim, dicts)
# progress_pmap(local_sim, dicts)

# -----------------------------------------------------------------------------
# CLEANUP
# -----------------------------------------------------------------------------

# Close the workers after simulation
rmprocs(workers())

println("--- Simulation complete ---")
