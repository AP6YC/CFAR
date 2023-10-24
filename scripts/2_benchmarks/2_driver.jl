"""
    2_driver.jl

# Description
Runs the l2 condensed scenario specified by the 1_gen_scenario.jl file.

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

using AdaptiveResonance
using PythonCall

# -----------------------------------------------------------------------------
# OPTIONS
# -----------------------------------------------------------------------------

# Experiment save directory name
experiment_top = "9_l2metrics"

# Load the l2logger PythonCall dependency
# l2logger = pyimport("l2logger.l2logger")
# il = pyimport("importlib")
# il.reload(l2logger)

# Why on Earth isn't this included in the PythonCall package?
PythonCall.Py(T::AbstractDict) = pydict(T)
PythonCall.Py(T::AbstractVector) = pylist(T)
PythonCall.Py(T::Symbol) = pystr(String(T))

# -----------------------------------------------------------------------------
# LOAD DATA
# -----------------------------------------------------------------------------

# Load the data
data = CFAR.load_vec_datasets()

# -----------------------------------------------------------------------------
# TRAIN/TEST
# -----------------------------------------------------------------------------

# Run the scenario
for (data_key, data_value) in data
    CFAR.full_scenario(
        data_value,
        CFAR.config_dir("l2", data_key),
    )
end
