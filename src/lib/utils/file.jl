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
    for ix = 1:dim_ix
        for jx = 1:dim_jx
            dest_matrix[ix, jx] = vec_vec[ix][jx]
        end
    end
    return dest_matrix
end

"""
Common docstring: config filename argument.
"""
const ARG_CONFIG_FILE = """
- `config_file::AbstractString`: the config file name as a string.
"""

"""
Common docstring: config dictionary argument.
"""
const ARG_CONFIG_DICT = """
- `config::AbstractDict`: the config parameters as a dictionary.
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

"""
Loads the Gaussian distribution parameters from the provided config file.

# Arguments
$ARG_CONFIG_FILE
"""
function get_gaussian_config(config_file::AbstractString)
    # Load the config file
    data = load_config(config_file)
    # Replace the distribution variances with matrices
    for (_, dist) in data["dists"]
        # Convert the local variance from a vector of vectors to a matrix
        local_mat = vec_vec_to_matrix(dist["var"])
        # Replace the variance
        dist["var"] = local_mat
    end
    # Return the config data
    return data
end

"""
Gets the distribution generators based upon the config parameters.

# Arguments
$ARG_CONFIG_DICT
"""
function get_dists(config::AbstractDict)
    # Init the vector of distribution generators
    dist_gens = Vector{MvNormal}()

    # Construct and append each generator
    for (_, dist) in config["dists"]
        # Create the generator from the config parameters
        local_dist = MvNormal(
            dist["mu"],
            dist["var"],
        )
        # Push the generator to the list of generators
        push!(dist_gens, local_dist)
    end

    # Return the vector of generators
    return dist_gens
end

"""
Generate the Gaussian dataset from the parameters specified in the provided file.

# Arguments
$ARG_CONFIG_FILE
"""
function gen_gaussians(config_file::AbstractString)
    # Load and sanitize the Gaussian config
    config = get_gaussian_config(config_file)

    # Get the random generators from the config file
    dist_gens = get_dists(config)

    X = Matrix{Float}(undef, config["dim"], 0)
    rng = MersenneTwister(1234)
    for dist_gen in dist_gens
        data = rand(
            rng,
            dist_gen,
            config["n_points_per"],
        )
        # @info size(data)
        X = hcat(
            X,
            data,
        )
    end
    return X
end