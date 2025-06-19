"""
    plot.jl

# Description
A collection of plotting utilities and recipes for the project.

# Authors
- Sasha Petrenko <petrenkos@mst.edu> @AP6YC
"""

"""
Combines and plots data from a gaussian distribution.

# Arguments
- `p::Plots.Plot`: the plot handle to add the gaussians to.
- `data::DataSplitCombined`: the data to plot.
"""
function scatter_gaussian!(
    p::Plots.Plot,
    data::DataSplitCombined,
)
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
        dpi=DPI,
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
    for (_, dist) in config["dists"]
        # Create the covariance ellipse (from StatsPlots.jl)
        covellipse!(
            p,
            dist["mu"],
            dist["var"],
            n_std = 3,
            aspect_ratio = 1,
            # label = string(ix),
            label = nothing,
            color_palette=COLORSCHEME,
            dpi=DPI,
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
    ms::MoverSplit
)
    # Get the mover line for visualization
    ml = CFAR.get_mover_line(ms.config)

    # Init a plot object
    p = plot()

    # Plot the covariance ellipses
    CFAR.plot_covellipses(p, ms.config)

    # Plot the original Gaussians samples
    CFAR.scatter_gaussian!(p, ms.static)

    # Plot the samples from the mover
    CFAR.scatter_gaussian!(p, ms.mover)

    # # Plot the covariance ellipses
    # CFAR.plot_covellipses(p, ms.config)

    # Plot the mover's line
    plot!(
        p,
        ml[1, :],
        ml[2, :],
        linewidth = 3,
        color_palette = COLORSCHEME,
        dpi=DPI,
    )

    # Finally display the plot
    isinteractive() && display(p)

    # Return the plot handle
    return p
end


"""
Plots the mover line plot with scattered data points, covariance lines, and mover line.

# Arguments
- `ms::MoverSplit`: the [`MoverSplit`](@ref) dataset.
"""
function plot_mover(
    ms::SCTMoverSplit;
    length::Float=10.0,
    kwargs...
)
    # Get the mover line for visualization
    # ms.config["n_points"] = 50
    ml = get_mover_line(ms.config, length=length)

    # Init a plot object
    p = plot()

    # Plot the covariance ellipses
    plot_covellipses(p, ms.config)

    # Plot the original Gaussians samples
    for ix in eachindex(ms.data)
        scatter_gaussian!(p, ms.data[ix])
        # @info ix
    end

    # contour(x, y, f; levels = collect(linspace(0,1,5)))

    # CFAR.scatter_gaussian!(p, ms.data[2])

    # # Plot the covariance ellipses
    # CFAR.plot_covellipses(p, ms.config)

    # Plot the mover's line
    plot!(
        p,
        ml[1, :],
        ml[2, :],
        linewidth = 3,
        arrow=true,
        # color_palette = COLORSCHEME,
        color=:black,
        linestyle=:dash,
        label=nothing,
        dpi=DPI;
        kwargs...
    )

    # Finally display the plot
    isinteractive() && display(p)

    # Return the plot handle
    return p
end

