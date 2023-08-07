"""
    2a_analyze_sfam.jl

# Description
This script takes the results of the Monte Carlo and generates plots of their statistics.

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

using PythonCall
using CondaPkg

# mlp = pyimport(".", "mlp")

# CondaPkg.withenv() do
#     python = CondaPkg.which("python")
#     run(`$(python) --version`)
# end

pydeps = joinpath("scripts", "1_gaussian", "mlp.py")
pyexec(read(pydeps))
