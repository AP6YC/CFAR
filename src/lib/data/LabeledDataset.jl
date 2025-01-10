
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