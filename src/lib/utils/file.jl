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
    dist_gen_dict = Dict{Int, MvNormal}()

    # Construct and append each generator
    for (ix, dist) in config["dists"]
        # Get the mean and variance from the config
        mu = dist["mu"]
        var = dist["var"] * dist["scale"]

        # Create the generator from the config parameters
        local_dist = MvNormal(
            mu,
            var,
        )

        # Push the generator to its own dict
        dist_gen_dict[ix] = local_dist
    end

    # Put the distributions in order in the output vector
    n_dist = length(dist_gen_dict)
    for ix = 1:n_dist
        push!(dist_gens, dist_gen_dict[ix])
    end

    # Return the vector of generators
    return dist_gens
end

"""
# Arguments
$ARG_CONFIG_DICT
"""
function gen_gaussians(config::AbstractDict)
    # Get the random generators from the config file
    dist_gens = get_dists(config)

    # Init the destination data
    X = Matrix{Float}(undef, config["dim"], 0)
    y = Vector{Int}()

    # Init the random number generator
    rng = MersenneTwister(config["rng_seed"])

    # Iterate over all generators
    n_dist = length(dist_gens)
    mx = []
    my = []
    for ix = 1:n_dist
    # for ix in eachindex(dist_gens)
        # Create a new set of data from the generator
        data_x = rand(
            rng,
            dist_gens[ix],
            config["n_points_per"],
        )

        # Create a set of labels for this dataset
        data_y = ones(Int, config["n_points_per"]) * ix

        if ix == config["mover"]
            mx = data_x
            my = data_y
        else
            # Concatenate to the output data
            X = hcat(
                X,
                data_x,
            )
            y = vcat(
                y,
                data_y,
            )
        end
    end

    return X, y, mx, my
end

"""
Generate the Gaussian dataset from the parameters specified in the provided file.

# Arguments
$ARG_CONFIG_FILE
"""
function gen_gaussians(config_file::AbstractString)
    # Load and sanitize the Gaussian config
    config = get_gaussian_config(config_file)
    # Return the generated gaussians
    return gen_gaussians(config)
end

"""
Generates a vector representing the direction of the mover's line.

# Arguments
$ARG_CONFIG_DICT
"""
function get_mover_direction(config::AbstractDict)
    # Get the direction as a function of the config file angle
    direction = [
        cosd(config["angle"])
        sind(config["angle"])
    ]

    # Return that direction vector
    return direction
end

"""
Shifts the provided data samples matrix along the config direction by `s` amount.

# Arguments
- `data::RealMatrix`: the dataset of shape `(n_samples, dim)`.
$ARG_CONFIG_DICT
- `s::Float`: the distance to travel along the line
"""
function shift_samples(data::RealMatrix, config::AbstractDict, s::Float)
    # Get the direction
    direction = get_mover_direction(config)
    shift = direction .* s

    # Shift all samples by the same amount
    new_data = data .+ shift

    return new_data
end

"""
Generates a dataset of points representing the mover's direction of traversal.

# Arguments
$ARG_CONFIG_DICT
- `n_points::Integer=2`: kwarg, number of points along the line to return.
- `length::Float=10.0`: kwarg, length of the line.
"""
function get_mover_line(
    config::AbstractDict;
    n_points::Integer=2,
    length::Float=10.0
)
    # Identify which mean belongs to the mover
    mover_index = config["mover"]
    # Get the mean of the mover
    mu = config["dists"][mover_index]["mu"]
    # Create the interpolation points
    sl = collect(range(0.0, length, length=n_points))
    # Get the direction vector
    direction = get_mover_direction(config)
    # Traverse the vector starting at the mean
    ml = mu .+ direction * sl'
    # Return the mover line
    return ml
end
