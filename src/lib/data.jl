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
Definition of features as a matrix of floating-point numbers of dimension (feature_dim, n_samples).
"""
const Features = ElasticMatrix{Float}
# const Features = Matrix{Float}

"""
Definition of targets as a vector of integers.
"""
const Targets = ElasticVector{Int}
# const Targets = Vector{Int}

"""
Definition of labels as a vector of strings.
"""
const Labels = ElasticVector{String}
# const Labels = Vector{String}

# -----------------------------------------------------------------------------
# TYPES
# -----------------------------------------------------------------------------

# struct

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

    """
    A vector of [`Targets`](@ref) corresponding to the [`Features`](@ref).
    """
    y::Vector{Targets}

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
function DataSplitCombined(data::LabeledDataset; p::Float=0.8)
    # Split the data
    train, test = split_data(data, p=p)
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
    features = data[:, 1:n_features]'
    labels = Vector{Int}(data[:, end])

    # Return the features and labels
    return features, labels
end

