"""
    conda_setup.jl

# Description
This script demonstrates how a local python package is installed in editable mode using `CondaPkg.jl`.

# Authors
- Sasha Petrenko <petrenkos@mst.edu>
"""

using CondaPkg

# Install the CondaPkg.toml
CondaPkg.resolve()

# With the local conda Python executable, install the local package
CondaPkg.withenv() do
    python = CondaPkg.which("python")
    run(`$(python) --version`)
    run(`$python -m pip install -e ./src/mlp`)
end
