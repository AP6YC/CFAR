
# -----------------------------------------------------------------------------
# ABSTRACT TYPES
# -----------------------------------------------------------------------------

"""
Abstract supertype for all train/test dataset structs in this library.
"""
abstract type TTDataset end

"""
Abstract type for data structs that represent features as matrices.
"""
abstract type MatrixData <: TTDataset end

"""
Abstract type for data structs that represent features as vectors of matrices.
"""
abstract type VectoredData <: TTDataset end

# -----------------------------------------------------------------------------
# ALIASES
# -----------------------------------------------------------------------------

"""
Alias declaring a sample as a vector of floating-point values.
"""
const Sample = Vector{Float}

"""
Alias declaring that a supervised target is an integer.
"""
const Target = Int

"""
Alias declaring that a sample batch is a vector of samples.
"""
const Samples = Vector{Sample}

"""
Alias declaring that a supervised label is a string.
"""
const Label = String

"""
Definition of features as a matrix of floating-point numbers of dimension (feature_dim, n_samples).
"""
const Features = Matrix{Float}
# const Features = ElasticMatrix{Float}

"""
Definition of targets as a vector of integers.
"""
const Targets = Vector{Target}
# const Targets = ElasticVector{Target}

"""
Definition of labels as a vector of strings.
"""
const Labels = Vector{Label}
# const Labels = ElasticVector{String}

# -----------------------------------------------------------------------------
# FUNCTIONS
# -----------------------------------------------------------------------------
