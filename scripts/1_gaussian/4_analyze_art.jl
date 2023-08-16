"""
    4_analyze_art.jl

# Description
This script takes the results of the ART simulations and generates plots of their statistics.

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

using DrWatson      # collect_results!
using DataFrames

# -----------------------------------------------------------------------------
# OPTIONS
# -----------------------------------------------------------------------------

# This experiment name
exp_top = "1_gaussian"
exp_name = "4_analyze_art.jl"

perf_plot = "perf.png"
err_plot = "err.png"

# Point to the sweep results
sweep_dir = CFAR.results_dir(
    "1_gaussian",
    "2_art",
    "linear_sweep"
)

# -----------------------------------------------------------------------------
# PARSE ARGS
# -----------------------------------------------------------------------------

# Parse the arguments provided to this script
pargs = CFAR.exp_parse(
    "$(exp_top)/$(exp_name): analyze ART results."
)

# -----------------------------------------------------------------------------
# LOAD RESULTS
# -----------------------------------------------------------------------------

# Collect the results into a single dataframe
df = collect_results!(sweep_dir)
# df = collect_results(sweep_dir)

sort!(df, [:travel])

attrs = [
    "p1",
    "p2",
    "p12",
]

# Plot the average trendlines
p1 = CFAR.plot_2d_attrs(
    df,
    attrs,
    avg=true,
)
CFAR.save_plot(p1, perf_plot, exp_top, exp_name)

# Plot the StatsPlots error lines
p2 = CFAR.plot_2d_errlines(
    df,
    attrs,
    n=100,
)
CFAR.save_plot(p2, perf_plot, exp_top, exp_name)

@info "Done plotting for $(exp_name)"
