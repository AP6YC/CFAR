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

l2logger = pyimport("l2logger.l2logger")
il = pyimport("importlib")
il.reload(l2logger)
# DCCR project files
# include(projectdir("src", "setup.jl"))

# Special l2 setup for this experiment (setting the pyenv, etc.)
# include(DCCR.projectdir("src", "setup_l2.jl"))

# Load the l2logger PyCall dependency
# l2logger = pyimport("l2logger.l2logger")

# Load the config and scenario
config = CFAR.json_load(CFAR.config_dir("l2", "iris", "config.json"))
scenario = CFAR.json_load(CFAR.config_dir("l2", "iris", "scenario.json"))

# -----------------------------------------------------------------------------
# LOAD DATA
# -----------------------------------------------------------------------------

# Load the default data configuration
# data, data_indexed, class_labels, data_selection, n_classes = load_default_orbit_data(data_dir)
data = CFAR.load_vec_datasets()

# -----------------------------------------------------------------------------
# EXPERIMENT
# -----------------------------------------------------------------------------

# Setup the scenario_info dictionary as a function of the config and scenario
scenario_info = config["META"]
scenario_info["input_file"] = scenario

# config["COLS"]["metrics_columns"] = Vector{String}(config["COLS"]["metrics_columns"])

new_cols = pydict(config["COLS"])
new_cols["metrics_columns"] = pylist(new_cols["metrics_columns"])

# Why on Earth isn't this included in the PythonCall package?
Py(T::Dict) = pydict(T)
Py(T::AbstractVector) = pylist(T)

# Instantiate the data logger
data_logger = l2logger.DataLogger(
    config["DIR"],
    config["NAME"],
    config["COLS"],     # This one right here, officer
    scenario_info,
)

# g = Dict{Any, Any}("asdf" => ["as", "poiu", "bb"], "bb" => "ppoiu")
g = Dict("asdf" => ["as", "poiu", "bb"], "bb" => "ppoiu")

# Create the DDVFA options for both initialization and logging
ddvfa_opts = opts_DDVFA(
    # DDVFA options
    gamma = 5.0,
    gamma_ref = 1.0,
    # rho=0.45,
    rho_lb = 0.45,
    rho_ub = 0.7,
    similarity = :single,
    display = false,
)

local_art = DDVFA(ddvfa_opts)

# Specify the input data configuration
local_art.config = DataConfig(0, 1, 128)

# Construct the agent from the scenario
agent = Agent(
    local_art,
    ddvfa_opts,
    scenario,
)



# -----------------------------------------------------------------------------
# TRAIN/TEST
# -----------------------------------------------------------------------------

# Run the scenario
# run_scenario(agent, data_indexed, data_logger)
