# -----------------------------------------------------------------------------
# PREAMBLE
# -----------------------------------------------------------------------------

using Revise
using CFAR

# -----------------------------------------------------------------------------
# ADDITIONAL DEPENDENCIES
# -----------------------------------------------------------------------------

using Distributed
# using PythonCall

# pargs["procs"] = 2
# n_procs = 16
n_procs = 3
# Start several processes
# if pargs["procs"] > 0

# addprocs(pargs["procs"], exeflags="--project=.")
addprocs(n_procs, exeflags="--project=.")
# end

# -----------------------------------------------------------------------------
# PARALLEL DEFINITIONS
# -----------------------------------------------------------------------------
# using PythonCall
# PythonCall.GC.disable()

# CFAR.conda_gc_disable()

@everywhere begin
    # Activate the project in case
    using Pkg
    Pkg.activate(".")

    # Modules
    # using Revise
    using CFAR
    # CFAR.conda_gc_disable()
    using PythonCall

    function par_get()
        mlp = try
            # CFAR.get_mlp()
            mlp = pyimport("mlp")
            il = pyimport("importlib")
            il.reload(mlp)
        catch
            @info "failed to load, trying again"
            sleep(1)
            mlp = par_get()
        end
        return mlp
    end


    # mlp = pyimport("mlp")
    # il = pyimport("importlib")
    # il.reload(mlp)

    @info "Worker $(myid()) pre load"
    # # mlp = CFAR.get_mlp()
    mlp = par_get()
    @info "Worker $(myid()) post load"
    mlp.print_loaded()
    @info "Worker $(myid()) post print"
    # CFAR.conda_gc_enable()
end

# CFAR.conda_gc_enable()

# -----------------------------------------------------------------------------
# CLEANUP
# -----------------------------------------------------------------------------

# Close the workers after simulation
rmprocs(workers())
# if pargs["procs"] > 0
# end
