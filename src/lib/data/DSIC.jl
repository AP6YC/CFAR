
"""
DataSplitIndexedCombined (DSIC)

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