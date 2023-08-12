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

# """
# Plots the 2D performances trends.

# # Arguments
# - `df::DataFrame`: the collected simulation results.
# """
# function plot_2d_perfs(df::DataFrame)
#     # Instantiate the plot object
#     p = plot()

#     # Create a set of tuples for iterative plotting
#     df_plot_attrs = (
#         (df.p1, "p1"),
#         (df.p2, "p2"),
#         (df.p12, "p12"),
#     )

#     # Iteratively add each performance line
#     for (data, label) in df_plot_attrs
#         plot!(
#             p,
#             df.travel,
#             data,
#             label = label,
#             linewidth = 4.0,
#             color_palette=COLORSCHEME,
#         )
#     end

#     # Displya the plot
#     isinteractive() && display(p)

#     # Empty return
#     return
# end

"""
Plots the 2D performances trends.

# Arguments
- `df::DataFrame`: the collected simulation results.
- `attrs::Vector{T} where T <: AbstractString`: the columns in the dataframe as a list of strings to create plotlines for.
"""
function plot_2d_attrs(
    df::DataFrame,
    attrs::Vector{T}
) where T <: AbstractString
    # Instantiate the plot object
    p = plot()

    # Iteratively add each attribute line
    for attr in attrs
        plot!(
            p,
            df.travel,
            df[:, attr],
            label = attr,
            linewidth = 4.0,
            color_palette=COLORSCHEME,
        )
    end

    # Display the plot
    isinteractive() && display(p)

    # Empty return
    return
end


# function plot_2d_mlp(df::DataFrame)
#     # Instantiate the plot object
#     p = plot()

#     # Create a set of tuples for iterative plotting
#     df_plot_attrs = (
#         (df.acc, "acc"),
#         (df.p2, "p2"),
#         (df.p12, "p12"),
#     )

#     # Iteratively add each performance line
#     for (data, label) in df_plot_attrs
#         plot!(
#             p,
#             df.travel,
#             data,
#             label = label,
#             linewidth = 4.0,
#             color_palette=COLORSCHEME,
#         )
#     end

#     # Displya the plot
#     display(p)

#     # Empty return
#     return
# end
