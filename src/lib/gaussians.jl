"""
    gaussians.jl

# Description
A collection of the functions for generating and saving Gaussian samples for training/testing.
"""

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
    # Order the distributions for convenience
    dist_dict = OrderedDict{Int, Any}()
    for ix = 1:length(data["dists"])
        dist_dict[ix] = data["dists"][ix]
    end
    # Replace with the ordered dictionary
    data["dists"] = dist_dict
    # Return the config data
    return data
end

"""
Gets the distribution generators based upon the config parameters.

# Arguments
$ARG_CONFIG_DICT
"""
function get_dists(config::ConfigDict)
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
Generates Gaussian distributed samples from the provided configuration dictionary.

# Arguments
$ARG_CONFIG_DICT
"""
function gen_gaussians(config::ConfigDict)
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

        # If we are at the mover index, output separately
        if ix == config["mover"]
            mx = data_x
            my = data_y
        # Otherwise, concatenate to the output data
        else
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

    static = LabeledDataset(X, y, ["1", "2"])
    mover = LabeledDataset(mx, my, ["mover"])
    # @info static
    # @info mover
    ms = MoverSplit(static, mover)
    # DataSplitCombined()

    # return X, y, mx, my
    return ms
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
function get_mover_direction(config::ConfigDict)
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
function shift_samples(data::RealMatrix, config::ConfigDict, s::Float)
    # Get the direction
    direction = get_mover_direction(config)
    shift = direction .* s

    # Shift all samples by the same amount
    new_data = data .+ shift

    # Return the shifted data
    return new_data
end

# function shift_dataset!(data::LabeledDataset, config::ConfigDict, s::Float)
#     data.train = shift_samples(data.train, config, s)
#     data.test = shift_samples(data.test, config, s)
#     return
# end

function shift_mover!(ms::MoverSplit, config::ConfigDict, s::Float)
    # shift_dataset!(ms.mover, config, s)
    ms.mover.train.x = shift_samples(ms.mover.train.x, config, s)
    ms.mover.test.x = shift_samples(ms.mover.test.x, config, s)
    # data.train = shift_samples(data.train, config, s)
    # data.test = shift_samples(data.test, config, s)
    return
end

"""
Generates a dataset of points representing the mover's direction of traversal.

# Arguments
$ARG_CONFIG_DICT
- `n_points::Integer=2`: kwarg, number of points along the line to return.
- `length::Float=10.0`: kwarg, length of the line.
"""
function get_mover_line(
    config::ConfigDict;
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

# struct

# end

# function extend_concat_gaussians()
# end

function save_gaussians(ms::MoverSplit, filename::AbstractString)
    # Open the h5 file
    h5open(filename, "w") do fid
        g = create_group
    end

    # Empty return
    return
end
