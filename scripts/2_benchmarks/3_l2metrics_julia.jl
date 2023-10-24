"""
    3_l2metrics.jl

# Description
Runs the l2metrics on the latest logs from within Julia.

# Authors
- Sasha Petrenko <sap625@mst.edu>
"""

# -----------------------------------------------------------------------------
# PREAMBLE
# -----------------------------------------------------------------------------

using Revise
using CFAR

# -----------------------------------------------------------------------------
# ADDITIONAL DEPENDENCIES
# -----------------------------------------------------------------------------

using PythonCall
using CondaPkg

# -----------------------------------------------------------------------------
# OPTIONS
# -----------------------------------------------------------------------------

# Experiment save directory name
experiment_top = "2_benchmarks"
log_dir_name = "logs"
metrics_dir_name = "l2metrics"
# conda_env_name = "l2mmetrics"

# Declare all of the metrics being calculated
metrics = [
    "performance",
    "art_match",
    "art_activation",
]

# -----------------------------------------------------------------------------
# GENERATE METRICS
# -----------------------------------------------------------------------------

top_dir = CFAR.results_dir("l2")

# for (root, dir, files) in walkdir(top_dir)
for dir in readdir(top_dir, join=true)
    # Get the most recent log directory name
    # last_log = readdir(CFAR.results_dir(experiment_top, log_dir_name))[end]
    # @info last_log
    last_log_folder = readdir(joinpath(dir, log_dir_name))[end]
    last_log = readdir(joinpath(dir, log_dir_name), join=true)[end]

    # @info dir
    # # Set the full source and output directories
    # src_dir(args...) = CFAR.results_dir(experiment_top, log_dir_name, last_log, args...)
    # out_dir(args...) = CFAR.results_dir(experiment_top, metrics_dir_name, last_log, args...)
    src_dir = last_log
    out_dir(args...) = joinpath(dir, metrics_dir_name, last_log_folder)
    @info out_dir()
    # Iterate over every metric
    for metric in metrics
        CondaPkg.withenv() do
            python = CondaPkg.which("python")
            # run(`cmd /c activate $conda_env_name \&\& python -m l2metrics -p $metric -o $metric -O $(out_dir(metric)) -l $(src_dir())`)
            # @info src_dir
            run(`$python -m l2metrics -p $metric -o $metric -O $(out_dir(metric)) -l $(src_dir)`)
            # @info python
        end
    end
end
