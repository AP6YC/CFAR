"""
    mover.jl

# Description
This script implements an experiment using multivariate gaussian samples for illustrating apparent catastrophic forgetting.

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

using Distributions, Random
using DelimitedFiles
using Plots

# -----------------------------------------------------------------------------
# VARIABLES
# -----------------------------------------------------------------------------

n_start = 1.0
n_finish = 10.0
n_step = 1.0
out_filename = "gaussians.jld2"
move_plot = "mover"
exp_top = "1_gaussian"
exp_name = "1_gen_mg"
fps = 2

scaler = 1.5
Plots.scalefontsizes(scaler)

# -----------------------------------------------------------------------------
# DEPENDENT SETUP
# -----------------------------------------------------------------------------

out_dir(args...) = CFAR.results_dir("1_gaussian", args...)
mkpath(out_dir())
out_file = out_dir(out_filename)

# -----------------------------------------------------------------------------
# EXPERIMENT
# -----------------------------------------------------------------------------

# Load the config dict
config = CFAR.get_gaussian_config("sct-gaussians.yml")

# Generate the Gaussian samples
ms = CFAR.gen_sct_gaussians(config)

# Visualize the data
p = CFAR.plot_mover(
    ms,
    length=6.0,
    xlims=[-5, 15]
)
CFAR.save_plot(p, "mover_fig", exp_top, exp_name)


p = CFAR.plot_contour(
    ms,
    length=6.0,
    xlims=[-5, 15]
)
CFAR.save_plot(p, "mover_contour", exp_top, exp_name)

# using Distributions

# pc = plot()
# X = range(-5, 15, length=100)
# Y = range(-4, 14, length=100)
# # ps = []
# pss1(x, y) = pdf(MvNormal(ms.config["dists"][1]["mu"], ms.config["dists"][1]["var"]), [x, y])
# pss2(x, y) = pdf(MvNormal(ms.config["dists"][2]["mu"], ms.config["dists"][2]["var"]), [x, y])
# pss3(x, y) = pdf(MvNormal(ms.config["dists"][3]["mu"], ms.config["dists"][3]["var"]), [x, y])
# ps(x, y) = pss1(x, y) + pss2(x, y) + pss3(x, y)
# # for ix = 1:3
# #     p2 = MvNormal(ms.config["dists"][ix]["mu"], ms.config["dists"][ix]["var"])
# #     # push!(ps, p2)
# #     f(x,y) = pdf(p2, [x,y])
# # end

# contourf!(pc, X, Y, ps, color=:viridis)
# display(pc)



Plots.scalefontsizes()

# # Create an animation, saving the frames in between
# anim = @animate for ix = n_start:n_step:n_finish
#     local_ms = CFAR.shift_mover(ms, ix)
#     p = CFAR.plot_mover(local_ms)
#     local_name = move_plot * string(ix) * ".png"
#     CFAR.save_plot(p, local_name, exp_top, exp_name)
#     p
# end

# # Point to the animation savename and save as a gif
# gif_savename = CFAR.results_dir(exp_top, exp_name, move_plot * ".gif")
# gif(anim, gif_savename, fps=2)

# # Save the mover split
# CFAR.save_moversplit(ms, out_file)

# # Test loading the dataset
# ms_loaded = CFAR.load_moversplit(out_file)
