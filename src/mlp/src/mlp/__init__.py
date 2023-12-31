"""
    __init__.py

# Description
Definitions for the local `mlp` Python package containing driver code for multilayer perceptron training and testing in the `CFAR` project.

# Authors
- Sasha Petrenko <petrenkos@mst.edu> @AP6YC
"""

# -----------------------------------------------------------------------------
# IMPORTS
# -----------------------------------------------------------------------------

import tensorflow as tf
import numpy as np
from typing import Tuple

# -----------------------------------------------------------------------------
# "CONSTANTS"
# -----------------------------------------------------------------------------

BATCH_SIZE = 10
N_EPOCHS = 20

# Set the version variable of the package
__version__ = "1.0.0"

# -----------------------------------------------------------------------------
# FUNCTIONS
# -----------------------------------------------------------------------------


def print_loaded() -> None:
    """Diagnostic, demonstrates that the package is usable by printing a message.
    """

    # Print diagnostic
    print("The mlp package is loaded, and functions can be run in it.")
    print(f"Using tensorflow version {tf.version.VERSION}")

    # Empty return
    return


def jl_features_to_np(features) -> np.ndarray:
    """Converts a set of Julia object features to the numpy equivalent.

    Parameters
    ----------
    features : CFAR.Features
        A Julia object of features as defined in CFAR.

    Returns
    -------
    np.ndarray
        The features cast into a numpy array and transposed.
    """

    # Cast to a numpy array and transpose
    return np.array(features).transpose()


def jl_targets_to_np(targets) -> np.ndarray:
    """Converts a set of Julia object targets to the numpy equivalent.

    Adjusts the labels for Python's 0-based indexing.

    Parameters
    ----------
    targets : CFAR.Targets
        A Julia object of targets as defined in CFAR.

    Returns
    -------
    np.ndarray
        The targets cast into a numpy array and shifted by 1 (Julia is 1-indexed, Python is 0-indexed).
    """

    # Cast to a numpy array and shift by one
    return np.array(targets) - 1


def jl_data_to_np(data) -> Tuple[np.ndarray, np.ndarray]:
    """Converts a set of Julia features and targets data to their numpy equivalents

    Parameters
    ----------
    data : CFAR.LabeledDataset
        A Julia object containing `x` and `y` fields.

    Returns
    -------
    Tuple[np.ndarray, np.ndarray]
        The features and labels in numpy arrays.
    """

    # Convert the features and labels
    features = jl_features_to_np(data.x)
    labels = jl_targets_to_np(data.y)

    # Return as a tuple
    return features, labels


def jl_data_to_tf(data) -> tf.data.Dataset:
    """Converts a set of Julia features and labels into a tensorflow dataset.

    Parameters
    ----------
    data : CFAR.LabeledDataset
        A Julia object containing `x` and `y` fields.

    Returns
    -------
    tf.data.dataset
        A pre-batched tensorflow dataset.
    """

    # Create the dataset from numpy arrays and batch
    dataset = tf.data.Dataset.from_tensor_slices(
        jl_data_to_np(data)
    ).batch(BATCH_SIZE)

    # Return the prebatched dataset
    return dataset


def show_data_shape(ds) -> None:
    """Prints the shape of the provided Julia CFAR.MoverSplit dataset.

    Parameters
    ----------
    ds : CFAR.DataSplitCombined
        The Julia object containing the train/test split.
    """

    # Inspect the shape of the features as they would go into tf.Dataset
    features, labels = jl_data_to_np(ds.train)
    print("Features:")
    print(features.shape)
    print("Labels:")
    print(labels.shape)

    # Empty return
    return


def get_datasets(ds) -> Tuple[tf.data.Dataset, tf.data.Dataset]:
    """Turns the provided Julia dataset into train/test tensorflow datasets.

    Parameters
    ----------
    ds : CFAR.DataSplitCombined
        A Julia object containing the datasets.

    Returns
    -------
    Tuple[tf.data.Dataset, tf.data.Dataset]
        The training and testing datasets as a tuple.
    """
    # Inspect the dimensions going into the tf.Datasets
    show_data_shape(ds)

    # Training dataset
    train_dataset = jl_data_to_tf(ds.train)

    # Testing dataset
    test_dataset = jl_data_to_tf(ds.test)

    # Return the two as a tuple
    return train_dataset, test_dataset


