using Revise
using CFAR

# Full experiment
CFAR.run_exp(config_file="knn-dist.yml")


# using NearestNeighbors

# data = rand(3, 10^4)
# k = 3
# point = rand(3)

# kdtree = KDTree(data)
# idxs, dists = knn(kdtree, point, k, true)

# idxs

# dists

# # Multiple points
# points = rand(3, 4)
# idxs, dists = knn(kdtree, points, k, true)

# idxs




# pargs = CFAR.dist_exp_parse("CFAR experiment.")
# opts = CFAR.load_opts("knn-dist.yml", pargs)
# sim_params, varying = CFAR.config_to_params(opts, pargs)
# # sim_params["travel"] = 0.1
# sim_params["travel"] = 10.0
# sim_params["rng_seed"] = 1.0
# local_ms = CFAR.get_mover_data(sim_params, config_file="sct-gaussians.yml")
# local_ds = CFAR.DataSplitCombined(local_ms)





# # idxs, dists = knn()
# kdtree = KDTree(local_ds.train.x)
# idxs, dists = knn(kdtree, local_ds.test.x, k, true)

# local_ds.train.y[idxs[1]]

# # u=unique(y)
# # d=Dict([(i,count(x->x==i,y)) for i in u])
# # println("count for 10 is $(d[10])")

# function train_kd(local_ds::CFAR.DataSplitCombined)
#     kdtree = KDTree(local_ds.train.x)
# # idxs, dists = knn(kdtree, local_ds.test.x, k, true)
#     return kdtree
# end

# using StatsBase

# # function classify_kd(local_ds::CFAR.DataSplitCombined, kdtree::T) where {T <: KDTree}
# function classify_kd(local_ds::CFAR.DataSplitCombined, kdtree::KDTree, k:Int)
#     idxs, dists = knn(kdtree, local_ds.test.x, k, true)
#     # y_vecs = [local_ds.train.y[idx] for idx in idxs]
#     y_hats = zeros(Int, length(idxs))
#     for ix in eachindex(idxs)
#         y_hats[ix] = Int(mode(local_ds.train.y[idxs[ix]]))
#     end
#     return y_hats
# end

# function classify_kd(local_ds::CFAR.DataSplitCombined, local_ms::CFAR.SCTMoverSplit, kdtree::KDTree, ind::Int, k::Int)
#     idxs, dists = knn(kdtree, local_ms.data[ind].test.x, k, true)
#     y_hats = zeros(Int, length(idxs))
#     for ix in eachindex(idxs)
#         y_hats[ix] = Int(mode(local_ds.train.y[idxs[ix]]))
#     end
#     return y_hats
# end


# kdtree = train_kd(local_ds)
# y_hats = classify_kd(local_ds, kdtree)

# y_hats1 = classify_kd(local_ms, kdtree, 1)
# y_hats2 = classify_kd(local_ds, local_ms, kdtree, 2)
# y_hats3 = classify_kd(local_ds, local_ms, kdtree, 3)