function plot_contour(
    ms::SCTMoverSplit;
    length::Float=10.0,
    kwargs...
)
   # Get the mover line for visualization
    # ms.config["n_points"] = 50
    ml = get_mover_line(ms.config, length=length)

    # Init a plot object
    # p = plot()

    # Plot the covariance ellipses
    # plot_covellipses(p, ms.config)

    # Plot the original Gaussians samples
    # for ix in eachindex(ms.data)
    #     scatter_gaussian!(p, ms.data[ix])
    #     # @info ix
    # end


    pc = plot()
    X = range(-5, 15, length=100)
    Y = range(-4, 14, length=100)

    # V1
    # pss1(x, y) = pdf(MvNormal(ms.config["dists"][1]["mu"], ms.config["dists"][1]["var"]), [x, y])
    # pss2(x, y) = pdf(MvNormal(ms.config["dists"][2]["mu"], ms.config["dists"][2]["var"]), [x, y])
    # pss3(x, y) = pdf(MvNormal(ms.config["dists"][3]["mu"], ms.config["dists"][3]["var"]), [x, y])
    # ps(x, y) = pss1(x, y) + pss2(x, y) + pss3(x, y)
    # contourf!(pc, X, Y, ps, color=:viridis)

    xlim=[-4, 12]
    ylim=[-3, 12]
    # V2
    # colors=[:turbo, :okabe_ito, :viridis]
    colors=[
        ColorSchemes.okabe_ito[1],
        ColorSchemes.okabe_ito[2],
        ColorSchemes.okabe_ito[3],
    ]
    for ix = 1:3
        p2 = MvNormal(ms.config["dists"][ix]["mu"], ms.config["dists"][ix]["var"])
        f(x,y) = pdf(p2, [x,y])
        z = @. f(X', Y)
        # contourf!(
        contour!(
            pc,
            X,
            Y,
            # f,
            z,
            # color=:turbo,
            # colorscheme=COLORSCHEME,
            color=colors[ix],
            label="$(ix)",
            cbar=false,
            fill=false,
            levels=10,
            linewidth=2.0,
            xlims=xlim,
            ylims=ylim,
        )
        plot!(
            pc,
            [100],
            [100],
            color=colors[ix],
            label="\$T_$(ix)\$",
            linewidth=4.0,
            xlims=xlim,
            ylims=ylim,
            legend_position=:topright,
        )
    end

    display(pc)

    # contour(x, y, f; levels = collect(linspace(0,1,5)))

    # CFAR.scatter_gaussian!(p, ms.data[2])

    # # Plot the covariance ellipses
    # CFAR.plot_covellipses(p, ms.config)

    # Plot the mover's line
    plot!(
        pc,
        ml[1, :],
        ml[2, :],
        linewidth = 3,
        arrow=true,
        # color_palette = COLORSCHEME,
        color=:black,
        linestyle=:dash,
        label=nothing,
        xlims=xlim,
        ylims=ylim,
        dpi=DPI;
        kwargs...
    )

    # Finally display the plot
    isinteractive() && display(pc)

    # Return the plot handle
    return pc
end

# """
# Computes the sliding window average of a vector with window size `n`.

# # Arguments
# - `vs::RealVector`: the original vector for sliding window averages.
# - `n::Integer`: the size of the sliding window.
# """
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
Computes the averages of a sliding window along a vector.

# Arguments
- `vs::RealVector`: the vector to compute windowed averages of.
- `n::Integer`: the size of the sliding window.
"""
function sliding_avg(vs::RealVector, n::Integer)
    # Construct and return the sliding window average
    return [
        sum(@view vs[i:(i + n - 1)]) / n for i in 1:(length(vs) - (n - 1))
    ]
end

# - `avg::Bool=false`: flag for using the sliding average procedure.
# - `n::Integer=10`: used if `avg` is high, the size of the sliding window.

"""
Plots the 2D performances trends.

# Arguments
- `df::DataFrame`: the collected simulation results.
- `attrs::Vector{T} where T <: AbstractString`: the columns in the dataframe as a list of strings to create plotlines for.
- `avg::Bool=false`: optional, default false, flag to compute the windowed averages of the trends.
- `n::Integer=10`: optional, default 10, the size of the average sliding window if that option is used.
"""
function plot_2d_attrs(
    df::DataFrame,
    attrs::Vector{T};
    avg::Bool=false,
    n::Integer=10,
    title="",
    labels::Union{Vector{T}, Nothing}=nothing,
    kwargs...
) where T <: AbstractString

    # Instantiate the plot object
    p = plot()

    # Clean the dataframe of missing entries
    local_df = dropmissing(df)

    # Iteratively add each attribute line
    # for attr in attrs
    for ix in eachindex(attrs)
        attr = attrs[ix]
        # Point to the the x and y of the plot
        local_x = local_df.travel
        local_y = local_df[:, attr]

        # If selected, do the windowed averaging procedure
        if avg
            local_y = sliding_avg(local_y, n)
            local_x = local_x[1:end-n+1]
        end

        label = if isnothing(labels)
            label = attr
        else
            labels[ix]
        end

        # Add the local line to the plot
        plot!(
            p,
            local_x,
            local_y,
            # label = attr,
            label=label,
            linewidth = 4.0,
            color_palette=COLORSCHEME,
            dpi=DPI;
            kwargs...
        )
    end

    !isempty(title) && title!(p, title)

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

# """
# Plots the 2D performances trends.

# # Arguments
# - `df::DataFrame`: the collected simulation results.
# - `attrs::Vector{T} where T <: AbstractString`: the columns in the dataframe as a list of strings to create plotlines for.
# """
# function plot_2d_errlines_stats(
#     df::DataFrame,
#     attrs::Vector{T};
#     n::Integer=10,
#     title="",
#     labels::Union{Vector{T}, Nothing}=nothing,
#     kwargs...
# ) where T <: AbstractString
#     # Instantiate the plot object
#     p = plot()

#     # Clean the dataframe of missing entries
#     local_df = dropmissing(df)

#     # Iteratively add each attribute line
#     # for attr in attrs
#     for ix in eachindex(attrs)
#         attr = attrs[ix]
#         # Point to the the x and y of the plot
#         # local_x = local_df.travel[1:end - n + 1]
#         dfs = groupby(local_df, [:travel])
#         # local_x = combine(dfs, attr .=> mean)[!, :p]

#         # local_err = transpose(get_windows(local_df[:, attr], n))
#         local_err = combine(dfs, attr .=> std)[!, :travel]

#         label = if isnothing(labels)
#             label = attr
#         else
#             labels[ix]
#         end

#         # Add the errorline to the plot
#         errorline!(p,
#             local_x,
#             local_err,
#             linewidth = 4.0,
#             # label = attr,
#             label = label,
#             color_palette=COLORSCHEME,
#             errorstyle=:ribbon,
#             dpi=DPI;
#             kwargs...
#         )

#     end

#     !isempty(title) && title!(p, title)

#     # Display the plot
#     isinteractive() && display(p)

#     # Return the plot handle
#     return p
# end


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
    title="",
    labels::Union{Vector{T}, Nothing}=nothing,
    kwargs...
) where T <: AbstractString
    # Instantiate the plot object
    p = plot()

    # Clean the dataframe of missing entries
    local_df = dropmissing(df)

    # Iteratively add each attribute line
    # for attr in attrs
    for ix in eachindex(attrs)
        attr = attrs[ix]
        # Point to the the x and y of the plot
        local_x = local_df.travel[1:end - n + 1]
        local_err = transpose(get_windows(local_df[:, attr], n))

        label = if isnothing(labels)
            label = attr
        else
            labels[ix]
        end

        # Add the errorline to the plot
        errorline!(p,
            local_x,
            local_err,
            linewidth = 4.0,
            # label = attr,
            label = label,
            color_palette=COLORSCHEME,
            errorstyle=:ribbon,
            dpi=DPI;
            kwargs...
        )

    end

    !isempty(title) && title!(p, title)

    # Display the plot
    isinteractive() && display(p)

    # Return the plot handle
    return p
