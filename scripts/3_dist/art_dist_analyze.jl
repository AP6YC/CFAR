"""
    art_analyze.jl

# Description
This script takes the results of the ART simulations and generates plots of their statistics.

# Authors
- Sasha Petrenko <petrenkos@mst.edu> @AP6YC
"""

# -----------------------------------------------------------------------------
# PREAMBLE
# -----------------------------------------------------------------------------

using Revise
using CFAR

# -----------------------------------------------------------------------------
# ADDITIONAL DEPENDENCIES
# -----------------------------------------------------------------------------

using DrWatson      # collect_results!
using DataFrames
using Plots
using StatsBase

# -----------------------------------------------------------------------------
# OPTIONS
# -----------------------------------------------------------------------------

# This experiment name
exp_top = "1_gaussian"
# exp_name = "art_dist_analyze"
exp_name = "art_analyze"

perf_plot = "perf.png"
err_plot = "err.png"
n_cats_plot = "n_categories.png"
surf_plot = "surf.png"

run_slices = false
# Point to the sweep results
sweep_dir = CFAR.results_dir(
    "1_gaussian",
    # "2_art",
    "art_dist",
    # "linear_sweep"
)

# -----------------------------------------------------------------------------
# PARSE ARGS
# -----------------------------------------------------------------------------

# Parse the arguments provided to this script
pargs = CFAR.exp_parse(
    "$(exp_top)/$(exp_name): analyze ART results."
)

# -----------------------------------------------------------------------------
# LOAD RESULTS
# -----------------------------------------------------------------------------

# Collect the results into a single dataframe
df = collect_results!(sweep_dir)
# df = collect_results(sweep_dir)

sort!(df, [:travel])

attrs = [
    "p1",
    "p2",
    "p3",
#     "p12",
]

# Average for each
dfs = groupby(df, [:travel, :rho])
vcs = [:p1, :p2, :p3, :nc1, :nc2, :nc3]
dfss = combine(dfs, vcs .=> mean)
# dfss = combine(dfs) do df
#     (m = mean(df.PetalLength), s² = var(df.PetalLength))
# end
m_attrs = [
    "p1_mean",
    "p2_mean",
    "p3_mean",
#     "p12",
]

p_surf = surface(
    dfss[!, :rho],
    dfss[!, :travel],
    dfss[!, :p3_mean],
    camera=(60, 30),
    colorscheme=:okabe_ito,
    xlabel="rho",
    ylabel="travel",
    zlabel="p3 mean",
)

CFAR.save_plot(p_surf, surf_plot, exp_top, exp_name)

# dfss_rho = combine(groupby(dfss, :rho)[7], :)
dfss_rho = combine(groupby(df, :rho)[7], :)
for ix in eachindex(attrs)
    rename!(dfss_rho, Symbol(m_attrs[ix]) => Symbol(attrs[ix]))
end
# dfss_rho = combine(groupby(df, :rho)[7], :)

# Plot the average trendlines
p1 = CFAR.plot_2d_attrs(
    # df,
    # dfss,
    dfss_rho,
    attrs,
    avg=true,
    n=100,
    # title="Peformances",
)
CFAR.save_plot(p1, perf_plot, exp_top, exp_name)

# Plot the StatsPlots error lines
p2 = CFAR.plot_2d_errlines(
    # df,
    # dfss,
    dfss_rho,
    attrs,
    # avg=true,
    n=100,
    # title="Performances with Error Bars",
)
CFAR.save_plot(p2, err_plot, exp_top, exp_name)

c_attrs = [
    # "nc1_mean",
    # "nc2_mean",
    # "nc3_mean",
    "nc1",
    "nc2",
    "nc3",
#     "p12",
]

# Plot the number of categories
p3= CFAR.plot_2d_attrs(
    # df,
    # dfss,
    dfss_rho,
    c_attrs,
    # attrs,
    avg=true,
    n=100,
    # title="Number of Categories",
)
CFAR.save_plot(p3, n_cats_plot, exp_top, exp_name)

# Plot the StatsPlots error lines
p4 = CFAR.plot_2d_errlines(
    # df,
    # dfss,
    dfss_rho,
    c_attrs,
    # attrs,
    n=100,
    # title="Number of Categories with 1-Sigma Bars",
)
CFAR.save_plot(p4, "nc_err", exp_top, exp_name)

# -----------------------------------------------------------------------------
# CATEGORIES SLICES
# -----------------------------------------------------------------------------

if run_slices
    slices = [5.0, 10.0, 20.0]
    for slice in slices
        # slice = 20.0
        eta = 0.03
        local_df = df[abs.(df.travel .- slice) .< eta, :]
        # local_df = df[abs.(df.travel .- 10.0) .< 0.03, :]

        p5 = plot()
        for ix = 1:3
            histogram!(
                p5,
                local_df[!, "nc$(ix)"],
                label="nc$(ix)",
                # title="Number of Categories",
                xlabel="Travel",
                ylabel="Number of Categories",
                legend=:topleft,
                # color=:blue,
                # lw=2,
                # xticks=0:0.1:1.0,
                # yticks=0:1:10,
                # size=(800, 600),
            )
        end
        display(p5)
        CFAR.save_plot(p5, "slice-$(Int(slice))", exp_top, exp_name)
    end
end

# -----------------------------------------------------------------------------
# CLEANUP
# -----------------------------------------------------------------------------

@info "Done plotting for $(exp_name)"
