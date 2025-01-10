
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


# -----------------------------------------------------------------------------
# FUNCTIONS
# -----------------------------------------------------------------------------


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
