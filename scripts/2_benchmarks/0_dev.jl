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
        # @info data
        @info "Loaded $file"
        @info "filename is " splitext(file)[1]
    end
end

datasets = CFAR.load_datasets()

# vec_datasets = CFAR.VectorLabeledDataset(datasets["ring"])

new_datasets = CFAR.split_datasets(datasets; p=0.8)

# vec_datasets = CFAR.vectorize_datasets(datasets)
# dsic = CFAR.DSIC(new_datasets["ring"])
dsic = CFAR.vectorize_datasets(new_datasets)


data = CFAR.load_vec_datasets()

# CFAR.gen_scenario("ring", data["ring"])
CFAR.gen_scenarios(data)