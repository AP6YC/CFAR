"""
    1_gen_scenario.jl

# Description
Generates the scenario and config files for l2logger and l2metrics experiments.
**NOTE** Must be run before any l2 experiments.

# Authors
- Sasha Petrenko <sap625@mst.edu>
"""

# -----------------------------------------------------------------------------
# PREAMBLE
# -----------------------------------------------------------------------------

using Revise
using CFAR

# -----------------------------------------------------------------------------
# OPTIONS
# -----------------------------------------------------------------------------

# Experiment save directory name
exp_top = "2_benchmarks"

# Load the vectorized datasets
data = CFAR.load_vec_datasets()

# Generate the scenarios
CFAR.gen_scenarios(data)
