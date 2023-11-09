"""
    data.jl

# Description
Definitions for the training and testing dataset containers for the project.

# Authors
- Sasha Petrenko <petrenkos@mst.edu> @AP6YC
"""

# -----------------------------------------------------------------------------
# ABSTRACT TYPES
# -----------------------------------------------------------------------------

"""
Abstract supertype for all train/test dataset structs in this library.
"""
abstract type TTDataset end

"""
Abstract type for data structs that represent features as matrices.
"""
abstract type MatrixData <: TTDataset end

"""
Abstract type for data structs that represent features as vectors of matrices.
"""
abstract type VectoredData <: TTDataset end

# -----------------------------------------------------------------------------
# ALIASES
# -----------------------------------------------------------------------------

"""
Alias declaring a sample as a vector of floating-point values.
"""
const Sample = Vector{Float}

"""
Alias declaring that a supervised target is an integer.
"""
const Target = Int

"""
Alias declaring that a sample batch is a vector of samples.
"""
const Samples = Vector{Sample}

"""
Alias declaring that a supervised label is a string.
"""
const Label = String

"""
Definition of features as a matrix of floating-point numbers of dimension (feature_dim, n_samples).
"""
const Features = Matrix{Float}
# const Features = ElasticMatrix{Float}

"""
Definition of targets as a vector of integers.
"""
const Targets = Vector{Target}
# const Targets = ElasticVector{Target}

"""
Definition of labels as a vector of strings.
"""
const Labels = Vector{Label}
# const Labels = ElasticVector{String}

# -----------------------------------------------------------------------------
# TYPES
# -----------------------------------------------------------------------------

"""
A single dataset of [`Features`](@ref), [`Targets`](@ref), and human-readable string [`Labels`](@ref).
"""
struct LabeledDataset
    """
    Collection of [`Features`](@ref) in the labeled dataset.
    """
    x::Features

    """
    [`Targets`](@ref) corresponding to the [`Features`](@ref).
    """
    y::Targets

    """
    Human-readable [`Labels`](@ref) corresponding to the [`Targets`](@ref) values.
    """
    labels::Labels
end

"""
A single dataset of vectored labeled data with [`Features`](@ref), [`Targets`](@ref), and human-readable string [`Labels`](@ref).
"""
struct VectorLabeledDataset
    """
    A vector of [`Features`](@ref) matrices.
    """
    x::Vector{Features}
    # x::Vector{Sample}

    """
    A vector of [`Targets`](@ref) corresponding to the [`Features`](@ref).
    """
    y::Vector{Targets}
    # y::Vector{Target}

    """
    String [`Labels`](@ref) corresponding to the [`Targets`](@ref).
    """
    labels::Labels
end

"""
A basic struct for encapsulating the components of supervised training.
"""
struct DataSplit <: MatrixData
    """
    Training [`LabeledDataset`](@ref).
    """
    train::LabeledDataset

    """
    Validation [`LabeledDataset`](@ref).
    """
    val::LabeledDataset

    """
    Test [`LabeledDataset`](@ref).
    """
    test::LabeledDataset
end

"""
A struct for encapsulating the components of supervised training in vectorized form.
"""
struct DataSplitIndexed <: VectoredData
    """
    Training [`VectorLabeledDataset`](@ref).
    """
    train::VectorLabeledDataset

    """
    Validation [`VectorLabeledDataset`](@ref).
    """
    val::VectorLabeledDataset

    """
    Test [`VectorLabeledDataset`](@ref).
    """
    test::VectorLabeledDataset
end

"""
DataSplitIndexedCombined

A struct for encapsulating the components of supervised training in vectorized form.
"""
struct DSIC <: VectoredData
    """
    Training [`VectorLabeledDataset`](@ref).
    """
    train::VectorLabeledDataset

    """
    Test [`VectorLabeledDataset`](@ref).
    """
    test::VectorLabeledDataset
end

"""
A struct for combining training and validation data, containing only train and test splits.
"""
struct DataSplitCombined <: MatrixData
    """
    Training [`LabeledDataset`](@ref).
    """
    train::LabeledDataset

    """
    Testing [`LabeledDataset`](@ref).
    """
    test::LabeledDataset
end

# -----------------------------------------------------------------------------
# CONSTRUCTORS
# -----------------------------------------------------------------------------


