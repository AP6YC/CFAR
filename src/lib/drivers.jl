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

function get_mover_data(
    opts::AbstractDict;
    config_file::AbstractString="gaussians.yml"
)
    # Load the config dict
    config = CFAR.get_gaussian_config(config_file)

    # Initialize the random seed at the beginning of the experiment
    Random.seed!(Int(opts["rng_seed"]))

    ms = if config_file == "gaussians.yml"
        ms = CFAR.gen_gaussians(config)
    else
        CFAR.gen_sct_gaussians(config)
    end

    # Shift the local dataset by the prescribed amount
    local_ms = CFAR.shift_mover(ms, opts["travel"])

    return local_ms
end

"""
Runs a single CVI experiment, for use in a distributed simulation.
"""
function cvi_exp(opts::AbstractDict)
    # @info opts["results"]
    local_ms = get_mover_data(opts, config_file="sct-gaussians.yml")
    local_ds = DataSplitCombined(local_ms)
    csil = ClusterValidityIndices.cSIL()
    cvi = get_cvi!(csil, local_ds.train.x, local_ds.train.y)
    @info cvi

    # Copy the input sim dictionary
    fulld = deepcopy(opts)

    # Add entries for the results
    # fulld["nc2"] = n_cats_2
    # # fulld["rho"] = opts["rho"]
    fulld["cvi"] = cvi

    # Save the results
    dir_func(args...) = joinpath(opts["results"], args...)
    savename_opts = deepcopy(opts)
    delete!(savename_opts, "results")
    delete!(savename_opts, "name")
    delete!(savename_opts, "procs")

    @info savename_opts
    save_sim(dir_func, savename_opts, fulld)
end

function art_exp(opts::AbstractDict)
    # Load the data according to the options
    local_ms = get_mover_data(opts)

    # Init the SFAM module
    art = SFAM(
        rho = opts["opts_SFAM"]["rho"]
    )
    art.config = AdaptiveResonance.DataConfig(
        opts["feature_bounds"]["min"],
        opts["feature_bounds"]["max"],
    )

    n_epochs = opts["n_epochs"]

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

    # @info savename_opts
    save_sim(dir_func, savename_opts, fulld)

end


function art_dist_exp(opts::AbstractDict)
    # Load the data according to the options
    # local_ms = get_mover_data(opts)
    local_ms = get_mover_data(opts, config_file="sct-gaussians.yml")
    # local_ds = DataSplitCombined(local_ms)

    # Init the SFAM module
    art = SFAM(
        rho = opts["opts_SFAM"]["rho"]
    )
    art.config = AdaptiveResonance.DataConfig(
        opts["feature_bounds"]["min"],
        opts["feature_bounds"]["max"],
    )

    n_epochs = opts["n_epochs"]

    # Copy the input sim dictionary
    fulld = deepcopy(opts)

    # Task 1: static gaussians
    n_tasks = length(local_ms.data)
    for ix in 1:n_tasks
        for _ = 1:n_epochs
            train!(
                art,
                local_ms.data[ix].train.x,
                local_ms.data[ix].train.y,
            )
        end

        # Task 1: classify
        y_hat = classify(
            art,
            local_ms.data[ix].test.x,
            get_bmu=true,
        )

        # Task 1: performance
        perf = performance(
            y_hat,
            local_ms.data[ix].test.y
        )
        n_cats = art.n_categories

        fulld["p$(ix)"] = perf
        fulld["nc$(ix)"] = n_cats
    end

    # Save the results
    dir_func(args...) = joinpath(opts["results"], args...)
    savename_opts = deepcopy(opts)
    delete!(savename_opts, "results")
    delete!(savename_opts, "name")
    delete!(savename_opts, "procs")

    # @info savename_opts
    save_sim(dir_func, savename_opts, fulld)
end

# function analyze_arg_exp(opts::AbstractDict)

#     # This experiment name
#     exp_top = "1_gaussian"
#     exp_name = "4_analyze_art"

#     perf_plot = "perf.png"
#     err_plot = "err.png"
#     n_cats_plot = "n_categories.png"

#     sweep_dir = opts["results"]

#     # LOAD RESULTS

#     # Collect the results into a single dataframe
#     df = collect_results!(sweep_dir)
#     # df = collect_results(sweep_dir)

#     sort!(df, [:travel])

#     attrs = [
#         "p1",
#         "p2",
#         "p12",
#     ]

#     # Plot the average trendlines
#     p1 = CFAR.plot_2d_attrs(
#         df,
#         attrs,
#         avg=true,
#         n=100,
#         title="Peformances",
#     )
#     CFAR.save_plot(p1, perf_plot, exp_top, exp_name)

#     # Plot the StatsPlots error lines
#     p2 = CFAR.plot_2d_errlines(
#         df,
#         attrs,
#         n=100,
#         title="Performances with Error Bars",
#     )
#     CFAR.save_plot(p2, err_plot, exp_top, exp_name)

#     # Plot the number of categories
#     p3= CFAR.plot_2d_attrs(
#         df,
#         ["nc1", "nc2"],
#         avg=true,
#         n=200,
#         title="Number of Categories",
#     )
#     CFAR.save_plot(p3, n_cats_plot, exp_top, exp_name)

#     @info "Done plotting for $(exp_name)"
# end

"""
Runs a distributed experiment.

# Arguments
- `config_file::OptionString`: The configuration file to load.
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

        # Load definitions on every process
        @info "Setting up processes dependencies"
        @everywhere begin
            # @eval import Pkg
            # Pkg.activate(".")
            @eval using Revise
            @eval using CFAR
        end
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
