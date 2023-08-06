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

    # Create a new distribution for tracking the mover
    # data["mover_dist"] = Dict{String, Any}()
    dist_ind = data["mover"]
    data["mover_dist"] = deepcopy(data["dists"][dist_ind])
    # for dist_info in ["mu", "var", "scale"]
    #     data["mover_dist"][dist_info] = data["dists"][dist_ind][dist_info]
    # end

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
    ms = MoverSplit(static, mover, config)
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
Gets the shift vector from the configuration and distance to traverse.
# Arguments
$ARG_CONFIG_DICT
- `s::Float`: the distance to travel along the line
"""
function get_shift(config::ConfigDict, s::Float)
    # Get the direction
    direction = get_mover_direction(config)
    shift = direction .* s
    return shift
end

# """
# Shifts the provided data samples matrix along the config direction by `s` amount.

# # Arguments
# - `data::RealMatrix`: the dataset of shape `(n_samples, dim)`.
# $ARG_CONFIG_DICT
# - `s::Float`: the distance to travel along the line
# """
# function shift_samples(data::RealMatrix, config::ConfigDict, s::Float)
#     shift = get_shift(config, s)

#     # Shift all samples by the same amount
#     new_data = data .+ shift

#     # Return the shifted data
#     return new_data
# end

"""
Moves the mover component of a [`MoverSplit`](@ref) a distance of `s`.

# Arguments
- `ms::MoverSplit`: the datset containing a mover to shift.
$ARG_CONFIG_DICT
- `s::Float`: the distance to travel along the line
"""
function shift_mover(
    ms::MoverSplit,
    # config::ConfigDict,
    s::Float
)
    # Get the amount to shift by from the configuration and provided s
    shift = get_shift(ms.config, s)

    # Shift the training and testing datasets
    new_train_x = ms.mover.train.x .+ shift
    new_test_x = ms.mover.test.x .+ shift

    # Copy and shift the config
    new_config = deepcopy(ms.config)
    mover_ind = new_config["mover"]
    new_config["dists"][mover_ind]["mu"] += shift
    # new_config["mover_dist"]["mu"] += shift

    # Create a new mover dataset from the shifted samples
    new_mover = DataSplitCombined(
        LabeledDataset(
            new_train_x,
            ms.mover.train.y,
            ms.mover.train.labels,
        ),
        LabeledDataset(
            new_test_x,
            ms.mover.test.y,
            ms.mover.test.labels,
        )
    )

    # Create a new MoverSplit
    new_ms = MoverSplit(
        ms.static,
        new_mover,
        new_config,
    )

    # Return the newly constructed dataset
    return new_ms
end

# struct

# end

# function extend_concat_gaussians()
# end

"""
Constant name for the JLD2/H5 group that data is saved to and loaded from.

# Arguments
- `ms::MoverSplit`: the [`MoverSplit`](@ref) dataset to save.
$ARG_FILENAME
"""
const MS_GROUP = "ms"

function save_gaussians(ms::MoverSplit, filename::AbstractString)
    # Save directly with JLD2
    JLD2.save(filename, MS_GROUP, ms)

    # Empty return
    return
end

"""
Loads and returns the gaussian data from the provided filename.

# Arguments
$ARG_FILENAME
"""
function load_gaussians(filename::AbstractString)
    # Load and return the datset
    return JLD2.load(filename, MS_GROUP)
end