"""
    file.jl

# Description
A collection of file saving and loading utilities.
"""

"""
Wrapper for loading the configuration file with the provided filename.

# Arguments
$ARG_CONFIG_FILE
"""
function load_config(config_file::AbstractString)
    # Load and return the config file
    return YAML.load_file(config_dir(config_file))
end
