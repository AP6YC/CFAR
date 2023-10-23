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
l2logger = pyimport("l2logger.l2logger")
il = pyimport("importlib")
il.reload(l2logger)

# Load the config and scenario
config = CFAR.json_load(CFAR.config_dir("l2", "iris", "config.json"))
scenario = CFAR.json_load(CFAR.config_dir("l2", "iris", "scenario.json"))

# -----------------------------------------------------------------------------
# LOAD DATA
# -----------------------------------------------------------------------------

# Load the data
data = CFAR.load_vec_datasets()

# -----------------------------------------------------------------------------
# EXPERIMENT
# -----------------------------------------------------------------------------

# Setup the scenario_info dictionary as a function of the config and scenario
scenario_info = config["META"]
scenario_info["input_file"] = scenario

# Why on Earth isn't this included in the PythonCall package?
PythonCall.Py(T::AbstractDict) = pydict(T)
PythonCall.Py(T::AbstractVector) = pylist(T)
PythonCall.Py(T::Symbol) = pystr(String(T))

# Instantiate the data logger
data_logger = l2logger.DataLogger(
    config["DIR"],
    config["NAME"],
    config["COLS"],     # This one right here, officer
    scenario_info,
)

# Create the DDVFA options for both initialization and logging
opts = opts_DDVFA(
    # DDVFA options
    gamma = 5.0,
    gamma_ref = 1.0,
    # rho=0.45,
    rho_lb = 0.45,
    rho_ub = 0.7,
    similarity = :single,
    display = false,
)

local_art = DDVFA(opts)

# Specify the input data configuration
local_art.config = DataConfig(0, 1, 4)

# Construct the agent from the scenario
agent = CFAR.Agent(
    local_art,
    opts,
    scenario,
)

# -----------------------------------------------------------------------------
# TRAIN/TEST
# -----------------------------------------------------------------------------

# Run the scenario
# for (key, value) in data
CFAR.run_scenario(agent, data["iris"], data_logger)
# end