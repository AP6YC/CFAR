using Revise
using CFAR

# config_file = "cvi.yml"
# config_file = "art-dist.yml"
# pargs = CFAR.dist_exp_parse("CFAR experiment.")
# opts = CFAR.load_opts(config_file, pargs)

# sim_params = CFAR.config_to_params(opts, pargs)


# CFAR.run_exp(config_file="cvi.yml")


CFAR.run_exp(config_file="art-dist.yml")
