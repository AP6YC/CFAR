"""
    experiments.py

# Description
Experiment functions for the project.

# Authors
- Sasha Petrenko <petrenkos@mst.edu> @AP6YC
"""

"""
Loads the ART simulation options in the provided file with a default.

# Arguments
- `file::AbstractString`: the YAML file to load, default `$DEFAULT_ART_OPTS_FILE`.
"""
function load_art_sim_opts(file::AbstractString=DEFAULT_ART_OPTS_FILE)
    # Load the config as a dictionary
    opts_dict = load_config(file)

    # Parse the SFAM options
    dd = opts_dict["opts_SFAM"]

    # Instantiate the options
    opts = opts_SFAM(
        rho = dd["rho"],
    )

    # Overwrite the dictionary entry with the actual options
    opts_dict["opts_SFAM"] = opts

    # Return the config
    return opts_dict
end

"""
Loads the MLP simulation options in the provided file with a default.

# Arguments
- `file::AbstractString`: the YAML file to load, default `$DEFAULT_MLP_OPTS_FILE`.
"""
function load_mlp_sim_opts(file::AbstractString=DEFAULT_MLP_OPTS_FILE)
    # Load the config as a dictionary
    opts_dict = load_config(file)

    # Load the local mlp Python library
    mlp = get_mlp()

    # Put the library into the options dictionary for use in the experiment
    opts_dict["mlp"] = mlp

    # Return the loaded options
    return opts_dict
end

"""
Common save function for simulations.

# Arguments
$ARG_SIM_DIR_FUNC
$ARG_SIM_D
- `fulld::AbstractDict`: the dictionary containing the sim results.
"""
function save_sim(
    dir_func::Function,
    d::AbstractDict,
    fulld::AbstractDict,
)
    # Point to the correct save file for the results dictionary
    sim_save_name = dir_func(savename(d, "jld2"; digits=4))

    # Log completion of the simulation
    @info "Worker $(myid()): saving to $(sim_save_name)"

    # DrWatson function to save the results with an additional tag entry
    tagsave(sim_save_name, fulld)

    # Empty return
    return
end

"""
Train and test `SFAM` on the [`MoverSplit`](@ref) dataset in parallel.

# Arguments
$ARG_SIM_D
$ARG_SIM_MS
$ARG_SIM_DIR_FUNC
$ARG_SIM_OPTS
"""
function train_test_sfam_mc(
    d::AbstractDict,
    ms::MoverSplit,
    dir_func::Function,
    opts::AbstractDict,
)
    # Initialize the random seed at the beginning of the experiment
    Random.seed!(opts["rng_seed"])

    # Shift the local dataset by the prescribed amount
    local_ms = CFAR.shift_mover(ms, d["travel"])

    # Init the SFAM module
    art = SFAM(opts["opts_SFAM"])

    # Task 1: static gaussians
    train!(
        art,
        local_ms.static.train.x,
        local_ms.static.train.y,
    )

    # Task 1: classify
    yh1 = classify(
        art,
        local_ms.static.test.x,
    )

    # Task 1: performance
    p1 = performance(
        yh1,
        local_ms.static.test.y
    )

    # Task 2: moving gaussian
    train!(
        art,
        local_ms.mover.train.x,
        local_ms.mover.train.y,
    )

    # Task 2: classify
    yh2 = classify(
        art,
        local_ms.mover.test.x,
    )

    # Task 2: performance
    p2 = performance(
        yh2,
        local_ms.mover.test.y,
    )

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
    fulld = deepcopy(d)

    # Add entries for the results
    fulld["p1"] = p1
    fulld["p2"] = p2
    fulld["p12"] = p12
    # fulld["rho"] = opts["rho"]

    # Save the results
    save_sim(dir_func, d, fulld)

    # Empty return
    return
end

"""
Train and test SFAM in parallel.

# Arguments
$ARG_SIM_D
$ARG_SIM_MS
$ARG_SIM_DIR_FUNC
$ARG_SIM_OPTS
"""
function train_test_mlp_mc(
    d::AbstractDict,
    ms::MoverSplit,
    dir_func::Function,
    opts::AbstractDict,
)
    # Initialize the random seed at the beginning of the experiment
    Random.seed!(opts["rng_seed"])

    # Shift the local dataset by the prescribed amount
    local_ms = CFAR.shift_mover(ms, d["travel"])

    # Run the Python experiment
    # metrics = opts["mlp"].tt_ms_mlp(local_ms)
    metrics = opts["mlp"].tt_ms_mlp_l2(local_ms)

    # Unpack the metrics
    m1, m2, m12 = pyconvert(Vector{Any}, metrics)

    # Copy the input sim dictionary
    fulld = deepcopy(d)

    # Add entries for the results
    fulld["done"] = true
    fulld["p1"] = m1[2]
    fulld["p2"] = m2[2]
    fulld["p12"] = m12[2]
    # fulld["loss"] = loss
    # fulld["acc"] = acc
    # fulld["sc_acc"] = sc_acc
    # fulld["p1"] = p1
    # fulld["p2"] = p2
    # fulld["p12"] = p12

    # Save the results
    save_sim(dir_func, d, fulld)

    # Empty return
    return
end
