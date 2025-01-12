using Revise
using Distributed

function dist_test()
    addprocs(4)
    @everywhere begin
        @info "Hello from $(myid())"
        # using CFAR
        @eval import Pkg
        Pkg.activate(".")
        @eval using CFAR
        print(CFAR.exp_name)
    end
    rmprocs(workers())
    return
end

dist_test()

function make_dist()
    addprocs(4)

    return
end

function do_work()
    pmap(x -> x^2, 1:4)
end

function cleanup()
    rmprocs(workers())
end

make_dist()
do_work()
cleanup()