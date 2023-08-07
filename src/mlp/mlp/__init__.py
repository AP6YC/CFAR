import tensorflow as tf
import numpy as np
print(tf.version.VERSION)


def examine_data(ms):
    # print(ms.static.train.x)

    # print(np.array(ms.static.train.x).shape)

    train_dataset = tf.data.Dataset.from_tensor_slices((
        np.array(ms.static.train.x).transpose(),
        np.array(ms.static.train.y).transpose(),
    ))

    test_dataset = tf.data.Dataset.from_tensor_slices((
        np.array(ms.static.test.x).transpose(),
        np.array(ms.static.test.y).transpose(),
    ))

    model = tf.keras.Sequential([
        tf.keras.layers.Flatten(input_shape=(2,)),
        tf.keras.layers.Dense(2, activation='relu'),
        tf.keras.layers.Dense(2),
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
        epochs=10
    )
    loss, acc = model.evaluate(test_dataset)

    print("Loss {}, Accuracy {}".format(loss, acc))

    return loss, acc

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
