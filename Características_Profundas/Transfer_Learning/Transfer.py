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
#from sklearn.cross_validation import train_test_split
from sklearn.model_selection import train_test_split
from keras.applications.imagenet_utils import _obtain_input_shape
from imagenet_utils import decode_predictions
import keras
from keras.callbacks import ModelCheckpoint

os.environ["CUDA_VISIBLE_DEVICES"]="0"

x = np.load('/home/dianamarin/6.ROIS MRI/DEEP_AND_RADIOMICS_FEATURES/Arreglos_Red/Datos_01/FAS2_ROIS146_224x224x3.npy')
#y = np.load('/home/dianamarin/6.ROIS MRI/DEEP_AND_RADIOMICS_FEATURES/Arreglos_Red/Datos_01/l_ADC_01_Clases.npy')

model = ResNet50(weights='imagenet',include_top=False)

'''  Nombres de las capas a tomar
res2a_branch2b 
res2c_branch2c 
res3d_branch2c 
res4f_branch2c 
res5c_branch2c 

'''

layer_name = 'res2a_branch2b'
intermediate_layer_model = Model(inputs=model.input,outputs=model.get_layer(layer_name).output)
Features_block1_conv2 = intermediate_layer_model.predict(x)

#np.save('/home/dianamarin/6.ROIS MRI/DEEP_AND_RADIOMICS_FEATURES/Transferencia/Caracteristicas_ResNet/F2_F_Trans_r5c_b2c_(2048F)146_224x3.npy',Features_block1_conv2)

#np.save('/home/dianamarin/6.ROIS MRI/DEEP_AND_RADIOMICS_FEATURES/Transferencia/y_ALL.npy',y)



