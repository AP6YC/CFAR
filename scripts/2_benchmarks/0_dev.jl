using Revise
using CFAR
# Point to the top of the data package directory
topdir =  CFAR.data_dir("data-package")

isdir(topdir)


for (root, dirs, files) in walkdir(topdir)
    # Iterate over all of the files
    for file in files
        # Get the full filename for the current data file
        filename = joinpath(root, file)
        data = CFAR.load_dataset(filename)
        @info data
    end
end
