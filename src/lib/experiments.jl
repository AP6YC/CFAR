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
    # Shift the local dataset by the prescribed amount
    local_ms = CFAR.shift_mover(ms, d["travel"])

    # Init the SFAM module
    art = SFAM()

    # Task 1: static gaussians
    train!(
        art,
        local_ms.static.train.x,
        local_ms.static.train.y,
    )

    # Task 1: classify
    yh1 = classify(
        art,
        local_ms.static.test.x,
    )

    # Task 1: performance
    p1 = performance(
        yh1,
        local_ms.static.test.y
    )

    # Task 2: moving gaussian
    train!(
        art,
        local_ms.mover.train.x,
        local_ms.mover.train.y,
    )

    # Task 2: classify
    yh2 = classify(
        art,
        local_ms.mover.test.x,
    )

    # Task 2: performance
    p2 = performance(
        yh2,
        local_ms.mover.test.y,
    )

    yh12 = classify(
        art,
        hcat(
            local_ms.static.test.x,
            local_ms.mover.test.x,
        )
    )

    p12 = performance(
        yh12,
        vcat(
            local_ms.static.test.y,
            local_ms.mover.test.y,
        )
    )

    fulld = deepcopy(d)
    # fulld["travel_copy"] = d["travel"]
    fulld["p1"] = p1
    fulld["p2"] = p2
    fulld["p12"] = p12

    sim_save_name = dir_func(savename(d, "jld2"))

    @info "Worker $(myid()): saving to $(sim_save_name)"
    tagsave(sim_save_name, fulld)
end
