"""
    plot.jl

# Description
A collection of plotting utilities and recipes for the project.
"""

"""
Combines and plots data from a gaussian distribution.
"""
function scatter_gaussian!(p::Plots.Plot, data::DataSplitCombined)
    # Get the combined train/test data
    X = CFAR.get_x(data)
    y = CFAR.get_y(data)

    # Scatter the data with a grouping
    scatter!(
        p,
        X[1, :],
        X[2, :],
        group = y,
        color_palette=COLORSCHEME,
    )

    # Explicitly empty return
    return
end

"""
Plots the covariance ellipses from the config on top of an existing plot.

# Arguments
$ARG_PLOT
$ARG_CONFIG_DICT
"""
function plot_covellipses(
    p::Plots.Plot,
    config::ConfigDict
)
    # Iterate over every distribution
    for (ix, dist) in config["dists"]
        # Create the covariance ellipse (from StatsPlots.jl)
        covellipse!(
            p,
            dist["mu"],
            dist["var"],
            n_std = 3,
            aspect_ratio = 1,
            label = string(ix),
            color_palette=COLORSCHEME,
        )
    end

    # Empty return
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
    # Get the mean of the mover
    mu = config["mover_dist"]["mu"]

    # Create the interpolation points
    sl = collect(range(0.0, length, length=n_points))

    # Get the direction vector
    direction = get_mover_direction(config)

    # Traverse the vector starting at the mean
    ml = mu .+ direction * sl'

    # Return the mover line
    return ml
end

"""
Plots the mover line plot with scattered data points, covariance lines, and mover line.

# Arguments
- `ms::MoverSplit`: the [`MoverSplit`](@ref) dataset.
"""
function plot_mover(
    ms::MoverSplit,
)
    # Get the mover line for visualization
    ml = CFAR.get_mover_line(ms.config)

    # Init a plot object
    p = plot()

    # Plot the original Gaussians samples
    CFAR.scatter_gaussian!(p, ms.static)

    # Plot the samples from the mover
    CFAR.scatter_gaussian!(p, ms.mover)

    # Plot the covariance ellipses
    CFAR.plot_covellipses(p, ms.config)

    # Plot the mover's line
    plot!(
        p,
        ml[1, :],
        ml[2, :],
        linewidth = 3,
        color_palette = COLORSCHEME,
    )

    # Finally display the plot
    isinteractive() && display(p)

    # Empty return
    return
end


"""
Computes the sliding window average of a vector with window size `n`.

# Arguments
- `vs::RealVector`: the original vector for sliding window averages.
- `n::Integer`: the size of the sliding window.
"""
function sliding_avg(vs::RealVector, n::Integer)
    # Construct and return the sliding window average
    return [
        sum(@view vs[i:(i+n-1)])/n for i in 1:(length(vs)-(n-1))
    ]
end

"""
Plots the 2D performances trends.

# Arguments
- `df::DataFrame`: the collected simulation results.
- `attrs::Vector{T} where T <: AbstractString`: the columns in the dataframe as a list of strings to create plotlines for.
"""
function plot_2d_attrs(
    df::DataFrame,
    attrs::Vector{T};
    avg::Bool=false,
    n::Integer=10,
) where T <: AbstractString

    # Instantiate the plot object
    p = plot()

    # Clean the dataframe of missing entries
    local_df = dropmissing(df)

    # Iteratively add each attribute line
    for attr in attrs
        # Point to the the x and y of the plot
        local_x = local_df.travel
        local_y = local_df[:, attr]

        # If selected, do the windowed averaging procedure
        if avg
            local_y = sliding_avg(local_y, n)
            local_x = local_x[1:end-n+1]
        end

        # Add the local line to the plot
        plot!(
            p,
            local_x,
            local_y,
            label = attr,
            linewidth = 4.0,
            color_palette=COLORSCHEME,
        )
    end

    # Display the plot
    isinteractive() && display(p)

    # Return the plot handle
    return p
end

"""
Constructs a windowed matrix of a vector.

# Arguments
- `vs::RealVector`: the original vector.
- `n::Integer`: the size of the sliding window.
"""
function get_windows(vs::RealVector, n::Integer)
    # Compute the size of the window
    n_window = length(vs) - n + 1

    # Initialize the windowed matrix version of the input vector
    local_window = zeros(n, n_window)

    # Construct a windowed version of vector at each index of n_window
    for ix = 1:n_window
        local_window[:, ix] = vs[ix:(ix + n - 1)]
    end

    # Return the windowed matrix version of the vector
    return local_window
end

"""
Plots the 2D performances trends.

# Arguments
- `df::DataFrame`: the collected simulation results.
- `attrs::Vector{T} where T <: AbstractString`: the columns in the dataframe as a list of strings to create plotlines for.
"""
function plot_2d_errlines(
    df::DataFrame,
    attrs::Vector{T};
    n::Integer=10,
) where T <: AbstractString
    # Instantiate the plot object
    p = plot()

    # Clean the dataframe of missing entries
    local_df = dropmissing(df)

    # Iteratively add each attribute line
    for attr in attrs
        # Point to the the x and y of the plot
        local_x = local_df.travel[1:end - n + 1]
        local_err = transpose(get_windows(local_df[:, attr], n))

        # Add the errorline to the plot
        errorline!(p,
            local_x,
            local_err,
            linewidth = 4.0,
            label = attr,
            color_palette=COLORSCHEME,
            errorstyle=:ribbon,
        )

    end

    # Display the plot
    isinteractive() && display(p)

    # Return the plot handle
    return p
end
