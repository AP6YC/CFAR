"""
    knn_analyze.jl

# Description
This script takes the results of the kNN simulations and generates plots of their statistics.

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
exp_name = "knn_analyze"

perf_plot = "perf.png"
err_plot = "err.png"
n_cats_plot = "n_categories.png"
surf_plot = "surf.png"

scaler = 1.5
Plots.scalefontsizes(scaler)

run_slices = false
# Point to the sweep results
sweep_dir = CFAR.results_dir(
    "1_gaussian",
    # "2_art",
    # "art_dist",
    # "art_dist_2",
    "knn"
    # "art_dist_3",
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
    # "p",
#     "p12",
]

# Average for each
# dfs = groupby(df, [:travel, :rho])
dfs = groupby(df, [:travel, :k])
# vcs = [:p1, :p2, :p3, :nc1, :nc2, :nc3]
vcs = [:p1, :p2, :p3]
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


# P3
p_surf = surface(
    # dfss[!, :rho],
    dfss[!, :k],
    dfss[!, :travel],
    dfss[!, :p3_mean],
    # dfss[!, :p2_mean],
    camera=(60, 30),
    # color=:okabe_ito,
    # color=:tol_light,
    # color=:turbo,
    # xlabel="\$\\rho\$",
    # ylabel="\$c\$",
    # zlabel="\$p(T_3)\$",
    # xlabel="Vigilance \$\\rho\$",
    xlabel="k",
    ylabel="Distance \$c\$",
    zlabel="\$T_3\$ Accuracy",
    # zlabel="\$p(T_3)\$",
)

CFAR.save_plot(p_surf, surf_plot, exp_top, exp_name)

# P2
p_surf2 = surface(
    # dfss[!, :rho],
    dfss[!, :k],
    dfss[!, :travel],
    dfss[!, :p2_mean],
    # dfss[!, :p2_mean],
    camera=(60, 30),
    # color=:okabe_ito,
    # color=:tol_light,
    # color=:turbo,
    # xlabel="\$\\rho\$",
    # ylabel="\$c\$",
    # zlabel="\$p(T_3)\$",
    # xlabel="Vigilance \$\\rho\$",
    xlabel="k",
    ylabel="Distance \$c\$",
    zlabel="\$T_2\$ Accuracy",
    # zlabel="\$p(T_3)\$",
    xlims=[0.81, 1.0],
    zlims=[0.0, 1.0],
    ylims=[0.01, 20],
)

CFAR.save_plot(p_surf2, "p2_surf.png", exp_top, exp_name)

# dfss_rho = combine(groupby(dfss, :rho)[7], :)
# dfss_rho = combine(groupby(df, :rho)[7], :)

# seven = false
# seven = true
# if seven

# rho=0.7
# dfss_rho = combine(groupby(df, :rho)[7], :)
dfss_rho = combine(groupby(df, :k)[1], :)


# Plot the average trendlines
p1 = CFAR.plot_2d_attrs(
    # df,
    # dfss,
    dfss_rho,
    attrs,
    labels=["\$p_1\$", "\$p_2\$", "\$p_3\$"],
    avg=true,
    n=100,
    xlabel="Distance \$c\$",
    ylabel="Single-Task Accuracy",
    # title="Peformances",
    ylims=[0.0, 1.0],
)
CFAR.save_plot(p1, perf_plot, exp_top, exp_name)

# Plot the StatsPlots error lines
p2 = CFAR.plot_2d_errlines(
    # df,
    # dfss,
    dfss_rho,
    attrs,
    labels=["\$p_1\$", "\$p_2\$", "\$p_3\$"],
    # avg=true,
    n=100,
    xlabel="Distance \$c\$",
    ylabel="Single-Task Accuracy",
    # title="Performances with Error Bars",
    ylims=[0.0, 1.0],
)
CFAR.save_plot(p2, err_plot, exp_top, exp_name)


# rho=1.0
# else
# dfss_group = groupby(df, :rho)
dfss_group = groupby(df, :k)
dfss_keys = keys(dfss_group)
dfss_rho = combine(dfss_group[dfss_keys[end]], :)


# Plot the average trendlines
p1 = CFAR.plot_2d_attrs(
    # df,
    # dfss,
    dfss_rho,
    attrs,
    labels=["\$p_1\$", "\$p_2\$", "\$p_3\$"],
    avg=true,
    n=100,
    xlabel="Distance \$c\$",
    ylabel="Single-Task Accuracy",
    # title="Peformances",
    ylims=[0.0, 1.0],
)
CFAR.save_plot(p1, "perf-10.png", exp_top, exp_name)

# Plot the StatsPlots error lines
p2 = CFAR.plot_2d_errlines(
    # df,
    # dfss,
    dfss_rho,
    attrs,
    labels=["\$p_1\$", "\$p_2\$", "\$p_3\$"],
    # avg=true,
    n=100,
    xlabel="Distance \$c\$",
    ylabel="Single-Task Accuracy",
    # title="Performances with Error Bars",
    ylims=[0.0, 1.0],
)
CFAR.save_plot(p2, "err-10.png", exp_top, exp_name)

# end







# dfss_rho = combine(groupby(df, :rho)[7], :)
# OLD
# for ix in eachindex(attrs)
#     rename!(dfss_rho, Symbol(m_attrs[ix]) => Symbol(attrs[ix]))
# end

# Plot the average trendlines
# p1 = CFAR.plot_2d_attrs(
#     # df,
#     # dfss,
#     dfss_rho,
#     attrs,
#     labels=["\$p_1\$", "\$p_2\$", "\$p_3\$"],
#     avg=true,
#     n=100,
#     xlabel="Distance \$c\$",
#     ylabel="Single-Task Accuracy",
#     # title="Peformances",
# )
# CFAR.save_plot(p1, perf_plot, exp_top, exp_name)

# # Plot the StatsPlots error lines
# p2 = CFAR.plot_2d_errlines(
#     # df,
#     # dfss,
#     dfss_rho,
#     attrs,
#     labels=["\$p_1\$", "\$p_2\$", "\$p_3\$"],
#     # avg=true,
#     n=100,
#     xlabel="Distance \$c\$",
#     ylabel="Single-Task Accuracy",
#     # title="Performances with Error Bars",
# )
# CFAR.save_plot(p2, err_plot, exp_top, exp_name)




# -----------------------------------------------------------------------------
# CLUSTERS
# -----------------------------------------------------------------------------


# # Point to the sweep results
# sweep_dir2 = CFAR.results_dir(
#     "1_gaussian",
#     "cvi",
# )

# # Collect the results into a single dataframe
# df2 = collect_results!(sweep_dir2)
# # df = collect_results(sweep_dir)

# sort!(df2, [:travel])


# attrs2 = [
#     "cvi",
# ]


# # rho=0.7
# dfss_rho = combine(groupby(df, :rho)[7], :)


# c_attrs = [
#     # "nc1_mean",
#     # "nc2_mean",
#     # "nc3_mean",
#     "nc1",
#     "nc2",
#     "nc3",
# #     "p12",
# ]

# # Plot the number of categories
# p3= CFAR.plot_2d_attrs(
#     # df,
#     # dfss,
#     dfss_rho,
#     c_attrs,
#     labels=["\$n_1\$", "\$n_2\$", "\$n_3\$"],
#     # attrs,
#     avg=true,
#     n=100,
#     xlabel="Distance \$c\$",
#     ylabel="Single-Task Category Count",
#     # title="Number of Categories",
#     # ylims=[0.0, 2.3]
# )
# CFAR.save_plot(p3, n_cats_plot, exp_top, exp_name)

# # Plot the StatsPlots error lines
# p4 = CFAR.plot_2d_errlines(
#     # df,
#     # dfss,
#     dfss_rho,
#     c_attrs,
#     labels=["\$n_1\$", "\$n_2\$", "\$n_3\$"],
#     # attrs,
#     # labelfontsize=30,
#     # legendfontsize=30,
#     scalefonts=30,
#     n=100,
#     # title="Number of Categories with 1-Sigma Bars",
#     # fontsize=35,
#     xlabel="Distance \$c\$",
#     ylabel="Single-Task Category Count",
# )
# # Plots.scalefontsizes(0.5)
# CFAR.save_plot(p4, "nc_err", exp_top, exp_name)



# p4 = CFAR.plot_2d_errlines_double(
#     # df,
#     # dfss,
#     dfss_rho,
#     df2,
#     c_attrs,
#     attrs2,
#     labels=["\$n_1\$", "\$n_2\$", "\$n_3\$"],
#     labels2=["Silhouette"],
#     # attrs,
#     # labelfontsize=30,
#     # legendfontsize=30,
#     scalefonts=30,
#     n=100,
#     # title="Number of Categories with 1-Sigma Bars",
#     # fontsize=35,
#     xlabel="Distance \$c\$",
#     ylabel="Single-Task Category Count",
# )

# CFAR.save_plot(p4, "nc-sil.png", exp_top, exp_name)

# p4 = CFAR.plot_2d_errlines_overlay(
#     # df,
#     # dfss,
#     dfss_rho,
#     df2,
#     c_attrs,
#     attrs2,
#     labels=["\$nc_1\$", "\$nc_2\$", "\$nc_3\$"],
#     labels2=["Silhouette CVI"],
#     # attrs,
#     # labelfontsize=30,
#     # legendfontsize=30,
#     scalefonts=30,
#     n=100,
#     # title="Number of Categories with 1-Sigma Bars",
#     # fontsize=35,
#     xlabel="Distance \$c\$",
#     # ylabel="Single-Task Category Count",
# )
# CFAR.save_plot(p4, "nc-sil2.png", exp_top, exp_name)

# # -----------------------------------------------------------------------------
# # CATEGORIES SLICES
# # -----------------------------------------------------------------------------

# if run_slices
#     slices = [5.0, 10.0, 20.0]
#     for slice in slices
#         # slice = 20.0
#         eta = 0.03
#         local_df = df[abs.(df.travel .- slice) .< eta, :]
#         # local_df = df[abs.(df.travel .- 10.0) .< 0.03, :]

#         p5 = plot()
#         for ix = 1:3
#             histogram!(
#                 p5,
#                 local_df[!, "nc$(ix)"],
#                 label="nc$(ix)",
#                 # title="Number of Categories",
#                 xlabel="Travel",
#                 ylabel="Number of Categories",
#                 legend=:topleft,
#                 # color=:blue,
#                 # lw=2,
#                 # xticks=0:0.1:1.0,
#                 # yticks=0:1:10,
#                 # size=(800, 600),
#             )
#         end
#         display(p5)
#         CFAR.save_plot(p5, "slice-$(Int(slice))", exp_top, exp_name)
#     end
# end

# -----------------------------------------------------------------------------
# CLEANUP
# -----------------------------------------------------------------------------

Plots.scalefontsizes()
@info "Done plotting for $(exp_name)"
