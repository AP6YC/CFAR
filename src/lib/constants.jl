"""
    constants.jl

# Description
A collection of high-level constants for the package, such as the default names of config files.
"""

"""
The default number of processes to start in distributed experiments on Windows.
"""
const DEFAULT_N_PROCS_WINDOWS = 11

"""
The default number of processes to start in distributed experiments on Linux.
"""
const DEFAULT_N_PROCS_UNIX = 31

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

"""
Location of the local Python libraries that are included in the project.
"""
const LOCAL_PYTHON_LIB_LOCATION = projectdir("src")
# const LOCAL_PYTHON_LIB_LOCATION = joinpath(".", "src")
# const LOCAL_PYTHON_LIB_LOCATION = "./src/"
