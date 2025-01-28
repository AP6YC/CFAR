"""
    cvi_analyze.jl

# Description
This script takes the results of the CVI simulations and generates plots of their statistics.

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

using DrWatson      # collect_results!
using DataFrames
using Plots

# -----------------------------------------------------------------------------
# OPTIONS
# -----------------------------------------------------------------------------

# This experiment name
exp_top = "1_gaussian"
exp_name = "cvi_analyze"

perf_plot = "perf.png"
err_plot = "err.png"

# Point to the sweep results
sweep_dir = CFAR.results_dir(
    "1_gaussian",
    "cvi",
)


# -----------------------------------------------------------------------------
# LOAD RESULTS
# -----------------------------------------------------------------------------

# Collect the results into a single dataframe
df = collect_results!(sweep_dir)
# df = collect_results(sweep_dir)

sort!(df, [:travel])


attrs = [
    "cvi",
]

# Plot the average trendlines
p1 = CFAR.plot_2d_attrs(
    df,
    attrs,
    avg=true,
    n=100,
    title="Silhouette CVI",
)
CFAR.save_plot(p1, perf_plot, exp_top, exp_name)


# Plot the StatsPlots error lines
p2 = CFAR.plot_2d_errlines(
    df,
    attrs,
    n=100,
    title="Silhouette CVI with 1-\\sigma Bars",
)
CFAR.save_plot(p2, err_plot, exp_top, exp_name)