"""
Create a DSIC object from a DataSplitCombined.

# Arguments
- `data::DataSplitCombined`: the [`DataSplitCombined`](@ref) to separate into vectors of matrices.
"""
function DSIC(data::DataSplitCombined)
    # Assume the same number of classes in each category
    n_classes = length(unique(data.train.y))

    # Construct empty fields
    train_x = Vector{Matrix{Float}}()
    # train_x = Vector{Samples}()
    train_y = Vector{Targets}()
    train_labels = Labels()
    test_x = Vector{Matrix{Float}}()
    # test_x = Vector{Samples}()
    test_y = Vector{Targets}()
    test_labels = Labels()

    # Iterate over every class
    for i = 1:n_classes
        i_train = findall(x -> x == i, data.train.y)
        push!(train_x, data.train.x[:, i_train])
        push!(train_y, data.train.y[i_train])
        i_test = findall(x -> x == i, data.test.y)
        push!(test_x, data.test.x[:, i_test])
        push!(test_y, data.test.y[i_test])
    end

    # @info typeof(test_x)

    train_labels = data.train.labels
    test_labels = data.test.labels

    # Construct the indexed data split
    data_indexed = DSIC(
        VectorLabeledDataset(
            train_x,
            train_y,
            train_labels,
        ),
        VectorLabeledDataset(
            test_x,
            test_y,
            test_labels,
        ),
    )
    return data_indexed
end


"""
Teturns a manual train/test x/y split from a data matrix and labels using MLDataUtils.

# Arguments
- `data::RealMatrix`: the feature data to split into training and testing.
- `targets::IntegerVector`: the labels corresponding to the data to split into training and testing.
$ARG_P
"""
function get_manual_split(data::RealMatrix, targets::IntegerVector; p::Float=0.8)
    data_s, targets_s = shuffleobs((data, targets))
    # (X_train, y_train), (X_test, y_test) = splitobs((data, targets), at=p)
    (X_train, y_train), (X_test, y_test) = splitobs((data_s, targets_s), at=p)
    return (X_train, y_train), (X_test, y_test)
end

"""
Splits a [`LabeledDataset`](@ref) into two [`LabeledDataset`](@ref)s

# Arguments
- `data::LabeledDataset`: the original dataset to split.
$ARG_P
"""
function split_data(data::LabeledDataset; p::Float=0.8)
    (X_train, y_train), (X_test, y_test) = get_manual_split(
        data.x,
        data.y,
        p=p
    )
    train = LabeledDataset(
        X_train,
        y_train,
        data.labels
    )
    test = LabeledDataset(
        X_test,
        y_test,
        data.labels
    )
    return train, test
end

"""
Returns a [`DataSplitCombined`](@ref) from a [`LabeledDataset`](@ref) with a provided split ratio `p`.

# Arguments
- `data::LabeledDataset`: the original [`LabeledDataset`](@ref) to split into a [`DataSplitCombined`](@ref).
$ARG_P
"""
function DataSplitCombined(
    data::LabeledDataset;
    p::Float=0.8,
    normalize::Bool=true,
    scaling::Float=3.0,
)
    # Split the data
    train, test = split_data(data, p=p)

    if normalize
        # Get the distribution parameters for the training data
        dt = get_dist(train.x)

        # Preprocess all of the data based upon the statistics of the training data
        new_train_x = feature_preprocess(dt, scaling, train.x)
        new_test_x = feature_preprocess(dt, scaling, test.x)
        # train =
        train = LabeledDataset(
            new_train_x,
            train.y,
            train.labels,
        )
        test = LabeledDataset(
            new_test_x,
            test.y,
            test.labels,
        )
    end

    # Construct and return the dataset
    return DataSplitCombined(
        train,
        test
    )
end

"""
Definition of a split of data with one part remaining static and the other moving.
"""
struct MoverSplit
    """
    The static [`DataSplitCombined`](@ref).
    """
    static::DataSplitCombined

    """
    The moving [`DataSplitCombined`](@ref).
    """
    mover::DataSplitCombined

    """
    The config used to generate the mover.
    """
    config::ConfigDict
end

