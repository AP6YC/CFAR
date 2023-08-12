# -----------------------------------------------------------------------------
# PREAMBLE
# -----------------------------------------------------------------------------

using Revise
using CFAR

# -----------------------------------------------------------------------------
# ADDITIONAL DEPENDENCIES
# -----------------------------------------------------------------------------

using Distributed

# pargs["procs"] = 2
n_procs = 2
# Start several processes
# if pargs["procs"] > 0

# addprocs(pargs["procs"], exeflags="--project=.")
addprocs(n_procs, exeflags="--project=.")
# end

# -----------------------------------------------------------------------------
# PARALLEL DEFINITIONS
# -----------------------------------------------------------------------------
using PythonCall

PythonCall.GC.disable()
PythonCall.C.gc_disable()

@everywhere begin
    # Activate the project in case
    using Pkg
    Pkg.activate(".")

    # Modules
    using Revise
    using CFAR

    # using PythonCall
    # mlp = pyimport("mlp")
    # il = pyimport("importlib")
    # il.reload(mlp)

    mlp = CFAR.get_mlp()
    mlp.print_loaded()
end

PythonCall.GC.enable()
PythonCall.C.gc_enable()

# -----------------------------------------------------------------------------
# CLEANUP
# -----------------------------------------------------------------------------

# Close the workers after simulation
rmprocs(workers())
# if pargs["procs"] > 0
# end
