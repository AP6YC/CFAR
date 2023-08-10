"""
    3_mlp.jl

# Description
Trains and tests an MLP in Python.

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

# -----------------------------------------------------------------------------
# PARSE ARGS
# -----------------------------------------------------------------------------

# Parse the arguments provided to this script
pargs = CFAR.dist_exp_parse(
    "1_gaussian/3_mlp: MLP on the Gaussian dataset."
)

pargs["procs"] = 4

# Start several processes
if pargs["procs"] > 0
    addprocs(pargs["procs"], exeflags="--project=.")
end

# Set the simulation parameters
sim_params = Dict{String, Any}(
    "m" => "mlp",
    "travel" => collect(range(0, 10, 10))
)

# -----------------------------------------------------------------------------
# PARALLEL DEFINITIONS
# -----------------------------------------------------------------------------

using PythonCall

PythonCall.GC.disable()

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
        "3_mlp",
        "linear_sweep",
        args...
    )

    # Load the config dict
    config = CFAR.get_gaussian_config("gaussians.yml")
    ms = CFAR.gen_gaussians(config)

    # Load the MLP simulation options
    opts = CFAR.load_mlp_sim_opts()

    # Make the path
    mkpath(sweep_results_dir())

    # Define the single-parameter function used for pmap
    local_sim(dict) = CFAR.train_test_mlp_mc(
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
@info "START: $(dict_list_count(sim_params)) simulations across $(nprocs()) processes."

# Turn the dictionary of lists into a list of dictionaries
dicts = dict_list(sim_params)

# Parallel map the sims
pmap(local_sim, dicts)
# progress_pmap(local_sim, dicts)

PythonCall.GC.enable()

# -----------------------------------------------------------------------------
# CLEANUP
# -----------------------------------------------------------------------------

# Close the workers after simulation
if pargs["procs"] > 0
    rmprocs(workers())
end

println("--- Simulation complete ---")

# -----------------------------------------------------------------------------
# ADDITIONAL DEPENDENCIES
# -----------------------------------------------------------------------------

# using PythonCall

# mlp = pyimport("mlp")
# il = pyimport("importlib")
# il.reload(mlp)

# tf = pyimport("tensorflow")
# tf.config.list_physical_devices("CPU")
# tf.test.is_built_with_cuda()

# # -----------------------------------------------------------------------------
# # EXPERIMENT
# # -----------------------------------------------------------------------------

# # Load the config dict
# config = CFAR.get_gaussian_config("gaussians.yml")
# ms = CFAR.gen_gaussians(config)

# # mlp.show_data_shape(ms)
# # loss, acc = mlp.examine_data(ms)
# metrics = mlp.tt_ms_mlp(ms)
# loss, acc, sc_acc = metrics

