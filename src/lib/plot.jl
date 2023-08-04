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
        group=y,
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
            n_std=3,
            aspect_ratio=1,
            label=string(ix),
            color_palette=COLORSCHEME,
        )
    end
end

"""
Plots the mover line plot with scattered data points, covariance lines, and mover line.

# Arguments
- `ms::MoverSplit`: the [`MoverSplit`](@ref) dataset.
$ARG_CONFIG_DICT
"""
function plot_mover(
    ms::MoverSplit,
    config::ConfigDict
)
    # Get the mover line for visualization
    ml = CFAR.get_mover_line(config)

    # Init a plot object
    p = plot()

    # Plot the original Gaussians samples
    CFAR.scatter_gaussian!(p, ms.static)

    # Plot the samples from the mover
    CFAR.scatter_gaussian!(p, ms.mover)

    # Plot the covariance ellipses
    CFAR.plot_covellipses(p, config)

    # Plot the mover's line
    plot!(
        p,
        ml[1, :],
        ml[2, :],
        linewidth = 3,
        color_palette = COLORSCHEME,
    )

    # Finally display the plot
    display(p)

    # Empty return
    return
end
