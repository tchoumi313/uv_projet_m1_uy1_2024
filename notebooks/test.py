# Import necessary libraries
import os

import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow.keras.layers import (Conv2D, Dense, Dropout, Flatten,
                                     MaxPooling2D)
from tensorflow.keras.models import Sequential
from tensorflow.keras.preprocessing.image import ImageDataGenerator

# Define image size and batch size
img_height, img_width = 128, 128
batch_size = 32

# Define paths to the dataset
plant_data_dir = "/home/donsoft/Downloads/Plant-Leaf-Disease-Prediction-master/Dataset/train/"
non_plant_data_dir = "/home/donsoft/Pictures/Screenshots/"  # Assuming you have a directory with non-plant images



# Create ImageDataGenerators for training and validation
train_datagen = ImageDataGenerator(rescale=1./255, validation_split=0.2)

# Create a combined directory structure for plant and non-plant images
combined_data_dir = "./input/combined-dataset"
os.makedirs(combined_data_dir, exist_ok=True)
os.makedirs(os.path.join(combined_data_dir, "plant"), exist_ok=True)
os.makedirs(os.path.join(combined_data_dir, "non-plant"), exist_ok=True)

# Copy plant images to the combined directory
for subdir, dirs, files in os.walk(plant_data_dir):
    for file in files:
        src_path = os.path.join(subdir, file)
        dst_path = os.path.join(combined_data_dir, "plant", file)
        os.symlink(src_path, dst_path)

# Copy non-plant images to the combined directory
for file in os.listdir(non_plant_data_dir):
    src_path = os.path.join(non_plant_data_dir, file)
    dst_path = os.path.join(combined_data_dir, "non-plant", file)
    os.symlink(src_path, dst_path)

# Create ImageDataGenerators for training and validation
train_generator = train_datagen.flow_from_directory(
    combined_data_dir,
    target_size=(img_height, img_width),
    batch_size=batch_size,
    class_mode='binary',
    subset='training'
)

validation_generator = train_datagen.flow_from_directory(
    combined_data_dir,
    target_size=(img_height, img_width),
    batch_size=batch_size,
    class_mode='binary',
    subset='validation'
)

# Define the binary classifier model
def create_binary_classifier():
    model = Sequential([
        Conv2D(32, (3, 3), activation='relu', input_shape=(img_height, img_width, 3)),
        MaxPooling2D(pool_size=(2, 2)),
        Conv2D(64, (3, 3), activation='relu'),
        MaxPooling2D(pool_size=(2, 2)),
        Flatten(),
        Dense(128, activation='relu'),
        Dropout(0.5),
        Dense(1, activation='sigmoid')
    ])
    model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])
    return model

# Create and train the binary classifier
binary_classifier = create_binary_classifier()
history = binary_classifier.fit(
    train_generator,
    epochs=20,
    validation_data=validation_generator
)

# Plot training and validation accuracy and loss
plt.figure(figsize=(12, 4))
plt.subplot(1, 2, 1)
plt.plot(history.history['accuracy'], label='Train Accuracy')
plt.plot(history.history['val_accuracy'], label='Validation Accuracy')
plt.title('Training and Validation Accuracy')
plt.xlabel('Epoch')
plt.ylabel('Accuracy')
plt.legend()

plt.subplot(1, 2, 2)
plt.plot(history.history['loss'], label='Train Loss')
plt.plot(history.history['val_loss'], label='Validation Loss')
plt.title('Training and Validation Loss')
plt.xlabel('Epoch')
plt.ylabel('Loss')
plt.legend()

plt.tight_layout()
plt.show()

# Save the model
binary_classifier.save('binary_classifier.h5')
binary_classifier = tf.keras.models.load_model('binary_classifier.h5')
# Function to predict if an image is a plant or non-plant
def predict_image(image_path):
    img = tf.keras.preprocessing.image.load_img(image_path, target_size=(img_height, img_width))
    img_array = tf.keras.preprocessing.image.img_to_array(img)
    img_array = tf.expand_dims(img_array, 0)  # Create a batch

    prediction = binary_classifier.predict(img_array)
    
    if prediction[0][0] < 0.5:
        return "Non-plant image"
    else:
        return "Plant image"

# Test the function with a sample image

new_model = tf.keras.models.load_model('binary_classifier.h5')
print(new_model.summary())
img_path="/home/donsoft/Downloads/Plant-Leaf-Disease-Prediction-master/Dataset/train/Tomato - Two-spotted_spider_mite/Tomato___Spider_mites Two-spotted_spider_mite (11).JPG"
img = tf.keras.preprocessing.image.load_img(img_path, target_size=(img_height, img_width))
img_array = tf.keras.preprocessing.image.img_to_array(img)
img_array = tf.expand_dims(img_array, 0)  # Create a batch

print(new_model.predict(img_array))
print(predict_image(img_path))
img_path="/home/donsoft/Downloads/Plant-Leaf-Disease-Prediction-master/Dataset/train/Tomato - Two-spotted_spider_mite/Tomato___Spider_mites Two-spotted_spider_mite (12).JPG"
img = tf.keras.preprocessing.image.load_img(img_path, target_size=(img_height, img_width))
img_array = tf.keras.preprocessing.image.img_to_array(img)
img_array = tf.expand_dims(img_array, 0)  # Create a batch

print(new_model.predict(img_array))
print(predict_image(img_path))
img_path="/home/donsoft/Downloads/Plant-Leaf-Disease-Prediction-master/Dataset/train/Tomato - Two-spotted_spider_mite/Tomato___Spider_mites Two-spotted_spider_mite (15).JPG"
img = tf.keras.preprocessing.image.load_img(img_path, target_size=(img_height, img_width))
img_array = tf.keras.preprocessing.image.img_to_array(img)
img_array = tf.expand_dims(img_array, 0)  # Create a batch

print(new_model.predict(img_array))
print(predict_image(img_path))
img_path="/home/donsoft/Documents/school/M1/S2/uv_projet/NexGen_Agri/input/combined-dataset/non-plant/IMG_20240531_104815 (copy 9).png"
img = tf.keras.preprocessing.image.load_img(img_path, target_size=(img_height, img_width))
img_array = tf.keras.preprocessing.image.img_to_array(img)
img_array = tf.expand_dims(img_array, 0)  # Create a batch

print(new_model.predict(img_array))
print(predict_image(img_path))