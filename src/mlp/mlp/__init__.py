import tensorflow as tf
import numpy as np
print(tf.version.VERSION)

BATCH_SIZE = 10
N_EPOCHS = 20


def print_loaded():
    """Diagnostic, demonstrates that the package is usable by printing a message.
    """
    print("The mlp package is loaded, and functions can be run in it")
    return


def jl_features_to_np(features):
    return np.array(features).transpose()


def jl_labels_to_np(labels):
    return np.array(labels) - 1


def jl_data_to_np(data):
    features = jl_features_to_np(data.x),
    labels = jl_labels_to_np(data.y),
    return features, labels


def jl_data_to_tf(data):
    dataset = tf.data.Dataset.from_tensor_slices(
        jl_data_to_np(data)
    ).batch(BATCH_SIZE)

    return dataset


def show_data_shape(ms):
    # Inspect the shape of the features as they would go into tf.Dataset
    features, labels = jl_data_to_np(ms.static.train)
    print("Features:")
    print(features.shape)
    # print(jl_features_to_np(ms.static.train.x).shape)
    print("Labels:")
    print(labels.shape)
    # print(jl_labels_to_np(ms.static.train.y).shape)
    return


def get_datasets(ms):
    # Inspect the dimensions going into the tf.Datasets
    show_data_shape(ms)

    # Training dataset
    train_dataset = jl_data_to_tf(ms.static.train)

    # Testing dataset
    test_dataset = jl_data_to_tf(ms.static.test)

    # Return the two as a tuple
    return train_dataset, test_dataset


def get_mlp_model():
    model = tf.keras.Sequential([
        tf.keras.layers.Dense(4, activation='relu', name="hidden"),
        tf.keras.layers.Dense(2, name='output'),
    ])

    model.compile(
        # optimizer='adam',
        optimizer=tf.keras.optimizers.RMSprop(),
        loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
        metrics=[
            'accuracy',
            'sparse_categorical_accuracy',
        ],
    )

    return model


def train_mlp_model(model, train_dataset):
    model.fit(
        train_dataset,
        epochs=N_EPOCHS,
    )

    return


def test_mlp_model(model, test_dataset):
    metrics = model.evaluate(test_dataset)
    (loss, acc, sc_acc) = metrics
    print("Loss {}, Accuracy {}, SC Accuracy {}".format(loss, acc, sc_acc))

    return metrics


def tt_ms_mlp(ms):
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
    train_dataset, test_dataset = get_datasets(ms)

    # Create and compile the model
    model = get_mlp_model()

    # Train the model
    train_mlp_model(model, train_dataset)

    # Test the model
    metrics = test_mlp_model(model, test_dataset)

    # Unpack the metrics for local logging
    (loss, acc, sc_acc) = metrics
    print("Loss {}, Accuracy {}, SC Accuracy {}".format(loss, acc, sc_acc))

    # Return the tupled metrics
    return metrics
