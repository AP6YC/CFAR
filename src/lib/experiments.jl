"""
    experiments.py

# Description
Experiment functions for the project.

# Authors
- Sasha Petrenko <petrenkos@mst.edu>
"""

"""
Train and test SFAM in parallel.
"""
function train_test_mc(d::AbstractDict, ms::CFAR.MoverSplit, dir_func::Function)
    local_ms = CFAR.shift_mover(ms, d["travel"])

    fulld = deepcopy(d)
    fulld["travel_copy"] = d["travel"]

    sim_save_name = dir_func(savename(d, "jld2"))

    @info "Worker $(myid()): saving to $(sim_save_name)"
    tagsave(sim_save_name, fulld)
end
