"""
    1_gen_mg.jl

# Description
This script implements an experiment using multivariate gaussian samples for illustrating apparent catastrophic forgetting.

# Authors
- Sasha Petrenko <petrenkos@mst.edu>
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

# N_MOVES = 10
OUT_FILENAME = "gaussians.jld2"
move_plot = "mover"
exp_top = "1_gaussian"
exp_name = "1_gen_mg"
fps = 2

# -----------------------------------------------------------------------------
# DEPENDENT SETUP
# -----------------------------------------------------------------------------

out_dir(args...) = CFAR.results_dir("1_gaussian", args...)
mkpath(out_dir())
out_file = out_dir(OUT_FILENAME)

# -----------------------------------------------------------------------------
# EXPERIMENT
# -----------------------------------------------------------------------------

# Load the config dict
config = CFAR.get_gaussian_config("gaussians.yml")

# Generate the Gaussian samples
# X, y, mx, my = CFAR.gen_gaussians(config)
ms = CFAR.gen_gaussians(config)

# Visualize the data
# CFAR.plot_mover(ms, config)
CFAR.plot_mover(ms)

ms_new = deepcopy(ms)
for ix = 1:10
    global ms_new = CFAR.shift_mover(ms_new, 1.0)
    # CFAR.plot_mover(ms_new, config)
    p = CFAR.plot_mover(ms_new)
    local_name = move_plot * string(ix) * ".png"
    CFAR.save_plot(p, local_name, exp_top, exp_name)
end

ms_new = deepcopy(ms)
anim = @animate for ix = 1:10
    # circleplot(x, y, i)
    global ms_new = CFAR.shift_mover(ms_new, 1.0)
    # CFAR.plot_mover(ms_new, config)
    CFAR.plot_mover(ms_new)
    # local_name = move_plot * string(ix) * ".png"
    # CFAR.save_plot(p, local_name, exp_top, exp_name)
end
gif_savename = CFAR.results_dir(exp_top, exp_name, move_plot * ".gif")
gif(anim, gif_savename, fps=2)

# Save the mover split
CFAR.save_moversplit(ms, out_file)

# Test loading the dataset
ms_loaded = CFAR.load_moversplit(out_file)

# Arrow dev
arrow_file = out_dir("df.arrow")

# Save the arrow file
df = CFAR.save_all(ms, arrow_file)

# Check that we can load the arrow file
df2, ar = CFAR.load_all(arrow_file)

# Check the loaded dataframe from the arrow file
@info df2
# @info ar
