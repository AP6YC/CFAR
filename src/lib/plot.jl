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

# function plot_mover()
