"""
    constants.jl

# Description
A collection of high-level constants for the package, such as the default names of config files.
"""

"""
Location of the ART options file for simulations.
"""
const DEFAULT_ART_OPTS_FILE = "art.yml"

"""
Location of the MLP options file for simulations.
"""
const DEFAULT_MLP_OPTS_FILE = "mlp.yml"

"""
Name of the MLP library.
"""
const MLP = "mlp"

"""
List of names of local libraries to make sure to install during setup.
"""
const LOCAL_PYTHON_LIBS = [
    MLP,
]

# const LOCAL_PYTHON_LIB_LOCATION = "./src/"
const LOCAL_PYTHON_LIB_LOCATION = joinpath(".", "src")
