# hello_tensorflow.py

import tensorflow as tf

# Create two constant tensors
a = tf.constant(2)
b = tf.constant(3)

# Perform basic operations
addition = tf.add(a, b)
multiplication = tf.multiply(a, b)

# Create a TensorFlow session to run the operations
# (For TensorFlow 2.x, eager execution is enabled by default)
print("Addition:", addition.numpy())  # Output: 5
print("Multiplication:", multiplication.numpy())  # Output: 6
