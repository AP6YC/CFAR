# `1_gaussian`

This experiment implements the initial visualization for the paper using data samples from multivariate Gaussians to illustrate apparent catastrophic forgetting.

## Files

The following files implement the experiment:

- `mg.jl`: demonstration script for training a supervised ART module on Gaussian data
- `1_gen_mg.jl`: generates a dataset of gaussians for standard training of ART and deep learning models.

## Commands

The following command can be with used with Image Magick to convert a folder of PNGs into a GIF with a reasonable delay:

```sh
magick convert -delay 50 *.png a.gif
```

## TODO

Experiments:

- Compute for each experiment:
  - FI for distributions
  - FI for weights for both ART and MLP
  - Performance
  - L2 logs and metrics