end

"""
Plots the 2D performances trends.

# Arguments
- `df::DataFrame`: the collected simulation results.
- `attrs::Vector{T} where T <: AbstractString`: the columns in the dataframe as a list of strings to create plotlines for.
"""
function plot_2d_errlines_double(
    df::DataFrame,
    df2::DataFrame,
    attrs::Vector{T},
    attrs2::Vector{T};
    n::Integer=10,
    title="",
    labels::Union{Vector{T}, Nothing}=nothing,
    labels2::Union{Vector{T}, Nothing}=nothing,
    kwargs...
) where T <: AbstractString
    # Instantiate the plot object
    p = plot()

    ylim = [0.35, 3.2]

    # Clean the dataframe of missing entries
    local_df = dropmissing(df)
    local_df2 = dropmissing(df2)

    # Iteratively add each attribute line
    # for attr in attrs
    for ix in eachindex(attrs)
        attr = attrs[ix]
        # Point to the the x and y of the plot
        local_x = local_df.travel[1:end - n + 1]
        local_err = transpose(get_windows(local_df[:, attr], n))
        # local_err = local_df[:, attr]

        label = if isnothing(labels)
            label = attr
        else
            labels[ix]
        end

        @info size(local_x)
        @info size(local_err)

        # Add the errorline to the plot
        # px = twinx(p)
        errorline!(
            p,
            # px,
            local_x,
            local_err,
            linewidth = 4.0,
            # label = attr,
            label = label,
            color_palette=COLORSCHEME,
            errorstyle=:ribbon,
            # legend_position=:left,
            legend_position=:topleft,
            # legend_position=:outerright,
            # legend_font_pointsize=8.0,
            # legend_position=:outertopright,
            ylims=ylim,
            dpi=DPI;
            kwargs...
        )

    end

    p2 = twinx(p)
    @info p2

    for ix in eachindex(attrs2)
        attr = attrs2[ix]
        # Point to the the x and y of the plot
        local_x = local_df2.travel[1:end - n + 1]
        # local_err = transpose(get_windows(local_df2[:, attr], n))
        local_err = local_df2[:, attr]

        label = if isnothing(labels2)
            label = attr
        else
            labels2[ix]
        end

        local_err = sliding_avg(local_err, n)

        @info "ix is $ix"
        @info size(local_x)
        @info size(local_err)

        # Add the errorline to the plot
        # p2 = twinx(p)
        # errorline!(
        # p2 =errorline(
        plot!(
            p2,
            # twinx(),
            local_x,
            local_err,
            linewidth = 4.0,
            # # label = attr,
            label = label,
            # colorscheme=:okabe_ito,
            # color=:red,
            # color_palette=ColorSchemes.okabe_ito[4],
            color=ColorSchemes.okabe_ito[5],
            linestyle=:dash,
            # legend_position=:right,
            legend_position=:topright,
            # legend_font_pointsize=8.0,
            legendlinewidth=1.0,
            ylims=ylim,
            # legend_position=(10, 10000),
            # legend_position=find_best_legend_position(p2),
            # legend_position=(45, 1.5),
            ylabel="Cluster Validity Index",
            # legend_position=:outerright,
            # color_palette=COLORSCHEME,
            # # errorstyle=:ribbon,
            # dpi=DPI,
            # # axis=:right;
            # # guide_position=:right;
            # kwargs...
        )

    end

    # isinteractive() && display(p2)

    !isempty(title) && title!(p, title)

    # Display the plot
    isinteractive() && display(p)

    # Return the plot handle
    return p
