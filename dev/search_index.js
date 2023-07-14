var documenterSearchIndex = {"docs":
[{"location":"man/guide/#Package-Guide","page":"Guide","title":"Package Guide","text":"","category":"section"},{"location":"man/guide/","page":"Guide","title":"Guide","text":"TODO","category":"page"},{"location":"examples/tutorials/julia/#julia","page":"Julia Tutorial","title":"Julia Tutorial","text":"","category":"section"},{"location":"examples/tutorials/julia/","page":"Julia Tutorial","title":"Julia Tutorial","text":"(Image: Source code) (Image: notebook) (Image: compat) (Image: Author) (Image: Update time)","category":"page"},{"location":"examples/tutorials/julia/#Overview","page":"Julia Tutorial","title":"Overview","text":"","category":"section"},{"location":"examples/tutorials/julia/","page":"Julia Tutorial","title":"Julia Tutorial","text":"This demo shows how to interact with Julia to get started with DCCR experiments.","category":"page"},{"location":"examples/tutorials/julia/#Setup","page":"Julia Tutorial","title":"Setup","text":"","category":"section"},{"location":"examples/tutorials/julia/","page":"Julia Tutorial","title":"Julia Tutorial","text":"Just as in most languages, dependencies are usually loaded first in Julia scripts. These dependences are included through either using or import statements:","category":"page"},{"location":"examples/tutorials/julia/","page":"Julia Tutorial","title":"Julia Tutorial","text":"# `using` brings all of the names that are exported by the package into this context\nusing Dates\n\n# `import` simply brings the name itself without exports, so to use sub components\nimport Downloads","category":"page"},{"location":"examples/tutorials/julia/#Running-Julia-Code","page":"Julia Tutorial","title":"Running Julia Code","text":"","category":"section"},{"location":"examples/tutorials/julia/","page":"Julia Tutorial","title":"Julia Tutorial","text":"To run Julia code, open the REPL in a command terminal with julia:","category":"page"},{"location":"examples/tutorials/julia/","page":"Julia Tutorial","title":"Julia Tutorial","text":"TODO","category":"page"},{"location":"examples/tutorials/julia/#Additional-Reading","page":"Julia Tutorial","title":"Additional Reading","text":"","category":"section"},{"location":"examples/tutorials/julia/","page":"Julia Tutorial","title":"Julia Tutorial","text":"This example reveals just the tip of the iceberg of how to write and run Julia code. To learn more about the Julia programming language, see the extensive Official Julia Documentation. The Manual contains all information necessary to understand the syntax and workings of the language itself. The Base documentation lists the essential native types and utilities embedded in the language. The Standard Library is a collection of additional packages that are so useful that they are always available in Julia without additional installation.","category":"page"},{"location":"examples/tutorials/julia/","page":"Julia Tutorial","title":"Julia Tutorial","text":"","category":"page"},{"location":"examples/tutorials/julia/","page":"Julia Tutorial","title":"Julia Tutorial","text":"This page was generated using DemoCards.jl and Literate.jl.","category":"page"},{"location":"examples/#examples","page":"Examples","title":"Examples","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"This section contains some examples using the CFAR package with topics ranging from how to the internals of package work to practical examples on different datasets.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"These examples are separated into the following sections:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Tutorials: basic Julia examples that also include how low-level routines work in this package.\nExperiments: how to run experiments in the package.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"","category":"page"},{"location":"examples/#Tutorials","page":"Examples","title":"Tutorials","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"These examples demonstrate some low-level usage of the Julia programming language and subroutines of the CFAR project itself.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"<div class=\"grid-card-section\">","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"<div class=\"card grid-card\">\n<div class=\"grid-card-cover\">\n<div class=\"grid-card-description\">","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"This demo provides a quick example of how to run a Julia script.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"</div>","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"(Image: card-cover-image)","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"</div>\n<div class=\"grid-card-text\">","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Julia Tutorial","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"</div>\n</div>","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"</div>","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"","category":"page"},{"location":"examples/#examples-attribution","page":"Examples","title":"Attribution","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"Icons used for the covers of these demo cards are attributed to the following sites:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Official Julia logo graphics","category":"page"},{"location":"","page":"Home","title":"Home","text":"DocTestSetup = quote\n    using CFAR, Dates\nend","category":"page"},{"location":"","page":"Home","title":"Home","text":"<img src=\"assets/logo.png\" width=\"300\">","category":"page"},{"location":"#CFAR","page":"Home","title":"CFAR","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"These pages serve as the official documentation for the CFAR (Catastrophic Forgetting and Adaptive Resonance) project.","category":"page"},{"location":"","page":"Home","title":"Home","text":"The CFAR project is a development workspace for experiments targeting the analysis of catastrophic forgetting in the use of Adaptive Resonance Theory (ART) algorithms. Due to the broad nature of the research, many tools and types of experiments are involved. As a result, please see the relevant documentation sections about the various programming languages, tools, and experiments involved throughout the repository.","category":"page"},{"location":"","page":"Home","title":"Home","text":"This repository is developed and maintained by Sasha Petrenko <petrenkos@mst.edu> on behalf of the Missouri University of Science and Technology (MS&T) Applied Computational Intelligence Laboratory (ACIL).","category":"page"},{"location":"#Manual-Outline","page":"Home","title":"Manual Outline","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This documentation is split into the following sections:","category":"page"},{"location":"","page":"Home","title":"Home","text":"Pages = [\n    \"man/guide.md\",\n    \"../examples/index.md\",\n]\nDepth = 1","category":"page"},{"location":"","page":"Home","title":"Home","text":"The Package Guide provides a tutorial to the full usage of the package, while Examples gives sample workflows with the various experiments of the project.","category":"page"},{"location":"#About-These-Docs","page":"Home","title":"About These Docs","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Though several different programming languages are used throughout the project, these docs are built around the Julia component of the project using the Documenter.jl package.","category":"page"},{"location":"#Documentation-Build","page":"Home","title":"Documentation Build","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This documentation was built using Documenter.jl with the following version and OS:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using CFAR, Dates # hide\nprintln(\"CFAR v$(CFAR_VERSION) docs built $(Dates.now()) with Julia $(VERSION) on $(Sys.KERNEL)\") # hide","category":"page"}]
}