"""
Constructor for a [`MoverSplit`](@ref) taking a preconstructed static and mover [`LabeledDataset`](@ref)s along with a split parameter `p`.

# Arguments
- `static::LabeledDataset`: the static part of the dataset.
- `mover::LabeledDataset`: the moving part of the datset.
"""
function MoverSplit(
    static::LabeledDataset,
    mover::LabeledDataset,
    config::ConfigDict
)
    new_static = DataSplitCombined(static, p=config["split"])
    new_mover = DataSplitCombined(mover, p=config["split"])
    return MoverSplit(
        new_static,
        new_mover,
        config,
    )
end

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
Returns the concatenated training and testing features data from a [`DataSplitCombined`](@ref).

# Arguments
- `data::DataSplitCombined`: the [`DataSplitCombined`](@ref) to get the combined train/test features from.
"""
function get_x(data::DataSplitCombined)
    return hcat(
        data.train.x,
        data.test.x,
    )
end

"""
Returns the concatenated training and testing targets data from a [`DataSplitCombined`](@ref).

# Arguments
- `data::DataSplitCombined`: the [`DataSplitCombined`](@ref) to get the combined train/test targets from.
"""
function get_y(data::DataSplitCombined)
    return vcat(
        data.train.y,
        data.test.y,
    )
end

"""
Loads a local dataset.

# Arguments
- `filename::AbstractString`: the location of the file to load with a default value.
"""
function load_dataset(
    filename::AbstractString,
)
    # Load the data
    data = readdlm(filename, ',', header=false)

    # Get the number of features
    n_features = size(data)[2] - 1

    # Get the features and labels
    # features = data[:, 1:n_features]'
    features = permutedims(data[:, 1:n_features])
    labels = Vector{Int}(data[:, end])

    # Return the features and labels
    return features, labels
end

"""
Returns the sigmoid function on x.

# Arguments
- `x::Real`: the float or int to compute the sigmoid function upon.
"""
function sigmoid(x::Real)
    return one(x) / (one(x) + exp(-x))
end

"""
Get the distribution parameters for preprocessing.

# Arguments
- `data::RealMatrix`: a 2-D matrix of features for computing the Gaussian statistics of.
"""
function get_dist(data::RealMatrix)
    return fit(ZScoreTransform, data, dims=2)
end

"""
Preprocesses one dataset of features, scaling and squashing along the feature axes.

# Arguments
- `dt::ZScoreTransform`: the Gaussian statistics of the features.
- `scaling::Real`: the sigmoid scaling parameter.
- `data::RealMatrix`: the 2-D matrix of features to transform.
"""
function feature_preprocess(dt::ZScoreTransform, scaling::Real, data::RealMatrix)
    # Normalize the dataset via the ZScoreTransform
    new_data = StatsBase.transform(dt, data)
    # Squash the data sigmoidally with the scaling parameter
    new_data = sigmoid.(scaling*new_data)
    # Return the normalized and scaled data
    return new_data
end

"""
Loads all of the data sets from the local data package folder.

# Arguments
- `topdir::AbstractString = data_dir("data-package")`:
"""
function load_datasets(
    topdir::AbstractString = data_dir("data-package"),
    # scaling::Real=3.0,
)
    # datasets = Dict{String, Any}()
    datasets = Dict{String, LabeledDataset}()
    for (root, _, files) in walkdir(topdir)
        # Iterate over all of the files
        for file in files
            # Get the full filename for the current data file
            filename = joinpath(root, file)
            # Load the dataset
            data = CFAR.load_dataset(filename)
            # Get the data name from the filename
            data_name = splitext(file)[1]
            # datasets[data_name] = data

            local_data = LabeledDataset(
                # train_x,
                # test_x
                data[1],
                data[2],
                string.(unique(data[2])),
            )
            datasets[data_name] = local_data
            # @info data
            # @info "Loaded $file"
        end
    end
# DataSplitCombined
    return datasets

end

"""
Constructor for a [`VectorLabeledDataset`](@ref) transformed from an existing [`LabeledDataset`](@ref).

# Arguments
- `data::LabeledDataset`: the [`LabeledDataset`](@ref) to turn into a corresponding vectorized version.
"""
function VectorLabeledDataset(
    data::LabeledDataset
)
    n_samples = length(data.y)
    x_vec = Vector{Vector{Float}}()
    # y_vec = Vector{Int}()
    for ix = 1:n_samples
        push!(x_vec, data.x[:, ix])
        # push!(y_vec, data.y[ix])
    end

    return VectorLabeledDataset(
        x_vec,
        # y_vec,
        data.y,
        data.labels,
    )
end

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
