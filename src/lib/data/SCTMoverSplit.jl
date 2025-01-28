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

function DataSplitCombined(data::SCTMoverSplit)
    # return data.data
    train = LabeledDataset(
        hcat([d.train.x for d in data.data]...),
        vcat([d.train.y for d in data.data]...),
        # data.data[1].train.labels,
        vcat([d.train.labels for d in data.data]...),
    )
    test = LabeledDataset(
        hcat([d.test.x for d in data.data]...),
        vcat([d.test.y for d in data.data]...),
        # data.data[1].test.labels,
        vcat([d.test.labels for d in data.data]...),
    )
    return DataSplitCombined(
        train,
        test,
    )
end

# function SCTMoverSplit(
#     data::Vector{DataSplitCombined},
#     config::ConfigDict
# )
#     return SCTMoverSplit(
#         data,
#         config,
#     )
# end

# """