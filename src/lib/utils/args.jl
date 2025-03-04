"""
    file.jl

# Description
A collection of argparse utilities.
"""

const ARG_ARG_DESCRIPTION = """
# Arguments
- `description::AbstractString`: optional positional, the script description for the parser
"""


"""
Common function for how `ArgParseSettings` are generated in the project.

$ARG_ARG_DESCRIPTION
"""
function get_argparsesettings(description::AbstractString="")
    # Set up the parse settings
    s = ArgParseSettings(
        description = description,
        commands_are_required = false,
        version = string(CFAR_VERSION),
        add_version = true
    )
    return s
end

"""
Parses the command line for common options in serial (non-distributed) experiments.

$ARG_ARG_DESCRIPTION
"""
function exp_parse(description::AbstractString="A CFAR experiment script.")
    # Set up the parse settings
    s = get_argparsesettings(description)

    # Set up the arguments table
    @add_arg_table! s begin
        "--paper", "-p"
            help = "flag for saving results to the paper directory"
            action = :store_true
        "--no-display", "-d"
            help = "flag for running headless, suppressing the display of generated figures"
            action = :store_true
        "--verbose", "-v"
            help = "flag for verbose output"
            action = :store_true
    end

    # Parse and return the arguments
    return parse_args(s)
end

"""
Returns the default number of processes to start in distributed experiments on different platforms.
"""
function get_n_procs()
    return if Sys.iswindows()
        DEFAULT_N_PROCS["windows"]
    elseif Sys.isapple()
        DEFAULT_N_PROCS["darwin"]
    else
        DEFAULT_N_PROCS["linux"]
    end
end

"""
Parses the command line for common options in distributed experiments.

$ARG_ARG_DESCRIPTION
"""
function dist_exp_parse(description::AbstractString="A distributed CFAR experiment script.")
    # Set up the parse settings
    s = get_argparsesettings(description)

    # Pick the default number of distributed processes
    default_n_procs = get_n_procs()

    # Set up the arguments table
    @add_arg_table! s begin
        "--procs", "-p"
            help = "number of parallel processes"
            arg_type = Int
            default = default_n_procs
        # "--n_sims", "-n"
        #     help = "the number of simulations to run"
        #     arg_type = Int
        #     default = 1
        "--verbose", "-v"
            help = "verbose output"
            action = :store_true
        "--exp_name", "-e"
            help = "the name of the experiment"
            arg_type = String
            default = "exp"
        "--config_file", "-c"
            help = "the name of the configuration file"
            arg_type = String
            default = "art.yml"
    end

    # Parse and return the arguments
    return parse_args(s)
end
