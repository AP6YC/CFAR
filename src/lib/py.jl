"""
    py.jl

# Description
A set of utilities for interacting with the Python component of the project via `PythonCall.jl`.
"""

"""
Loads and returns a handle to the provided local Python library.

# Arguments
- `lib::AbstractString`: the string name of the local Python library to load.
"""
function get_pylib(lib::AbstractString)
    # Load the library
    pylib = pyimport(lib)

    # Reload definitions for development
    il = pyimport("importlib")
    il.reload(pylib)

    # Return the library
    return pylib
end

"""
Loads and returns a handle to the local `mlp` Python library.
"""
function get_mlp()
    # Load and return the mlp library
    return getpylib(MLP)
end

"""
Runs a provided command with the correct CondaPkg.jl Python environment.

# Arguments
- `cmd_string::AbstractString`: the Python command to run as a string, excluding the initial 'python' part.
"""
function conda_run(cmd_string::AbstractString)
    # Make sure to only use the CondaPkg Python environment
    CondaPkg.withenv() do
        # Point to the correct python executable for this environment
        python = CondaPkg.which("python")
        # Split the command into a vector to avoid quoting
        local_cmd = split(cmd_string, " ")
        # Run the chained command
        run(`$python $local_cmd`)
    end
end

"""
Sets up a local Python library with .

# Arguments
- `lib::AbstractString`: the string name of the local library to setup.
"""
function setup_local_pylib(lib::AbstractString)
    # Try to import the library
    try
        # @info "Local lib '$(lib)' is set up"
        pyimport(lib)
    # If this failed, then install the package
    catch
        @info "Local lib '$(lib)' not set up; installing now"
        conda_run("--version")
        lib_path = joinpath(LOCAL_PYTHON_LIB_LOCATION, lib)
        conda_run("-m pip install -e $lib_path")
    end

    # Empty return
    return
end

"""
Sets up the Conda dependencies, including local libraries.
"""
function conda_setup()
    # Install the CondaPkg.toml
    CondaPkg.resolve()

    # Setup the local libs
    for lib in LOCAL_PYTHON_LIBS
        setup_local_pylib(lib)
    end

    # Empty return
    return
end
