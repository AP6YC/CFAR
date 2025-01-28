# -----------------------------------------------------------------------------
# STRUCTS
# -----------------------------------------------------------------------------

"""
Definition of a split of data with one part remaining static and the other moving.
"""
struct SCTMoverSplit
    """
    TODO
    """
    data::Vector{DataSplitCombined}

    """
    The config used to generate the mover.
    """
    config::ConfigDict
end

# -----------------------------------------------------------------------------
# CONSTRUCTORS
# -----------------------------------------------------------------------------

"""
Constructor for a [`SCTMoverSplit`](@ref) taking a preconstructed static and mover [`LabeledDataset`](@ref)s along with a split parameter `p`.

# Arguments
- `static::LabeledDataset`: the static part of the dataset.
- `mover::LabeledDataset`: the moving part of the datset.
"""
function SCTMoverSplit(
    # static::LabeledDataset,
    # mover::LabeledDataset,
    data::Vector{LabeledDataset},
    config::ConfigDict
)
    # new_static = DataSplitCombined(
    #     static,
    #     p=config["split"],
    #     normalize=false,
    # )

    new_data = [
        DataSplitCombined(
            d,
            p=config["split"],
            normalize=false,
        ) for d in data
    ]
    # new_mover = DataSplitCombined(
    #     mover,
    #     p=config["split"],
    #     normalize=false,
    # )
    return SCTMoverSplit(
        new_data,
        config,
    )
end

# -----------------------------------------------------------------------------
# FUNCTIONS
# -----------------------------------------------------------------------------
