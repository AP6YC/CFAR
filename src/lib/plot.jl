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
    )
    # Explicitly empty return
    return
end

function plot_covellipses(p::Plots.Plot, config::ConfigDict)
    for (ix, dist) in config["dists"]
        covellipse!(
            p,
            dist["mu"],
            dist["var"],
            n_std=3,
            aspect_ratio=1,
            label=string(ix),
        )
    end
end

function plot_mover(ms::MoverSplit, config::ConfigDict)
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
    )

    display(p)

    return
end
