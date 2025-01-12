# -----------------------------------------------------------------------------
# STRUCTS
# -----------------------------------------------------------------------------

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

# -----------------------------------------------------------------------------
# CONSTRUCTORS
# -----------------------------------------------------------------------------

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
    new_static = DataSplitCombined(
        static,
        p=config["split"],
        normalize=false,
    )
    new_mover = DataSplitCombined(
        mover,
        p=config["split"],
        normalize=false,
    )
    return MoverSplit(
        new_static,
        new_mover,
        config,
    )
end

# -----------------------------------------------------------------------------
# FUNCTIONS
# -----------------------------------------------------------------------------
