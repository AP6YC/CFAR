"""
    mg.jl

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

using AdaptiveResonance
using Distributions, Random
# using MLDataUtils
using MLUtils
using Plots

# -----------------------------------------------------------------------------
# EXPERIMENT
# -----------------------------------------------------------------------------

rng = MersenneTwister(1234)
dist1 = MvNormal(
    [0.0, 6.0],
    [1.0 0.0; 0.0 1.0]
)
dist2 = MvNormal(
    [4.5, 6.0],
    [2.0 -1.5; -1.5 2.0]
)

N_POINTS = 1000

X = hcat(rand(rng, dist1, N_POINTS), rand(rng, dist2, N_POINTS))
y = vcat(ones(Int64, N_POINTS), zeros(Int64, N_POINTS))

p1 = scatter(X[1,:], X[2,:], group=y, title="Original Data")

# (X_train, y_train), (X_test, y_test) = stratifiedobs((X, y))
(X_train, y_train), (X_test, y_test) = splitobs((X, y), at=0.8)

# Standardize data types
X_train = convert(Matrix{Float64}, X_train)
X_test = convert(Matrix{Float64}, X_test)
y_train = convert(Vector{Int}, y_train)
y_test = convert(Vector{Int}, y_test)

# Unsupervised DDVFA
art = DDVFA()
train!(art, X_train)
y_hat_test = AdaptiveResonance.classify(art, X_test)
p2 = scatter(X_test[1,:], X_test[2,:], group=y_hat_test, title="Unsupervised DDVFA")

# Supervised DDVFA
art = DDVFA()
train!(art, X_train, y=y_train)
y_hat_test = AdaptiveResonance.classify(art, X_test)
p3 = scatter(X_test[1,:], X_test[2,:], group=y_hat_test, title="Supervised DDVFA", xlabel="Performance: " * string(round(performance(y_hat_test, y_test); digits=3)))

# Supervised SFAM
art = SFAM()
train!(art, X_train, y_train)
y_hat_test = AdaptiveResonance.classify(art, X_test)
p4 = scatter(X_test[1,:], X_test[2,:], group=y_hat_test, title="Supervised SFAM", xlabel="Performance: " * string(round(performance(y_hat_test, y_test); digits=3)))

# Performance Measure + display the plots
plot(p1, p2, p3, p4, layout=(1, 4), legend = false, xtickfontsize=6, xguidefontsize=8, titlefont=font(8))
