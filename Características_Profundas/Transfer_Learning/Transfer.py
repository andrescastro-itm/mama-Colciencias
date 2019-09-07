import numpy as np
import os
import time
from resnet50 import ResNet50
from keras.preprocessing import image
from keras.layers import GlobalAveragePooling2D, Dense, Dropout,Activation,Flatten
from imagenet_utils import preprocess_input
from keras.layers import Input
from keras.models import Model
from keras.utils import np_utils
from sklearn.utils import shuffle
from sklearn.model_selection import train_test_split
from keras.applications.imagenet_utils import _obtain_input_shape
from imagenet_utils import decode_predictions
import keras
from keras.callbacks import ModelCheckpoint

os.environ["CUDA_VISIBLE_DEVICES"]="0"

x = np.load('/home/dianamarin/6.ROIS MRI/DEEP_AND_RADIOMICS_FEATURES/Arreglos_Red/Datos_01/FAS2_ROIS146_224x224x3.npy')

model = ResNet50(weights='imagenet',include_top=False)

layer_name = 'res2a_branch2b'
intermediate_layer_model = Model(inputs=model.input,outputs=model.get_layer(layer_name).output)
Features_res2a_branch2b = intermediate_layer_model.predict(x)

