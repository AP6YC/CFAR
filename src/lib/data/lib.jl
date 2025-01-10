"""
    lib.jl

# Description
Aggregation of dataset definition files.
"""

# Aliases, abstract types
include("common.jl")

include("LabeledDataset.jl")

include("VectorLabeledDataset.jl")

include("DataSplit.jl")

include("DataSplitIndexed.jl")

include("DSIC.jl")

include("DataSplitCombined.jl")

include("MoverSplit.jl")

include("load.jl")