end



"""
Plots the 2D performances trends.

# Arguments
- `df::DataFrame`: the collected simulation results.
- `attrs::Vector{T} where T <: AbstractString`: the columns in the dataframe as a list of strings to create plotlines for.
"""
function plot_2d_errlines_overlay(
    df::DataFrame,
    df2::DataFrame,
    attrs::Vector{T},
    attrs2::Vector{T};
    n::Integer=10,
    title="",
    labels::Union{Vector{T}, Nothing}=nothing,
    labels2::Union{Vector{T}, Nothing}=nothing,
    kwargs...
) where T <: AbstractString
    # Instantiate the plot object
    p = plot()

    # Clean the dataframe of missing entries
    local_df = dropmissing(df)
    local_df2 = dropmissing(df2)

    # Iteratively add each attribute line
    # for attr in attrs
    for ix in eachindex(attrs)
        attr = attrs[ix]
        # Point to the the x and y of the plot
        local_x = local_df.travel[1:end - n + 1]
        local_err = transpose(get_windows(local_df[:, attr], n))
        # local_err = local_df[:, attr]

        label = if isnothing(labels)
            label = attr
        else
            labels[ix]
        end

        @info size(local_x)
        @info size(local_err)

        # Add the errorline to the plot
        # px = twinx(p)
        errorline!(
            p,
            # px,
            local_x,
            local_err,
            linewidth = 4.0,
            # label = attr,
            label = label,
            color_palette=COLORSCHEME,
            errorstyle=:ribbon,
            # legend_position=:left,
            # legend_position=:topleft,
            # legend_position=:outerright,
            # legend_font_pointsize=8.0,
            # legend_position=:outertopright,
            dpi=DPI;
            kwargs...
        )

    end

    # p2 = twinx(p)
    # @info p2

    for ix in eachindex(attrs2)
        attr = attrs2[ix]
        # Point to the the x and y of the plot
        local_x = local_df2.travel[1:end - n + 1]
        # local_err = transpose(get_windows(local_df2[:, attr], n))
        local_err = local_df2[:, attr]

        label = if isnothing(labels2)
            label = attr
        else
            labels2[ix]
        end

        local_err = sliding_avg(local_err, n)

        @info "ix is $ix"
        @info size(local_x)
        @info size(local_err)

        # Add the errorline to the plot
        # p2 = twinx(p)
        errorline!(
        # p2 =errorline(
        # plot!(
            # p2,
            p,
            # twinx(),
            local_x,
            local_err,
            linewidth = 4.0,
            # # label = attr,
            label = label,
            # colorscheme=:okabe_ito,
            # color=:red,
            # color_palette=COLORSCHEME,
            errorstyle=:ribbon,
            color=ColorSchemes.okabe_ito[5],
            linestyle=:dash,
            # legend_position=:right,
            # legend_font_pointsize=8.0,
            # legendlinewidth=1.0,
            # legend_position=(10, 10000),
            # legend_position=find_best_legend_position(p2),
            # legend_position=(45, 1.5),
            # ylabel="Cluster Validity Index",
            # legend_position=:outerright,
            # color_palette=COLORSCHEME,
            # # errorstyle=:ribbon,
            # dpi=DPI,
            axis=:right,
            # # guide_position=:right;
            # kwargs...
        )

    end

    # isinteractive() && display(p2)

    !isempty(title) && title!(p, title)

    # Display the plot
    isinteractive() && display(p)

    # Return the plot handle
    return p
