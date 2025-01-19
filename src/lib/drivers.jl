"""
    drivers.jl

# Description
Driver functions and wrappers for experiments.
"""

# -----------------------------------------------------------------------------
# DEPENDENCIES
# -----------------------------------------------------------------------------

using Distributed

# -----------------------------------------------------------------------------
# STRUCTS
# -----------------------------------------------------------------------------

exp_name = basename(@__FILE__)

"""
Alias for an option of type `Union{AbstractString, Nothing}`.
"""
const OptionString = Union{AbstractString, Nothing}

# -----------------------------------------------------------------------------
# CONSTRUCTORS
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# FUNCTIONS
# -----------------------------------------------------------------------------

"""
Parses the config dictionary to a parameters dictionary for use in a distributed simulation.
"""
function config_to_params(
    opts::ConfigDict,
    pargs::Dict{String, Any}
)
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

    # Decide the true number of processes
    local_n_procs = if haskey(opts, "procs")
        opts["procs"]
    else
        pargs["procs"]
    end
    sim_params["procs"] = local_n_procs

    # Return the new dictionary
    return sim_params
end

# function start_procs(pargs::Dict{String, Any})
#     if pargs["procs"] > 0
#         addprocs(pargs["procs"], exeflags="--project=.")
#     end
# end

function load_opts(
    config_file::OptionString=nothing
)
    local_config_file = if isnothing(config_file)
        pargs["config_file"]
    else
        config_dir(config_file)
    end

    @info "Loaded config file $(local_config_file)"
    opts = load_config(local_config_file)

    return opts
end

function cvi_exp(opts::AbstractDict)
    # @eval local_opts = $sim_params
    # sweep_results_dir(args...) = CFAR.results_dir(
    #     opts["results"]...,
    #     args...
    # )
    # # Make the path
    # @info "Sweep results directory: $(sweep_results_dir())"
    # mkpath(sweep_results_dir())

    # @info results_dir()
    @info opts["results"]

    # sweep_results_dir = results_dir(opts["results"][1])
    # @info "Sweep results directory: $(sweep_results_dir)"
end

"""
Runs a distributed experiment.

# Arguments
- `name::AbstractString`: The name of the experiment.
"""
function run_exp(
    ;
    config_file::OptionString=nothing
    # config_file::Union{AbstractString, Nothing}=nothing
)
    @info "Parsing terminal arguments"
    pargs = dist_exp_parse("CFAR experiment.")

    # Load the configuration file
    @info "Loading configuration file"
    local_config_file = if isnothing(config_file)
        pargs["config_file"]
    else
        config_file
    end
    opts = load_opts(local_config_file)

    # Set the simulation parameters
    @info "Setting simulation parameters"
    sim_params = config_to_params(opts, pargs)

    # Start several processes
    if sim_params["procs"] > 1
        @info "Starting distributed processes"
        addprocs(sim_params["procs"] - 1, exeflags="--project=.")
    end

    # Load definitions on every process
    @info "Setting up processes experiment"
    @everywhere begin
        # @eval import Pkg
        # Pkg.activate(".")
        @eval using Revise
        @eval using CFAR

        # Point to the sweep results
        # @eval local_opts = $sim_params
        # sweep_results_dir(args...) = CFAR.results_dir(
        #     local_opts["results"]...,
        #     args...
        # )
        # # Make the path
        # @info "Sweep results directory: $(sweep_results_dir())"
        # mkpath(sweep_results_dir())
    end



    # Log the simulation scale
    @info "CFAR: $(dict_list_count(sim_params)) simulations across $(nprocs()) processes."

    # Turn the dictionary of lists into a list of dictionaries
    dicts = dict_list(sim_params)

    # Parallel map the sims
    pmap(cvi_exp, dicts)

    # Close the distributed workers
    if nworkers() > 1
        @info "Closing workers"
        rmprocs(workers())
    end

    return
end
