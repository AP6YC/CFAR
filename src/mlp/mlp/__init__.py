import tensorflow as tf
import numpy as np
print(tf.version.VERSION)

BATCH_SIZE = 10
N_EPOCHS = 20


def print_loaded():
    print("The mlp package is loaded, and functions can be run in it")
    return


def show_data_shape(ms):
    print(np.array(ms.static.train.x).transpose().shape)
    print(np.array(ms.static.train.y).transpose().shape)
    return


def get_datasets(ms):
    train_dataset = tf.data.Dataset.from_tensor_slices((
        np.array(ms.static.train.x).transpose(),
        np.array(ms.static.train.y) - 1,
        # np.array(ms.static.train.y).transpose(),
    )).batch(BATCH_SIZE)

    test_dataset = tf.data.Dataset.from_tensor_slices((
        np.array(ms.static.test.x).transpose(),
        np.array(ms.static.test.y) - 1,
        # np.array(ms.static.test.y).transpose(),
    )).batch(BATCH_SIZE)

    return train_dataset, test_dataset


def tt_ms_mlp(ms):
    """Train and test an MLP on the MoverSplit dataset.

    Parameters
    ----------
    ms : CFAR.MoverSplit
        A Julia object defined in CFAR.

    Returns
    -------
    _type_
        _description_
    """
    # print(ms.static.train.x)

    show_data_shape(ms)

    train_dataset, test_dataset = get_datasets(ms)

    print(train_dataset)
    print(test_dataset)

    model = tf.keras.Sequential([
        # tf.keras.layers.Flatten(input_shape=(2, 1)),
        # tf.keras.layers.Flatten(input_shape=(2,)),
        # tf.keras.layers.Dense(2, input_shape=(BATCH_SIZE, 2), activation='relu'),
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

    model.fit(
        train_dataset,
        epochs=N_EPOCHS,
    )

    metrics = model.evaluate(test_dataset)

    (loss, acc, sc_acc) = metrics

    print("Loss {}, Accuracy {}, SC Accuracy {}".format(loss, acc, sc_acc))

    return metrics


# def tt_mlp(features, targets):
#     model = tf.keras.Sequential([
#         tf.keras.layers.Dense(2, activation='relu'),
#         tf.keras.layers.Dense(2),
#     ])

#     model.compile(
#         optimizer='adam',
#         loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
#         metrics=['accuracy'],
#     )

#     model.fit(train_data, epochs=NUM_EPOCHS)
#     loss, acc = model.evaluate(test_data)

#     print("Loss {}, Accuracy {}".format(loss, acc))

#     return
