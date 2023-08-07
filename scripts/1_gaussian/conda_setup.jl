"""
    2a_analyze_sfam.jl

# Description
This script takes the results of the Monte Carlo and generates plots of their statistics.

# Authors
- Sasha Petrenko <petrenkos@mst.edu>
"""

using CondaPkg

CondaPkg.add("tensorflow")

CondaPkg.withenv() do
    python = CondaPkg.which("python")
    run(`$(python) --version`)
end
