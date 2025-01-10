"""
    data.jl

# Description
Definitions for the training and testing dataset containers for the project.

# Authors
- Sasha Petrenko <petrenkos@mst.edu> @AP6YC
"""


include(joinpath("data", "lib.jl"))



# -----------------------------------------------------------------------------
# CONSTRUCTORS
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# FUNCTIONS
# -----------------------------------------------------------------------------

# """
# Internal function for handling how to show [`TTDataset`](@ref)s.
# """
# function _show_datasplit(io::IO, data::TTDataset, dim::Int)
#     # Get the number of samples in each split
#     n_train = length(data.train_y)
#     n_test = length(data.test_y)

#     # Print
#     print(io, "$(typeof(data)): dim=$(dim), n_train=$(n_train), n_test=$(n_test):\n")
#     print(io, "train_x: $(size(data.train_x)) $(typeof(data.train_x))\n")
#     print(io, "test_x: $(size(data.test_x)) $(typeof(data.test_x))\n")
#     print(io, "train_y: $(size(data.train_y)) $(typeof(data.train_y))\n")
#     print(io, "test_y: $(size(data.test_y)) $(typeof(data.test_y))\n")

#     # Empty return
#     return
# end

# """
# Overload of the show function for [`DataSplit`](@ref).

# # Arguments
# - `io::IO`: the current IO stream.
# - `data::DataSplit`: the [`DataSplit`](@ref) to print/display.
# """
# function Base.show(io::IO, data::DataSplit)
#     # Get the feature dimension for datasplits
#     dim = size(data.train_x)[1]

#     # Show the common attributes of the datasplit
#     _show_datasplit(io, data, dim)

#     # Empty return
#     return
# end



"""
Splits the provided [`LabeledDataset`](@ref)s into train/test splits with a provided ratio `p`.

# Argument
- `datasets::Dict{String, LabeledDataset}`: a named mapping to a set of [`LabeledDataset`](@ref)s.
$ARG_P
"""
function split_datasets(
    datasets::Dict{String, LabeledDataset};
    p::Float=0.8
)
    new_datasets = Dict{String, DataSplitCombined}()
    for (key, value) in datasets
        new_datasets[key] = DataSplitCombined(value; p=p)
    end

    return new_datasets

end

# """

# """
# function vectorize_datasets(
#     datasets::Dict{String, LabeledDataset}
# )

#     vec_datasets = Dict{String, VectorLabeledDataset}()
#     for (key, value) in datasets
#         vec_datasets[key] = VectorLabeledDataset(value)
#     end

#     return vec_datasets
# end

"""
Turns a named set of [`DataSplitCombined`](@ref)s into vectorized [`DSIC`](@ref) datasets.

# Arguments
- `datasets::Dict{String, DataSplitCombined}`: the named set of [`DataSplitCombined`](@ref)s to turn into corresponding vectorized [`DSIC`](@ref).
"""
function vectorize_datasets(
    datasets::Dict{String, DataSplitCombined}
)
    vec_datasets = Dict{String, DSIC}()
    for (key, value) in datasets
        vec_datasets[key] = DSIC(value)
    end

    return vec_datasets
end

"""

"""
function load_vec_datasets(
    p::Float=0.8,
    seed::Real=1,
)
    datasets = CFAR.load_datasets()

    Random.seed!(seed)
    new_datasets = CFAR.split_datasets(datasets; p=p)

    dsic = CFAR.vectorize_datasets(new_datasets)

    return dsic
end

"""
Vector of alphabetical letters as Strings for discretized feature labels.
"""
const ALPHABET = string.(collect('A':'Z'))

"""
Two-letter alphabetical feature names.
"""
const LETTER_VEC = reduce(vcat, [letter .* ALPHABET for letter in ALPHABET])

"""
Generates a configuration and scenario from a dataset.

# Arguments
- `exp_top::AbstractString`:
"""
function gen_scenario(
    exp_top::AbstractString,
    data_indexed::DSIC,
)
    # Point to config and scenario files
    exp_dir = config_dir("l2", exp_top)
    mkpath(exp_dir)
    config_file = config_dir("l2", exp_top, "config.json")
    scenario_file = config_dir("l2", exp_top, "scenario.json")

    # -----------------------------------------------------------------------------
    # CONFIG FILE
    # -----------------------------------------------------------------------------

    DIR = CFAR.results_dir("l2", exp_top, "logs")
    # NAME = "9_l2metrics_logger"
    NAME = exp_top
    COLS = Dict(
        # "metrics_columns" => "reward",
        "metrics_columns" => [
            "performance",
            "art_match",
            "art_activation",
        ],
        "log_format_version" => "1.0",
    )
    META = Dict(
        "author" => "Sasha Petrenko",
        "complexity" => "1-low",
        "difficulty" => "2-medium",
        "scenario_type" => "custom",
    )

    # Create the config dict
    config_dict = Dict(
        "DIR" => DIR,
        "NAME" => NAME,
        "COLS" => COLS,
        "META" => META,
    )

    # Write the config file
    CFAR.json_save(config_file, config_dict)

    # -----------------------------------------------------------------------------
    # SCENARIO FILE
    # -----------------------------------------------------------------------------

    # Load the default data configuration
    # data, data_indexed, class_labels, data_selection, n_classes = CFAR.load_default_orbit_data(data_dir)

    # Build the scenario vector
    SCENARIO = []
    n_classes = length(data_indexed.train.labels)

    for ix = 1:n_classes
        # Create a train step and push
        train_step = Dict(
            "type" => "train",
            "regimes" => [Dict(
                # "task" => class_labels[ix],
                # "task" => data_selection[ix],
                "task" => data_indexed.train.labels[ix],
                # "task" => alphabet[parse(Int, data_indexed.train.labels[ix])],
                "count" => length(data_indexed.train.y[ix]),
            )],
        )
        push!(SCENARIO, train_step)

        # Create all test steps and push
        regimes = []
        for jx = 1:n_classes
            local_regime = Dict(
                # "task" => class_labels[jx],
                # "task" => data_selection[jx],
                "task" => data_indexed.test.labels[jx],
                # "task" => alphabet[parse(Int, data_indexed.test.labels[jx])],
                "count" => length(data_indexed.test.y[jx]),
            )
            push!(regimes, local_regime)
        end

        test_step = Dict(
            "type" => "test",
            "regimes" => regimes,
        )

        push!(SCENARIO, test_step)

        # # Create all test steps and push
        # for jx = 1:n_classes
        #     test_step = Dict(
        #         "type" => "test",
        #         "regimes" => [Dict(
        #             "task" => class_labels[jx],
        #             "count" => length(data_indexed.test_y[jx]),
        #         )],
        #     )
        #     push!(SCENARIO, test_step)
        # end
    end

    # Make scenario list into a dict entry
    scenario_dict = Dict(
        "scenario" => SCENARIO,
    )

    # Save the scenario
    CFAR.json_save(scenario_file, scenario_dict)

end

"""
Generates all L2 scenarios as inferred from an existing named set of [`DSIC`](@ref) datasets.

# Arguments
- `data::Dict{String, DSIC}`: the named set of [`DSIC`](@ref) datasets to use for generating scenario files.
"""
function gen_scenarios(
    data::Dict{String, DSIC}
)
    for (key, value) in data
        gen_scenario(key, value)
    end
end