def get_mlp_model() -> tf.keras.Model:
    """Generates the multilayer perceptron model.

    Returns
    -------
    tf.keras.Model
        The sequential MLP model.
    """

    # Define the sequential model
    model = tf.keras.Sequential([
        tf.keras.layers.Dense(4, activation='relu', name="hidden"),
        tf.keras.layers.Dense(3, name='output'),
    ])

    # Compile the model, declaring the optimizer, loss, and metrics
    model.compile(
        # optimizer='adam',
        optimizer=tf.keras.optimizers.RMSprop(),
        loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
        metrics=[
            'accuracy',
            'sparse_categorical_accuracy',
        ],
    )

    # Return a fresh model ready for training
    return model


def train_mlp_model(
    model: tf.keras.Model,
    train_dataset: tf.data.Dataset,
    epochs: int = N_EPOCHS,
    verbose: int = 2,
) -> None:
    """Trains the MLP model on the provided tensorflow dataset.

    Parameters
    ----------
    model : tf.keras.Model
        The MLP tensorflow model.
    train_dataset : tf.data.Dataset
        The prebatched tensorflow dataset.
    """

    # Fit the data
    model.fit(
        train_dataset,
        epochs=epochs,
        verbose=verbose,
    )

    # Empty return
    return


def stdout_metrics(metrics: Tuple) -> None:
    # Unpack the metrics for local logging
    (loss, acc, sc_acc) = metrics
    print("Loss {}, Accuracy {}, SC Accuracy {}".format(loss, acc, sc_acc))

    # Empty return
    return


def test_mlp_model(
    model: tf.keras.Model,
    test_dataset: tf.data.Dataset,
    verbose: int = 2
) -> Tuple:
    """_summary_

    _extended_summary_

    Parameters
    ----------
    model : tf.keras.Model
        _description_
    test_dataset : tf.data.Dataset
        _description_
    """

    # Evaluate the model on the test datset
    metrics = model.evaluate(
        test_dataset,
        verbose=verbose,
    )

    # Display these metrics
    stdout_metrics(metrics)

    # Return the metrics from the evaluation
    return metrics


def tt_ms_mlp(
    ms,
    verbose=2,
) -> Tuple:
    """Train and test an MLP on the MoverSplit dataset.

    Parameters
    ----------
    ms : CFAR.MoverSplit
        A Julia object defined in CFAR.

    Returns
    -------
    Tuple
        The metrics generated during testing.
    """

    # Get the datasets from the Julia object
    train_dataset, test_dataset = get_datasets(ms.static)

    # Create and compile the model
    model = get_mlp_model()

    # Train the model
    train_mlp_model(
        model,
        train_dataset,
        verbose=verbose,
    )

    # Test the model
    metrics = test_mlp_model(
        model,
        test_dataset,
        verbose=verbose,
    )

    # Unpack the metrics for local logging
    (loss, acc, sc_acc) = metrics
    print("Loss {}, Accuracy {}, SC Accuracy {}".format(loss, acc, sc_acc))

    # Return the tupled metrics
    return metrics


def tt_ms_mlp_l2(
    ms,
    verbose=2,
    epochs=N_EPOCHS,
) -> Tuple:
    """Train and test an MLP on the MoverSplit dataset.

    Parameters
    ----------
    ms : CFAR.MoverSplit
        A Julia object defined in CFAR.

    Returns
    -------
    Tuple
        The metrics generated during testing.
    """

    # Get the datasets from the Julia object
    train_static, test_static = get_datasets(ms.static)
    train_mover, test_mover = get_datasets(ms.mover)

    # Create and compile the model
    model = get_mlp_model()

    # Train the model on the train dataset
    train_mlp_model(
        model,
        train_static,
        verbose=verbose,
        epochs=epochs,
    )

    # Test the model
    metrics_pre = test_mlp_model(
        model,
        test_static,
        verbose=verbose,
    )

    # Train the model on the mover dataset
    train_mlp_model(
        model,
        train_mover,
        verbose=verbose,
        epochs=epochs,
    )

    # Test the model again
    metrics_post = test_mlp_model(
        model,
        test_mover,
        verbose=verbose,
    )

    test_combined = test_mover.concatenate(test_static)

    metrics_combined = test_mlp_model(
        model,
        test_combined,
        verbose=verbose,
    )

    # Return the tupled metrics
    return metrics_pre, metrics_post, metrics_combined
