"""
    data.jl

# Description
Definitions for the training and testing dataset containers for the project.
"""

# -----------------------------------------------------------------------------
# ABSTRACT TYPES
# -----------------------------------------------------------------------------

"""
Abstract supertype for all Data structs in this library.
"""
abstract type Data end

"""
Abstract type for Data structs that represent features as matrices.
"""
abstract type MatrixData <: Data end

"""
Abstract type for Data structs that represent features as vectors of matrices.
"""
abstract type VectoredData <: Data end

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

"""
Teturns a manual train/test x/y split from a data matrix and labels using MLDataUtils.

# Arguments
- `data::RealMatrix`: the feature data to split into training and testing.
- `targets::IntegerVector`: the labels corresponding to the data to split into training and testing.
$ARG_P
"""
function get_manual_split(data::RealMatrix, targets::IntegerVector; p::Float=0.8)
    (X_train, y_train), (X_test, y_test) = splitobs((data, targets), at=p)
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
    train, test = split_data(data, p=p)
    return DataSplitCombined(
        train,
        test
    )
end

"""
Definition of a split of data with one part remaining static and the other moving.
"""
struct MoverSplit <: MatrixData
    """
    The static [`DataSplitCombined`](@ref).
    """
    static::DataSplitCombined

    """
    The moving [`DataSplitCombined`](@ref).
    """
    mover::DataSplitCombined
end

"""
Constructor for a [`MoverSplit`](@ref) taking a preconstructed static and mover [`LabeledDataset`](@ref)s along with a split parameter `p`.
"""
function MoverSplit(static::LabeledDataset, mover::LabeledDataset; p::Float=0.8)
    new_static = DataSplitCombined(static, p=p)
    new_mover = DataSplitCombined(mover, p=p)
    return MoverSplit(
        new_static,
        new_mover,
    )
end

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

# -----------------------------------------------------------------------------
# FUNCTIONS
# -----------------------------------------------------------------------------

# """
# A constructor for a [`LabeledDataset`](@ref) that merges two other [`LabeledDataset`](@ref)s.

# # Arguments
# - `d1::LabeledDataset`: the first [`LabeledDataset`](@ref) to consolidate.
# - `d2::LabeledDataset`: the second [`LabeledDataset`](@ref) to consolidate.
# """
# function LabeledDataset(d1::LabeledDataset, d2::LabeledDataset)
#     # Consolidate everything and construct in one step
#     return LabeledDataset(
#         hcat(d1.x, d2.x),
#         vcat(d1.y, d2.y),
#         vcat(d1.labels, d2.labels),
#     )
# end

# """
# Constructs a DataSplitCombined from an existing DataSplit by consolidating the training and validation data.

# # Arguments
# - `data::DataSplit`: the [`DataSplit`](@ref) struct for consolidating validation [`Features`](@ref) and [`Labels`](@ref) into the training data.
# """
# function DataSplitCombined(data::DataSplit)
#     # Consolidate training and validation, and return the struct in one step
#     return DataSplitCombined(
#         LabeledDataset(data.train, data.val),
#         data.test,
#     )
# end

