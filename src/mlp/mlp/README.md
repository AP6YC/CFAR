# `mlp`

This local package encapsulates all of the Python driver code for running a multi-layer perceptron (MLP) for experiments in the `CFAR` project.

## Installation

"Using" the `CFAR` package in a `Julia` session should correctly install this local package in editable mode and with `importlib.reload` each time that it is used to track changes within the same session without having to restart the REPL.

For usage in other contexts, install it manually with the normal local pip package installation usage:

```shell
pip install -e src/mlp
```

## Usage

Most of the functions in the package are used for initializing, training, and testing Tensorflow and/or PyTorch models, so please see the source code for information on what methods are available.
