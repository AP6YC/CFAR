"""
    3_mlp.jl

# Description
Trains and tests an MLP in Python.

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

# using PythonCall

# mlp = pyimport("mlp")
# il = pyimport("importlib")
# il.reload(mlp)

mlp = CFAR.get_mlp()

# tf = pyimport("tensorflow")
# tf.config.list_physical_devices("CPU")
# tf.test.is_built_with_cuda()

# -----------------------------------------------------------------------------
# EXPERIMENT
# -----------------------------------------------------------------------------

# Load the config dict
config = CFAR.get_gaussian_config("gaussians.yml")
ms = CFAR.gen_gaussians(config)

# mlp.show_data_shape(ms)
# loss, acc = mlp.examine_data(ms)
metrics = mlp.tt_ms_mlp(ms)
loss, acc, sc_acc = metrics

