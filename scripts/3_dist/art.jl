using Revise
using CFAR

CFAR.run_exp(config_file="art-dist.yml")

# CFAR.run_exp(config_file="cvi-dist.yml")

# pargs = CFAR.dist_exp_parse("CFAR experiment.")
# opts = CFAR.load_opts("art-dist.yml", pargs)
# sim_params, varying = CFAR.config_to_params(opts, pargs)

using AdaptiveResonance

art = SFAM()
art.W
