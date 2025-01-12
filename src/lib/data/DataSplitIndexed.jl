# -----------------------------------------------------------------------------
# STRUCTS
# -----------------------------------------------------------------------------

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

# -----------------------------------------------------------------------------
# CONSTRUCTORS
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# FUNCTIONS
# -----------------------------------------------------------------------------
