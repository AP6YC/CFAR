
"""
Loads a local dataset.

# Arguments
- `filename::AbstractString`: the location of the file to load with a default value.
"""
function load_dataset(
    filename::AbstractString,
)
    # Load the data
    data = readdlm(filename, ',', header=false)

    # Get the number of features
    n_features = size(data)[2] - 1

    # Get the features and labels
    # features = data[:, 1:n_features]'
    features = permutedims(data[:, 1:n_features])
    labels = Vector{Int}(data[:, end])

    # Return the features and labels
    return features, labels
end

"""
Returns the sigmoid function on x.

# Arguments
- `x::Real`: the float or int to compute the sigmoid function upon.
"""
function sigmoid(x::Real)
    return one(x) / (one(x) + exp(-x))
end

"""
Get the distribution parameters for preprocessing.

# Arguments
- `data::RealMatrix`: a 2-D matrix of features for computing the Gaussian statistics of.
"""
function get_dist(data::RealMatrix)
    return fit(ZScoreTransform, data, dims=2)
end

"""
Preprocesses one dataset of features, scaling and squashing along the feature axes.

# Arguments
- `dt::ZScoreTransform`: the Gaussian statistics of the features.
- `scaling::Real`: the sigmoid scaling parameter.
- `data::RealMatrix`: the 2-D matrix of features to transform.
"""
function feature_preprocess(dt::ZScoreTransform, scaling::Real, data::RealMatrix)
    # Normalize the dataset via the ZScoreTransform
    new_data = StatsBase.transform(dt, data)
    # Squash the data sigmoidally with the scaling parameter
    new_data = sigmoid.(scaling*new_data)
    # Return the normalized and scaled data
    return new_data
end



"""
Loads all of the data sets from the local data package folder.

# Arguments
- `topdir::AbstractString = data_dir("data-package")`:
"""
function load_datasets(
    topdir::AbstractString = data_dir("data-package"),
    # scaling::Real=3.0,
)
    # datasets = Dict{String, Any}()
    datasets = Dict{String, LabeledDataset}()
    for (root, _, files) in walkdir(topdir)
        # Iterate over all of the files
        for file in files
            # Get the full filename for the current data file
            filename = joinpath(root, file)
            # Load the dataset
            data = CFAR.load_dataset(filename)
            # Get the data name from the filename
            data_name = splitext(file)[1]
            # datasets[data_name] = data

            local_data = LabeledDataset(
                # train_x,
                # test_x
                data[1],
                data[2],
                string.(unique(data[2])),
            )
            datasets[data_name] = local_data
            # @info data
            # @info "Loaded $file"
        end
    end
# DataSplitCombined
    return datasets

end