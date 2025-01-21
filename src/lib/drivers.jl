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

    old_varying = pop!(sim_params, "varying")
    varying = Dict{String, Any}()

    # Parse the varying parameters
    # delete!(sim_params, "varying")
    # for (key, value) in opts["varying"]
    for (key, value) in old_varying
        varying[key] = collect(range(
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
    return sim_params, varying
end

# function start_procs(pargs::Dict{String, Any})
#     if pargs["procs"] > 0
#         addprocs(pargs["procs"], exeflags="--project=.")
#     end
# end

"""
Loads the options for the experiment, using the pargs config file if `nothing`` is provided.

# Arguments
- `config_file::OptionString`: The configuration file to load.
- `pargs::Dict{String, Any}`: The parsed arguments from the terminal.
"""
function load_opts(
    config_file::OptionString,
    pargs::Dict{String, Any},
)
    local_config_file = if isnothing(config_file)
        pargs["config_file"]
    else
        config_file
    end

    @info "Loaded config file $(local_config_file)"
    opts = load_config(local_config_file)

    return opts
end

"""
Runs a single CVI experiment, for use in a distributed simulation.
"""
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
    config = get_gaussian_config("gaussians.yml")
    ms = gen_gaussians(config)
    # @info sweep_results_dir()

    # sweep_results_dir = results_dir(opts["results"][1])
    # @info "Sweep results directory: $(sweep_results_dir)"
end

function art_exp(opts::AbstractDict)
    # Load the config dict
    config = CFAR.get_gaussian_config("gaussians.yml")
    ms = CFAR.gen_gaussians(config)

    # Load the simulation options
    # opts = CFAR.load_art_sim_opts("art.yml")

    # # Define the single-parameter function used for pmap
    # local_sim(dict) = CFAR.train_test_sfam_mc(
    #     dict,
    #     ms,
    #     sweep_results_dir,
    #     opts,
    # )

    # Initialize the random seed at the beginning of the experiment
    Random.seed!(opts["rng_seed"])

    # Shift the local dataset by the prescribed amount
    local_ms = CFAR.shift_mover(ms, opts["travel"])

    # Parse the SFAM options
    # dd = opts_dict["opts_SFAM"]

    # Instantiate the options
    # opts_SFAM(
    #     rho = dd["rho"],
    # )

    # Init the SFAM module
    art = SFAM(
        rho = opts["opts_SFAM"]["rho"]
    )
    art.config = AdaptiveResonance.DataConfig(
        opts["feature_bounds"]["min"],
        opts["feature_bounds"]["max"],
    )

    n_epochs = 5
    # Task 1: static gaussians
    for _ = 1:n_epochs
        train!(
            art,
            local_ms.static.train.x,
            local_ms.static.train.y,
        )
    end

    # Task 1: classify
    yh1 = classify(
        art,
        local_ms.static.test.x,
        get_bmu=true,
    )

    # Task 1: performance
    p1 = performance(
        yh1,
        local_ms.static.test.y
    )
    n_cats_1 = art.n_categories

    # Task 2: moving gaussian
    for _ = 1:n_epochs
        train!(
            art,
            local_ms.mover.train.x,
            local_ms.mover.train.y,
        )
    end

    # Task 2: classify
    yh2 = classify(
        art,
        local_ms.mover.test.x,
        get_bmu=true,
    )

    # Task 2: performance
    p2 = performance(
        yh2,
        local_ms.mover.test.y,
    )
    n_cats_2 = art.n_categories

    # Classify combined data
    yh12 = classify(
        art,
        hcat(
            local_ms.static.test.x,
            local_ms.mover.test.x,
        )
    )

    # Performance on both data
    p12 = performance(
        yh12,
        vcat(
            local_ms.static.test.y,
            local_ms.mover.test.y,
        )
    )

    # Copy the input sim dictionary
    fulld = deepcopy(opts)

    # Add entries for the results
    fulld["p1"] = p1
    fulld["p2"] = p2
    fulld["p12"] = p12
    fulld["nc1"] = n_cats_1
    fulld["nc2"] = n_cats_2
    # fulld["rho"] = opts["rho"]

    # Save the results
    dir_func(args...) = joinpath(opts["results"], args...)
    savename_opts = deepcopy(opts)
    delete!(savename_opts, "results")
    delete!(savename_opts, "name")
    delete!(savename_opts, "procs")
    @info savename_opts
    save_sim(dir_func, savename_opts, fulld)

end


# greet() = @info "Hello from $(myid())"

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
    opts = load_opts(config_file, pargs)

    # Set the simulation parameters
    @info "Setting simulation parameters"
    sim_params, varying = config_to_params(opts, pargs)

    sweep_results_dir = CFAR.results_dir(
        sim_params["results"]...
    )
    mkpath(sweep_results_dir)
    sim_params["results"] = sweep_results_dir

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
    @info "CFAR: $(dict_list_count(varying)) simulations across $(nprocs()) processes."

    # Turn the dictionary of lists into a list of dictionaries
    dicts = dict_list(varying)

    # Add the results directory back to the dictionaries
    new_dicts = Dict{String, Any}[]
    for ix in eachindex(dicts)
        push!(new_dicts, merge(dicts[ix], sim_params))
    end
    dicts = new_dicts

    # Parallel map the sims
    local_exp = eval(Symbol(sim_params["exp"]))
    pmap(local_exp, dicts)

    # Close the distributed workers
    if nprocs() > 1
        @info "Closing workers"
        rmprocs(workers())
    end

    return
end
