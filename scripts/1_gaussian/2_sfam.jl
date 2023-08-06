"""
    2_sfam.jl

# Description
Trains and tests Simplified FuzzyARTMAP on the Gaussian dataset.

# Authors
- Sasha Petrenko <petrenkos@mst.edu>
"""

# -----------------------------------------------------------------------------
# PREAMBLE
# -----------------------------------------------------------------------------

using Revise
using CFAR

# -----------------------------------------------------------------------------
# ADDITIONAL DEPENDENCIES
# -----------------------------------------------------------------------------

using
    Distributed,
    Combinatorics

# -----------------------------------------------------------------------------
# PARSE ARGS
# -----------------------------------------------------------------------------

pargs = DCCR.dist_exp_parse(
    "3_shuffled_mc: distributed simple shuffled train/test Monte Carlo."
)

if !isempty(ARGS)
    addprocs(parse(Int, ARGS[1]), exeflags="--project=.")
end