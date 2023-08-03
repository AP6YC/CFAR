"""
Turns a vector of vectors into a matrix.

Assumes that the shape of the vector of vectors is square.

# Arguments
- `vec_vec::AbstractVector`: a vector of vectors of numerical values.
"""
function vec_vec_to_matrix(vec_vec::AbstractVector)
    dim_ix = length(vec_vec)
    dim_jx = length(vec_vec[1])
    dest_matrix = zeros(dim_ix, dim_jx)
    for ix in dim_ix
        for jx in dim_jx
            dest_matrix[ix, jx] = vec_vec[ix][jx]
        end
    end
    return dest_matrix
end

"""
Common docstring: config filename argument.
"""
const ARG_CONFIG_FILE = """
- `config::AbstractString`: the config file name as a string.
"""

"""
Wrapper for loading the configuration file with the provided filename.

# Arguments
$ARG_CONFIG_FILE
"""
function load_config(config::AbstractString)
    # Load and return the config file
    return YAML.load_file(config_dir(config))
end

"""
Loads the Gaussian distribution parameters from the provided config file.

# Arguments
$ARG_CONFIG_FILE
"""
function get_dists(config::AbstractString)
    data = load_config(config)
    for (_, dist) in data["dists"]
        local_mat = vec_vec_to_matrix(dist["var"])
        dist["var"] = local_mat
    end
    return data
end
