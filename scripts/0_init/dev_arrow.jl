using Arrow

struct Person
    id::Int
    name::String
end

# overload interface method for custom type Person; return a symbol as the "name"
# this instructs Arrow.write what "label" to include with a column with this custom type
ArrowTypes.arrowname(::Type{Person}) = :Person
# overload JuliaType on `Val{:Person}`, which is like a dispatchable string
# return our custom *type* Person; this enables Arrow.Table to know how the "label"
# on a custom column should be mapped to a Julia type and deserialized
ArrowTypes.JuliaType(::Val{:Person}) = Person

table = (col1=[Person(1, "Bob"), Person(2, "Jane")],)
io = IOBuffer()
Arrow.write(io, table)
seekstart(io)
table2 = Arrow.Table(io)


macro create_class(classname, fields...)
    quote
        mutable struct $classname
            $(fields...)
            function $classname($(fields...))
                new($(fields...))
            end
        end
    end
end

macro create_class2(classname, fields_tuple)
    fields = fields_tuple.args
    quote
        mutable struct $classname
            $(fields...)
            function $classname($(fields...))
                new($(fields...))
            end
        end
    end
end

@macroexpand @create_class F1 a b c

@macroexpand @create_class2 F2 (a, b)

using DataFrames

filename = "asdf.arrow"

function asdf(filename::AbstractString)
    @eval @create_class2 F2 (a, b)
    @eval ArrowTypes.arrowname(::Type{F2}) = :F2
    @eval ArrowTypes.JuliaType(::Val{:F2}) = F2
    df = DataFrame(
        a = F2[]
    )
    element = Vector{Any}([
        F2(1,2),
    ])

    push!(df, element)
    Arrow.write(filename, df)
end

asdf(filename)

ar2 = Arrow.Table(filename)
df2 = DataFrame(ar2)

