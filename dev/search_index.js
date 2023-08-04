var documenterSearchIndex = {"docs":
[{"location":"man/contributing/#Contributing","page":"Contributing","title":"Contributing","text":"","category":"section"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"This page serves as the contribution guide for the SFAR package. From top to bottom, the ways of contributing are:","category":"page"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"GitHub Issues: how to raise an issue with the project.\nJulia Development: how to download and interact with the package.\nGitFlow: how to directly contribute code to the package in an organized way on GitHub.\nDevelopment Details: how the internals of the package are currently setup if you would like to directly contribute code.","category":"page"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"Please also see the Attribution to learn about the authors and sources of support for the project.","category":"page"},{"location":"man/contributing/#Issues","page":"Contributing","title":"Issues","text":"","category":"section"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"The main point of contact is the GitHub issues page for the project. This is the easiest way to contribute to the project, as any issue you find or request you have will be addressed there by the authors of the package. Depending on the issue, the authors will collaborate with you, and after making changes they will link a pull request which addresses your concern or implements your proposed changes.","category":"page"},{"location":"man/contributing/#Julia-Development","page":"Contributing","title":"Julia Development","text":"","category":"section"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"As a Julia package, development follows the usual procedure:","category":"page"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"Clone the project from GitHub\nSwitch to or create the branch that you wish work on (see GitFlow).\nStart Julia at your development folder.\nInstantiate the package (i.e., download and install the package dependencies).","category":"page"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"For example, you can get the package and startup Julia with","category":"page"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"git clone git@github.com:AP6YC/SFAR.jl.git\njulia --project=.","category":"page"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"note: Note\nIn Julia, you must activate your project in the current REPL to point to the location/scope of installed packages. The above immediately activates the project when starting up Julia, but you may also separately startup the julia and activate the package with the interactive package manager via the ] syntax:julia\njulia> ]\n(@v1.9) pkg> activate .\n(SFAR) pkg>","category":"page"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"You may run the package's unit tests after the above setup in Julia with","category":"page"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"julia> using Pkg\njulia> Pkg.instantiate()\njulia> Pkg.test()","category":"page"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"or interactively though the Julia package manager with","category":"page"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"julia> ]\n(SFAR) pkg> instantiate\n(SFAR) pkg> test","category":"page"},{"location":"man/contributing/#GitFlow","page":"Contributing","title":"GitFlow","text":"","category":"section"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"The SFAR package follows the GitFlow git working model. The original post by Vincent Driessen outlines this methodology quite well, while Atlassian has a good tutorial as well. In summary:","category":"page"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"Create a feature branch off of the develop branch with the name feature/<my-feature-name>.\nCommit your changes and push to this feature branch.\nWhen you are satisfied with your changes, initiate a GitHub pull request (PR) to merge the feature branch with develop.\nIf the unit tests pass, the feature branch will first be merged with develop and then be deleted.\nReleases will be periodically initiated from the develop branch and versioned onto the master branch.\nImmediate bug fixes circumvent this process through a hotfix branch off of master.","category":"page"},{"location":"man/contributing/#Development-Details","page":"Contributing","title":"Development Details","text":"","category":"section"},{"location":"man/contributing/#Documentation","page":"Contributing","title":"Documentation","text":"","category":"section"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"These docs are currently hosted as a static site on the GitHub pages platform. They are setup to be built and served in a separate branch called gh-pages from the master/development branches of the project.","category":"page"},{"location":"man/contributing/#Package-Structure","page":"Contributing","title":"Package Structure","text":"","category":"section"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"The SFAR project has the following file structure:","category":"page"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"SFAR\n├── .github/workflows       // GitHub: workflows for testing and documentation.\n├── cluster                 // HPC: scripts and submission files for clusters.\n├── dockerfiles             // Docker: dockerfiles for experiment reproducibility.\n├── docs                    // Docs: documentation for the module.\n│   └───src                 //      Documentation source files.\n├── notebooks               // Source: experiment notebooks.\n├── scripts                 // Source: experiment scripts.\n├── src                     // Source: library source code.\n│   └───lib                 //      Library for the SFAR module.\n│       └───utils           //      Project utilities\n├── test                    // Test: Unit, integration, and environment tests.\n├── work                    // Data: datasets, results, plots, etc.\n│   ├───data                //      Source datasets for experiments.\n│   └───results             //      Destination for generated figures, etc.\n├── .gitattributes          // Git: LFS settings, languages, etc.\n├── .gitignore              // Git: .gitignore for the whole project.\n├── CODE_OF_CONDUCT.md      // Doc: the code of conduct for contributors.\n├── CONTRIBUTING.md         // Doc: contributing guide (points to this page).\n├── LICENSE                 // Doc: the license to the project.\n├── Project.toml            // Julia: the Pkg.jl dependencies of the project.\n└── README.md               // Doc: the top-level readme for the project.","category":"page"},{"location":"man/contributing/#Type-Aliases","page":"Contributing","title":"Type Aliases","text":"","category":"section"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"For convenience in when defining types and function signatures, this package uses the NumericalTypeAliases.jl package and the aliases therein. The documentation for the abstract and concrete types provided by NumericalTypeAliases.jl can be found here.","category":"page"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"In this package, data samples are always Real-valued, whereas class labels are integered. Furthermore, independent class labels are always Int because of the Julia native support for a given system's signed native integer type.","category":"page"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"This project does not currently test for the support of arbitrary precision arithmetic because learning algorithms in general do not have a significant need for precision.","category":"page"},{"location":"man/contributing/#Attribution","page":"Contributing","title":"Attribution","text":"","category":"section"},{"location":"man/contributing/#Authors","page":"Contributing","title":"Authors","text":"","category":"section"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"This package is developed and maintained by Sasha Petrenko with sponsorship by the Applied Computational Intelligence Laboratory (ACIL).","category":"page"},{"location":"man/contributing/","page":"Contributing","title":"Contributing","text":"If you simply have suggestions for improvement, Sasha Petrenko (<petrenkos@mst.edu>) is the current developer and maintainer of the SFAR package, so please feel free to reach out with thoughts and questions.","category":"page"},{"location":"man/dev-index/#dev-main-index","page":"Dev Index","title":"Developer Index","text":"","category":"section"},{"location":"man/dev-index/","page":"Dev Index","title":"Dev Index","text":"This page lists the types and functions that are internal to the CFAR package. Because they are not part of the public API, these names might change relatively frequently between versions and so should not be relied upon.","category":"page"},{"location":"man/dev-index/","page":"Dev Index","title":"Dev Index","text":"All internal names are listed in the Index, and each of these entries link to the docstrings in the Docs section.","category":"page"},{"location":"man/dev-index/#Index","page":"Dev Index","title":"Index","text":"","category":"section"},{"location":"man/dev-index/","page":"Dev Index","title":"Dev Index","text":"This section contains a list of internal names that link to their corresponding Documentation.","category":"page"},{"location":"man/dev-index/#dev-index-methods","page":"Dev Index","title":"Methods","text":"","category":"section"},{"location":"man/dev-index/","page":"Dev Index","title":"Dev Index","text":"Pages   = [\"dev-index.md\"]\nModules = [CFAR]\nOrder = [:function]","category":"page"},{"location":"man/dev-index/#dev-index-types","page":"Dev Index","title":"Types","text":"","category":"section"},{"location":"man/dev-index/","page":"Dev Index","title":"Dev Index","text":"Pages   = [\"dev-index.md\"]\nModules = [CFAR]\nOrder = [:type]","category":"page"},{"location":"man/dev-index/#dev-index-types-2","page":"Dev Index","title":"Constants","text":"","category":"section"},{"location":"man/dev-index/","page":"Dev Index","title":"Dev Index","text":"Pages   = [\"dev-index.md\"]\nModules = [CFAR]\nOrder = [:constant]","category":"page"},{"location":"man/dev-index/#dev-index-docs","page":"Dev Index","title":"Docs","text":"","category":"section"},{"location":"man/dev-index/","page":"Dev Index","title":"Dev Index","text":"Documentation for all internal names are listed below.","category":"page"},{"location":"man/dev-index/","page":"Dev Index","title":"Dev Index","text":"Modules = [CFAR]\nPublic = false","category":"page"},{"location":"man/dev-index/#CFAR.ARG_CONFIG_DICT","page":"Dev Index","title":"CFAR.ARG_CONFIG_DICT","text":"ARGCONFIGDICT\n\nDescription\n\nCommon docstring: config dictionary argument.\n\n\n\n\n\n","category":"constant"},{"location":"man/dev-index/#CFAR.ARG_CONFIG_FILE","page":"Dev Index","title":"CFAR.ARG_CONFIG_FILE","text":"ARGCONFIGFILE\n\nDescription\n\nCommon docstring: config filename argument.\n\n\n\n\n\n","category":"constant"},{"location":"man/dev-index/#CFAR.DRWATSON_ARGS_DOC","page":"Dev Index","title":"CFAR.DRWATSON_ARGS_DOC","text":"DRWATSONARGSDOC\n\nDescription\n\nCommon docstring, the arguments to DrWatson-style directory functions.\n\n\n\n\n\n","category":"constant"},{"location":"man/dev-index/#CFAR.Data","page":"Dev Index","title":"CFAR.Data","text":"Abstract supertype for all Data structs in this library.\n\n\n\n\n\n","category":"type"},{"location":"man/dev-index/#CFAR.DataSplit","page":"Dev Index","title":"CFAR.DataSplit","text":"A basic struct for encapsulating the components of supervised training.\n\n\n\n\n\n","category":"type"},{"location":"man/dev-index/#CFAR.DataSplitCombined","page":"Dev Index","title":"CFAR.DataSplitCombined","text":"A struct for combining training and validation data, containing only train and test splits.\n\n\n\n\n\n","category":"type"},{"location":"man/dev-index/#CFAR.DataSplitCombined-Tuple{CFAR.DataSplit}","page":"Dev Index","title":"CFAR.DataSplitCombined","text":"Constructs a DataSplitCombined from an existing DataSplit by consolidating the training and validation data.\n\nArguments\n\ndata::DataSplit: the DataSplit struct for consolidating validation Features and Labels into the training data.\n\n\n\n\n\n","category":"method"},{"location":"man/dev-index/#CFAR.DataSplitIndexed","page":"Dev Index","title":"CFAR.DataSplitIndexed","text":"A struct for encapsulating the components of supervised training in vectorized form.\n\n\n\n\n\n","category":"type"},{"location":"man/dev-index/#CFAR.Features","page":"Dev Index","title":"CFAR.Features","text":"Definition of features as a matrix of floating-point numbers of dimension (featuredim, nsamples).\n\n\n\n\n\n","category":"type"},{"location":"man/dev-index/#CFAR.LabeledDataset","page":"Dev Index","title":"CFAR.LabeledDataset","text":"A single dataset of Features, Targets, and human-readable string Labels.\n\n\n\n\n\n","category":"type"},{"location":"man/dev-index/#CFAR.LabeledDataset-Tuple{CFAR.LabeledDataset, CFAR.LabeledDataset}","page":"Dev Index","title":"CFAR.LabeledDataset","text":"A constructor for a LabeledDataset that merges two other LabeledDatasets.\n\nArguments\n\nd1::LabeledDataset: the first LabeledDataset to consolidate.\nd2::LabeledDataset: the second LabeledDataset to consolidate.\n\n\n\n\n\n","category":"method"},{"location":"man/dev-index/#CFAR.Labels","page":"Dev Index","title":"CFAR.Labels","text":"Definition of labels as a vector of strings.\n\n\n\n\n\n","category":"type"},{"location":"man/dev-index/#CFAR.MatrixData","page":"Dev Index","title":"CFAR.MatrixData","text":"Abstract type for Data structs that represent features as matrices.\n\n\n\n\n\n","category":"type"},{"location":"man/dev-index/#CFAR.MoverSplit","page":"Dev Index","title":"CFAR.MoverSplit","text":"\n\n\n\n","category":"type"},{"location":"man/dev-index/#CFAR.Targets","page":"Dev Index","title":"CFAR.Targets","text":"Definition of targets as a vector of integers.\n\n\n\n\n\n","category":"type"},{"location":"man/dev-index/#CFAR.VectorLabeledDataset","page":"Dev Index","title":"CFAR.VectorLabeledDataset","text":"A single dataset of vectored labeled data with Features, Targets, and human-readable string Labels.\n\n\n\n\n\n","category":"type"},{"location":"man/dev-index/#CFAR.VectoredData","page":"Dev Index","title":"CFAR.VectoredData","text":"Abstract type for Data structs that represent features as vectors of matrices.\n\n\n\n\n\n","category":"type"},{"location":"man/dev-index/#CFAR.config_dir-Tuple","page":"Dev Index","title":"CFAR.config_dir","text":"config_dir(args...) -> String\n\n\nSummary\n\nPoints to the configs directory.\n\nArguments\n\nargs...: the string directories to append to the directory.\n\nMethod List / Definition Locations\n\nconfig_dir(args)\n\ndefined at /home/runner/work/CFAR/CFAR/src/lib/utils/drwatson.jl:53.\n\n\n\n\n\n","category":"method"},{"location":"man/dev-index/#CFAR.data_dir-Tuple","page":"Dev Index","title":"CFAR.data_dir","text":"data_dir(args...) -> String\n\n\nSummary\n\nPoints to the data directory.\n\nArguments\n\nargs...: the string directories to append to the directory.\n\nMethod List / Definition Locations\n\ndata_dir(args)\n\ndefined at /home/runner/work/CFAR/CFAR/src/lib/utils/drwatson.jl:42.\n\n\n\n\n\n","category":"method"},{"location":"man/dev-index/#CFAR.gen_gaussians-Tuple{AbstractDict}","page":"Dev Index","title":"CFAR.gen_gaussians","text":"gen_gaussians(config::AbstractDict) -> NTuple{4, Any}\n\n\nSummary\n\nGenerates Gaussian distributed samples from the provided configuration dictionary.\n\nArguments\n\nconfig::AbstractDict: the config parameters as a dictionary.\n\nMethod List / Definition Locations\n\ngen_gaussians(config)\n\ndefined at /home/runner/work/CFAR/CFAR/src/lib/utils/file.jl:109.\n\n\n\n\n\n","category":"method"},{"location":"man/dev-index/#CFAR.gen_gaussians-Tuple{AbstractString}","page":"Dev Index","title":"CFAR.gen_gaussians","text":"gen_gaussians(config_file::AbstractString) -> NTuple{4, Any}\n\n\nSummary\n\nGenerate the Gaussian dataset from the parameters specified in the provided file.\n\nArguments\n\nconfig_file::AbstractString: the config file name as a string.\n\nMethod List / Definition Locations\n\ngen_gaussians(config_file)\n\ndefined at /home/runner/work/CFAR/CFAR/src/lib/utils/file.jl:164.\n\n\n\n\n\n","category":"method"},{"location":"man/dev-index/#CFAR.get_dists-Tuple{AbstractDict}","page":"Dev Index","title":"CFAR.get_dists","text":"get_dists(\n    config::AbstractDict\n) -> Vector{Distributions.MvNormal}\n\n\nSummary\n\nGets the distribution generators based upon the config parameters.\n\nArguments\n\nconfig::AbstractDict: the config parameters as a dictionary.\n\nMethod List / Definition Locations\n\nget_dists(config)\n\ndefined at /home/runner/work/CFAR/CFAR/src/lib/utils/file.jl:72.\n\n\n\n\n\n","category":"method"},{"location":"man/dev-index/#CFAR.get_gaussian_config-Tuple{AbstractString}","page":"Dev Index","title":"CFAR.get_gaussian_config","text":"get_gaussian_config(config_file::AbstractString) -> Any\n\n\nSummary\n\nLoads the Gaussian distribution parameters from the provided config file.\n\nArguments\n\nconfig_file::AbstractString: the config file name as a string.\n\nMethod List / Definition Locations\n\nget_gaussian_config(config_file)\n\ndefined at /home/runner/work/CFAR/CFAR/src/lib/utils/file.jl:52.\n\n\n\n\n\n","category":"method"},{"location":"man/dev-index/#CFAR.get_mover_direction-Tuple{AbstractDict}","page":"Dev Index","title":"CFAR.get_mover_direction","text":"get_mover_direction(config::AbstractDict) -> Any\n\n\nSummary\n\nGenerates a vector representing the direction of the mover's line.\n\nArguments\n\nconfig::AbstractDict: the config parameters as a dictionary.\n\nMethod List / Definition Locations\n\nget_mover_direction(config)\n\ndefined at /home/runner/work/CFAR/CFAR/src/lib/utils/file.jl:177.\n\n\n\n\n\n","category":"method"},{"location":"man/dev-index/#CFAR.get_mover_line-Tuple{AbstractDict}","page":"Dev Index","title":"CFAR.get_mover_line","text":"get_mover_line(\n    config::AbstractDict;\n    n_points,\n    length\n) -> Any\n\n\nSummary\n\nGenerates a dataset of points representing the mover's direction of traversal.\n\nArguments\n\nconfig::AbstractDict: the config parameters as a dictionary.\nn_points::Integer=2: kwarg, number of points along the line to return.\nlength::Float=10.0: kwarg, length of the line.\n\nMethod List / Definition Locations\n\nget_mover_line(config; n_points, length)\n\ndefined at /home/runner/work/CFAR/CFAR/src/lib/utils/file.jl:215.\n\n\n\n\n\n","category":"method"},{"location":"man/dev-index/#CFAR.load_config-Tuple{AbstractString}","page":"Dev Index","title":"CFAR.load_config","text":"load_config(config_file::AbstractString) -> Any\n\n\nSummary\n\nWrapper for loading the configuration file with the provided filename.\n\nArguments\n\nconfig_file::AbstractString: the config file name as a string.\n\nMethod List / Definition Locations\n\nload_config(config_file)\n\ndefined at /home/runner/work/CFAR/CFAR/src/lib/utils/file.jl:41.\n\n\n\n\n\n","category":"method"},{"location":"man/dev-index/#CFAR.results_dir-Tuple","page":"Dev Index","title":"CFAR.results_dir","text":"results_dir(args...) -> String\n\n\nSummary\n\nPoints to the results directory.\n\nArguments\n\nargs...: the string directories to append to the directory.\n\nMethod List / Definition Locations\n\nresults_dir(args)\n\ndefined at /home/runner/work/CFAR/CFAR/src/lib/utils/drwatson.jl:31.\n\n\n\n\n\n","category":"method"},{"location":"man/dev-index/#CFAR.shift_samples-Tuple{AbstractMatrix{T} where T<:Real, AbstractDict, Float64}","page":"Dev Index","title":"CFAR.shift_samples","text":"shift_samples(\n    data::AbstractMatrix{T} where T<:Real,\n    config::AbstractDict,\n    s::Float64\n) -> Any\n\n\nSummary\n\nShifts the provided data samples matrix along the config direction by s amount.\n\nArguments\n\ndata::RealMatrix: the dataset of shape (n_samples, dim).\nconfig::AbstractDict: the config parameters as a dictionary.\ns::Float: the distance to travel along the line\n\nMethod List / Definition Locations\n\nshift_samples(data, config, s)\n\ndefined at /home/runner/work/CFAR/CFAR/src/lib/utils/file.jl:196.\n\n\n\n\n\n","category":"method"},{"location":"man/dev-index/#CFAR.vec_vec_to_matrix-Tuple{AbstractVector}","page":"Dev Index","title":"CFAR.vec_vec_to_matrix","text":"vec_vec_to_matrix(vec_vec::AbstractVector) -> Any\n\n\nSummary\n\nTurns a vector of vectors into a matrix.\n\nAssumes that the shape of the vector of vectors is square.\n\nArguments\n\nvec_vec::AbstractVector: a vector of vectors of numerical values.\n\nMethod List / Definition Locations\n\nvec_vec_to_matrix(vec_vec)\n\ndefined at /home/runner/work/CFAR/CFAR/src/lib/utils/file.jl:9.\n\n\n\n\n\n","category":"method"},{"location":"man/dev-index/#CFAR.work_dir-Tuple","page":"Dev Index","title":"CFAR.work_dir","text":"work_dir(args...) -> String\n\n\nSummary\n\nPoints to the work directory containing raw datasets, processed datasets, and results.\n\nArguments\n\nargs...: the string directories to append to the directory.\n\nMethod List / Definition Locations\n\nwork_dir(args)\n\ndefined at /home/runner/work/CFAR/CFAR/src/lib/utils/drwatson.jl:20.\n\n\n\n\n\n","category":"method"},{"location":"man/full-index/#main-index","page":"Index","title":"Index","text":"","category":"section"},{"location":"man/full-index/","page":"Index","title":"Index","text":"This page lists the core methods and types of the Julia component of the CFAR project.","category":"page"},{"location":"man/full-index/#Index","page":"Index","title":"Index","text":"","category":"section"},{"location":"man/full-index/","page":"Index","title":"Index","text":"This section enumerates the names exported by the package, each of which links to its corresponding Documentation.","category":"page"},{"location":"man/full-index/#index-modules","page":"Index","title":"Modules","text":"","category":"section"},{"location":"man/full-index/","page":"Index","title":"Index","text":"Pages   = [\"full-index.md\"]\nModules = [CFAR]\nOrder = [:module]","category":"page"},{"location":"man/full-index/#index-methods","page":"Index","title":"Methods","text":"","category":"section"},{"location":"man/full-index/","page":"Index","title":"Index","text":"Pages   = [\"full-index.md\"]\nModules = [CFAR]\nOrder = [:function]","category":"page"},{"location":"man/full-index/#index-types","page":"Index","title":"Types","text":"","category":"section"},{"location":"man/full-index/","page":"Index","title":"Index","text":"Pages   = [\"full-index.md\"]\nModules = [CFAR]\nOrder = [:type]","category":"page"},{"location":"man/full-index/#index-constants","page":"Index","title":"Constants","text":"","category":"section"},{"location":"man/full-index/","page":"Index","title":"Index","text":"Pages   = [\"full-index.md\"]\nModules = [CFAR]\nOrder = [:constant]","category":"page"},{"location":"man/full-index/#index-docs","page":"Index","title":"Docs","text":"","category":"section"},{"location":"man/full-index/","page":"Index","title":"Index","text":"This section lists the documentation for every exported name of the CFAR package.","category":"page"},{"location":"man/full-index/#index-modules-docs","page":"Index","title":"Modules","text":"","category":"section"},{"location":"man/full-index/","page":"Index","title":"Index","text":"Modules = [CFAR]\nPrivate = false\nOrder = [:module]","category":"page"},{"location":"man/full-index/#CFAR.CFAR","page":"Index","title":"CFAR.CFAR","text":"A module encapsulating the experimental driver code for the CFAR project.\n\nImports\n\nThe following names are imported by the package as dependencies:\n\nAdaptiveResonance\nBase\nCSV\nCore\nDataFrames\nDistributions\nDocStringExtensions\nDrWatson\nElasticArrays\nNumericalTypeAliases\nPkg\nRandom\n\nExports\n\nThe following names are exported and available when using the package:\n\nCFAR_VERSION\n\n\n\n\n\n","category":"module"},{"location":"man/full-index/#index-functions-docs","page":"Index","title":"Functions","text":"","category":"section"},{"location":"man/full-index/","page":"Index","title":"Index","text":"Modules = [CFAR]\nPrivate = false\nOrder = [:function]","category":"page"},{"location":"man/full-index/#index-types-docs","page":"Index","title":"Types","text":"","category":"section"},{"location":"man/full-index/","page":"Index","title":"Index","text":"Modules = [CFAR]\nPrivate = false\nOrder = [:type]","category":"page"},{"location":"man/full-index/#index-constants-docs","page":"Index","title":"Constants","text":"","category":"section"},{"location":"man/full-index/","page":"Index","title":"Index","text":"Modules = [CFAR]\nPrivate = false\nOrder = [:constant]","category":"page"},{"location":"man/full-index/#CFAR.CFAR_VERSION","page":"Index","title":"CFAR.CFAR_VERSION","text":"CFAR_VERSION\n\nDescription\n\nA constant that contains the version of the installed CFAR package.\n\nThis value is computed at compile time, so it may be used to programmatically verify the version of CFAR that is installed in case a compat entry in your Project.toml is missing or otherwise incorrect.\n\n\n\n\n\n","category":"constant"},{"location":"examples/tutorials/julia/#julia","page":"Julia Tutorial","title":"Julia Tutorial","text":"","category":"section"},{"location":"examples/tutorials/julia/","page":"Julia Tutorial","title":"Julia Tutorial","text":"(Image: Source code) (Image: notebook) (Image: compat) (Image: Author) (Image: Update time)","category":"page"},{"location":"examples/tutorials/julia/#Overview","page":"Julia Tutorial","title":"Overview","text":"","category":"section"},{"location":"examples/tutorials/julia/","page":"Julia Tutorial","title":"Julia Tutorial","text":"This demo shows how to interact with Julia to get started with DCCR experiments.","category":"page"},{"location":"examples/tutorials/julia/#Setup","page":"Julia Tutorial","title":"Setup","text":"","category":"section"},{"location":"examples/tutorials/julia/","page":"Julia Tutorial","title":"Julia Tutorial","text":"Just as in most languages, dependencies are usually loaded first in Julia scripts. These dependences are included through either using or import statements:","category":"page"},{"location":"examples/tutorials/julia/","page":"Julia Tutorial","title":"Julia Tutorial","text":"# `using` brings all of the names that are exported by the package into this context\nusing Dates\n\n# `import` simply brings the name itself without exports, so to use sub components\nimport Downloads","category":"page"},{"location":"examples/tutorials/julia/#Running-Julia-Code","page":"Julia Tutorial","title":"Running Julia Code","text":"","category":"section"},{"location":"examples/tutorials/julia/","page":"Julia Tutorial","title":"Julia Tutorial","text":"To run Julia code, open the REPL in a command terminal with julia:","category":"page"},{"location":"examples/tutorials/julia/","page":"Julia Tutorial","title":"Julia Tutorial","text":"TODO","category":"page"},{"location":"examples/tutorials/julia/#Additional-Reading","page":"Julia Tutorial","title":"Additional Reading","text":"","category":"section"},{"location":"examples/tutorials/julia/","page":"Julia Tutorial","title":"Julia Tutorial","text":"This example reveals just the tip of the iceberg of how to write and run Julia code. To learn more about the Julia programming language, see the extensive Official Julia Documentation. The Manual contains all information necessary to understand the syntax and workings of the language itself. The Base documentation lists the essential native types and utilities embedded in the language. The Standard Library is a collection of additional packages that are so useful that they are always available in Julia without additional installation.","category":"page"},{"location":"examples/tutorials/julia/","page":"Julia Tutorial","title":"Julia Tutorial","text":"","category":"page"},{"location":"examples/tutorials/julia/","page":"Julia Tutorial","title":"Julia Tutorial","text":"This page was generated using DemoCards.jl and Literate.jl.","category":"page"},{"location":"examples/#examples","page":"Examples","title":"Examples","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"This section contains some examples using the CFAR package with topics ranging from how to the internals of package work to practical examples on different datasets.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"These examples are separated into the following sections:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Tutorials: basic Julia examples that also include how low-level routines work in this package.\nExperiments: how to run experiments in the package.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"","category":"page"},{"location":"examples/#Tutorials","page":"Examples","title":"Tutorials","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"These examples demonstrate some low-level usage of the Julia programming language and subroutines of the CFAR project itself.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"<div class=\"grid-card-section\">","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"<div class=\"card grid-card\">\n<div class=\"grid-card-cover\">\n<div class=\"grid-card-description\">","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"This demo provides a quick example of how to run a Julia script.","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"</div>","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"(Image: card-cover-image)","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"</div>\n<div class=\"grid-card-text\">","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Julia Tutorial","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"</div>\n</div>","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"</div>","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"","category":"page"},{"location":"examples/#examples-attribution","page":"Examples","title":"Attribution","text":"","category":"section"},{"location":"examples/","page":"Examples","title":"Examples","text":"Icons used for the covers of these demo cards are attributed to the following sites:","category":"page"},{"location":"examples/","page":"Examples","title":"Examples","text":"Official Julia logo graphics","category":"page"},{"location":"man/guide/#Package-Guide","page":"Guide","title":"Package Guide","text":"","category":"section"},{"location":"man/guide/","page":"Guide","title":"Guide","text":"TODO","category":"page"},{"location":"","page":"Home","title":"Home","text":"DocTestSetup = quote\n    using CFAR, Dates\nend","category":"page"},{"location":"","page":"Home","title":"Home","text":"(Image: header)","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"These pages serve as the official documentation for the CFAR (Catastrophic Forgetting and Adaptive Resonance) project.","category":"page"},{"location":"","page":"Home","title":"Home","text":"The CFAR project is a development workspace for experiments targeting the analysis of catastrophic forgetting in the use of Adaptive Resonance Theory (ART) algorithms. Due to the broad nature of the research, many tools and types of experiments are involved. As a result, please see the relevant documentation sections about the various programming languages, tools, and experiments involved throughout the repository.","category":"page"},{"location":"","page":"Home","title":"Home","text":"This repository is developed and maintained by Sasha Petrenko <petrenkos@mst.edu> on behalf of the Missouri University of Science and Technology (MS&T) Applied Computational Intelligence Laboratory (ACIL).","category":"page"},{"location":"#Manual-Outline","page":"Home","title":"Manual Outline","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This documentation is split into the following sections:","category":"page"},{"location":"","page":"Home","title":"Home","text":"Pages = [\n    \"man/guide.md\",\n    \"../examples/index.md\",\n    \"man/full-index.md\",\n    \"man/dev-index.md\"\n]\nDepth = 1","category":"page"},{"location":"","page":"Home","title":"Home","text":"The Package Guide provides a tutorial to the full usage of the package, while Examples gives sample workflows with the various experiments of the project.","category":"page"},{"location":"#About-These-Docs","page":"Home","title":"About These Docs","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Though several different programming languages are used throughout the project, these docs are built around the Julia component of the project using the Documenter.jl package.","category":"page"},{"location":"#Documentation-Build","page":"Home","title":"Documentation Build","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This documentation was built using Documenter.jl with the following version and OS:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using CFAR, Dates # hide\nprintln(\"CFAR v$(CFAR_VERSION) docs built $(Dates.now()) with Julia $(VERSION) on $(Sys.KERNEL)\") # hide","category":"page"}]
}
