
"""
A single dataset of vectored labeled data with [`Features`](@ref), [`Targets`](@ref), and human-readable string [`Labels`](@ref).
"""
struct VectorLabeledDataset
    """
    A vector of [`Features`](@ref) matrices.
    """
    x::Vector{Features}
    # x::Vector{Sample}

    """
    A vector of [`Targets`](@ref) corresponding to the [`Features`](@ref).
    """
    y::Vector{Targets}
    # y::Vector{Target}

    """
    String [`Labels`](@ref) corresponding to the [`Targets`](@ref).
    """
    labels::Labels
end


"""
Constructor for a [`VectorLabeledDataset`](@ref) transformed from an existing [`LabeledDataset`](@ref).

# Arguments
- `data::LabeledDataset`: the [`LabeledDataset`](@ref) to turn into a corresponding vectorized version.
"""
function VectorLabeledDataset(
    data::LabeledDataset
)
    n_samples = length(data.y)
    x_vec = Vector{Vector{Float}}()
    # y_vec = Vector{Int}()
    for ix = 1:n_samples
        push!(x_vec, data.x[:, ix])
        # push!(y_vec, data.y[ix])
    end

    return VectorLabeledDataset(
        x_vec,
        # y_vec,
        data.y,
        data.labels,
    )
end