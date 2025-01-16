"""
    drivers.jl

# Description
Driver functions and wrappers for experiments.
"""

using Distributed

# -----------------------------------------------------------------------------
# STRUCTS
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONSTRUCTORS
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# FUNCTIONS
# -----------------------------------------------------------------------------

exp_name = basename(@__FILE__)


"""
Parses the config dictionary to a parameters dictionary for use in a distributed simulation.
"""
function config_to_params(opts::ConfigDict)
    # Copy the options
    sim_params = deepcopy(opts)

    # Parse the varying parameters
    delete!(sim_params, "varying")
    for (key, value) in opts["varying"]
        sim_params[key] = collect(range(
            value["lb"],
            value["ub"],
            value["n_points"],
        ))
    end

    # Return the new dictionary
    return sim_params
end

function run_exp(
    name::AbstractString;
    # config_file::Union{AbstractString, Nothing}=nothing
    # config_file::Union{AbstractString, Nothing}=nothing
)
    pargs = dist_exp_parse(
        "$(name): CFAR experiment."
    )

    # Load the config as a dictionary
    opts = load_config(pargs["config_file"])

    # Start several processes
    pargs["procs"] = 0
    if pargs["procs"] > 0
        addprocs(pargs["procs"], exeflags="--project=.")
    end

    # Set the simulation parameters
    sim_params = config_to_params(opts)

    @everywhere begin
        @eval import Pkg
        Pkg.activate(".")
        @eval using Revise
        @eval using CFAR

        # Point to the sweep results
        sweep_results_dir(args...) = CFAR.results_dir(
            "1_gaussian",
            "2_art",
            "linear_sweep",
            args...
        )

    end

    return
end