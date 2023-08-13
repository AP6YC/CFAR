"""
    5_analyze_mlp.jl

# Description
This script takes the results of the MLP simulations and generates plots of their statistics.

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
experiment = "5_analyze_mlp"

# Point to the sweep results
sweep_dir = CFAR.results_dir(
    "1_gaussian",
    "3_mlp",
    "linear_sweep"
)

# -----------------------------------------------------------------------------
# PARSE ARGS
# -----------------------------------------------------------------------------

# Parse the arguments provided to this script
pargs = CFAR.exp_parse(
    "$(experiment): analyze MLP results."
)

# -----------------------------------------------------------------------------
# LOAD RESULTS
# -----------------------------------------------------------------------------

# Collect the results into a single dataframe
df = collect_results!(sweep_dir)
# df = collect_results(sweep_dir)

# Sort by travel distance
sort!(df, [:travel])

# CFAR.plot_2d_perfs(df)

# attrs = [
#     # "acc",
#     # "loss",
#     # "sc_acc",
# ]

attrs = [
    "p1",
    "p2",
    "p12",
]

CFAR.plot_2d_attrs(
    df,
    attrs,
    avg=true,
    n=50,
)

CFAR.plot_2d_errlines(
    df,
    attrs,
    n=50,
)