end

"""
Wrapper for how figures are saved in the CFAR project.

# Arguments
- `p::Plots.Plot`: the Plot object to save.
$ARG_FILENAME
"""
function _save_plot(p::Plots.Plot, filename::AbstractString)
    savefig(p, filename)
end

"""
Wrapper for how tables are saved in the CFAR project.

# Arguments
- `table`: the table object to save.
$ARG_FILENAME
"""
function _save_table(table, filename::AbstractString)
    open(filename, "w") do io
        write(io, table)
    end
end

"""
Dictionary mapping the names of result save types to the private wrapper functions that implement them.
"""
const SAVE_MAP = Dict(
    "figure" => :_save_fig,
    "table" => :_save_table,
)

"""
Saves the plot to the both the local results directory and to the paper directory.

# Arguments
- `p::Plots.Plot`: the handle of the plot to save.
- `fig_name::AbstractString`: the name of the figure file itself.
- `exp_top::AbstractString`: the top of the experiment directory.
- `exp_name::AbstractString`: the name of the experiment itself.
"""
function save_plot(
    p::Plots.Plot,
    fig_name::AbstractString,
    exp_top::AbstractString,
    exp_name::AbstractString
)
    # Save to the local results directory
    mkpath(results_dir(exp_top, exp_name))
    _save_plot(p, results_dir(exp_top, exp_name, fig_name))
    # Save to the paper directory
    mkpath(paper_results_dir(exp_top, exp_name))
    _save_plot(p, paper_results_dir(exp_top, exp_name, fig_name))

    return
end

# """
# Saving function for results in the DCCR project.

# This function dispatches to the correct private wrapper saving function via the `type` option, and the `to_paper` flag determines if the result is also saved to a secondary location, which is mainly used for also saving the result to the cloud location for the journal paper.

# # Arguments
# - `type::AbstractString`: the type of object being saved (see [`SAVE_MAP`](@ref)).
# - `object`: the object to save as `type`, whether a figure, table, or something else.
# - `exp_name::AbstractString`: the name of the experiment, used for the final saving directories.
# - `save_name::AbstractString`: the name of the save file itself.
# - `to_paper::Bool=false`: optional, flag for saving to the paper results directory (default `false`).
# """
# function save_cfar(type::AbstractString, object, exp_name::AbstractString, save_name::AbstractString ; to_paper::Bool=false)
#     # Save the figure to the local results directory
#     mkpath(results_dir(exp_name))
#     eval(SAVE_MAP[type])(object, results_dir(exp_name, save_name))

#     # Check if saving to the paper directory as well
#     if to_paper
#         mkpath(paper_results_dir(exp_name))
#         eval(SAVE_MAP[type])(object, paper_results_dir(exp_name, save_name))
#     end
# end
