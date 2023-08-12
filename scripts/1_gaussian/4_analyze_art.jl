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
experiment = "2a_analyze_art"

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
    "$(experiment): analyze ART results."
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

# CFAR.plot_2d_perfs(df)
CFAR.plot_2d_attrs(
    df,
    attrs,
    avg=true,
)
