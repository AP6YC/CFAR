```@meta
DocTestSetup = quote
    using CFAR, Dates
end
```

![header](assets/downloads/header.png)

---

These pages serve as the official documentation for the `CFAR` (*Catastrophic Forgetting and Adaptive Resonance*) project.

The `CFAR` project is a development workspace for experiments targeting the analysis of catastrophic forgetting in the use of Adaptive Resonance Theory (ART) algorithms.
Due to the broad nature of the research, many tools and types of experiments are involved.
As a result, please see the relevant documentation sections about the various programming languages, tools, and experiments involved throughout the repository.

This repository is developed and maintained by Sasha Petrenko <petrenkos@mst.edu> on behalf of the Missouri University of Science and Technology (MS&T) Applied Computational Intelligence Laboratory (ACIL).

## Manual Outline

This documentation is split into the following sections:

```@contents
Pages = [
    "man/guide.md",
    "../examples/index.md",
    "man/full-index.md",
    "man/dev-index.md"
]
Depth = 1
```

The [Package Guide](@ref) provides a tutorial to the full usage of the package, while [Examples](@ref examples) gives sample workflows with the various experiments of the project.

## About These Docs

Though several different programming languages are used throughout the project, these docs are built around the `Julia` component of the project using the [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) package.

## Documentation Build

This documentation was built using [Documenter.jl](https://github.com/JuliaDocs/Documenter.jl) with the following version and OS:

```@example
using CFAR, Dates # hide
println("CFAR v$(CFAR_VERSION) docs built $(Dates.now()) with Julia $(VERSION) on $(Sys.KERNEL)") # hide
```
