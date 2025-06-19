using Revise
using CFAR

pargs = CFAR.dist_exp_parse("CFAR experiment.")
opts = CFAR.load_opts("knn-dist.yml", pargs)
sim_params, varying = CFAR.config_to_params(opts, pargs)
# sim_params["travel"] = 0.1
sim_params["travel"] = 10.0
sim_params["rng_seed"] = 1.0
local_ms = CFAR.get_mover_data(sim_params, config_file="sct-gaussians.yml")
local_ds = CFAR.DataSplitCombined(local_ms)
varying