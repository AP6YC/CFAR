"""
    file.jl

# Description
A collection of file saving and loading utilities.
"""

# -----------------------------------------------------------------------------
# ALIASES
# -----------------------------------------------------------------------------

"""
Definition of a configuration dictionary loaded from a config file.
"""
const ConfigDict = Dict{Any, Any}
# const ConfigDict = Dict{String, Any}

# -----------------------------------------------------------------------------
# FUNCTIONS
# -----------------------------------------------------------------------------

"""
Wrapper for loading the configuration file with the provided filename.

# Arguments
$ARG_CONFIG_FILE
"""
function load_config(config_file::AbstractString)
    # Load and return the config file
    return YAML.load_file(
        config_dir(config_file);
        dicttype=ConfigDict
    )
end
