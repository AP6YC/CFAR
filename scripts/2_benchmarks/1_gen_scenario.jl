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

# CFAR.gen_scenario("ring", data["ring"])
CFAR.gen_scenarios(data)

# # -----------------------------------------------------------------------------
# # OPTIONS
# # -----------------------------------------------------------------------------

# # CFAR project files
# # include(projectdir("src", "setup.jl"))

# # Special folders for this experiment
# # include(CFAR.projectdir("src", "setup_l2.jl"))

# # Point to config and scenario files
# config_file = configs_dir(exp_top, "config.json")
# scenario_file = configs_dir(exp_top, "scenario.json")

# # -----------------------------------------------------------------------------
# # CONFIG FILE
# # -----------------------------------------------------------------------------

# DIR = CFAR.results_dir(exp_top, "logs")
# # NAME = "9_l2metrics_logger"
# NAME = exp_top
# COLS = Dict(
#     # "metrics_columns" => "reward",
#     "metrics_columns" => [
#         "performance",
#         "art_match",
#         "art_activation",
#     ],
#     "log_format_version" => "1.0",
# )
# META = Dict(
#     "author" => "Sasha Petrenko",
#     "complexity" => "1-low",
#     "difficulty" => "2-medium",
#     "scenario_type" => "custom",
# )

# # Create the config dict
# config_dict = Dict(
#     "DIR" => DIR,
#     "NAME" => NAME,
#     "COLS" => COLS,
#     "META" => META,
# )

# # Write the config file
# CFAR.json_save(config_file, config_dict)

# # -----------------------------------------------------------------------------
# # SCENARIO FILE
# # -----------------------------------------------------------------------------

# # Load the default data configuration
# # data, data_indexed, class_labels, data_selection, n_classes = CFAR.load_default_orbit_data(data_dir)

# # Build the scenario vector
# SCENARIO = []
# for ix = 1:n_classes
#     # Create a train step and push
#     train_step = Dict(
#         "type" => "train",
#         "regimes" => [Dict(
#             # "task" => class_labels[ix],
#             "task" => data_selection[ix],
#             "count" => length(data_indexed.train.y[ix]),
#         )],
#     )
#     push!(SCENARIO, train_step)

#     # Create all test steps and push
#     regimes = []
#     for jx = 1:n_classes
#         local_regime = Dict(
#             # "task" => class_labels[jx],
#             "task" => data_selection[jx],
#             "count" => length(data_indexed.test.y[jx]),
#         )
#         push!(regimes, local_regime)
#     end

#     test_step = Dict(
#         "type" => "test",
#         "regimes" => regimes,
#     )

#     push!(SCENARIO, test_step)

#     # # Create all test steps and push
#     # for jx = 1:n_classes
#     #     test_step = Dict(
#     #         "type" => "test",
#     #         "regimes" => [Dict(
#     #             "task" => class_labels[jx],
#     #             "count" => length(data_indexed.test_y[jx]),
#     #         )],
#     #     )
#     #     push!(SCENARIO, test_step)
#     # end
# end

# # Make scenario list into a dict entry
# scenario_dict = Dict(
#     "scenario" => SCENARIO,
# )

# # Save the scenario
# CFAR.json_save(scenario_file, scenario_dict)
