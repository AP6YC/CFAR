
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
