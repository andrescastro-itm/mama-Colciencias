'''Este código extrae características usando pyradiomics, 
usando los estudios y máscaras guardadas en NRRD'''


import numpy as np
import os
from radiomics import featureextractor
import six
import SimpleITK as sitk
from matplotlib import pyplot as plt
import nrrd


csv=np.loadtxt('/ruta a csv con información de los ROIs/Data_3_slices.csv',
               delimiter=',',dtype='str',encoding='latin1')

Pat1='/Dirección a carpeta con estudios en nrrd/Estudios/'
Rutas=np.array([])

# Obtener una lista con todas las rutas en Pat1
for directorio,_,subdirectorio in os.walk(Pat1):
    for archivo in subdirectorio:
        Rutas= np.append(Rutas, os.path.join(directorio, archivo))

# Función para encontrar la ruta de un estudio (name=MRI_1) en una secuencia específica (secuencias=DIFUSION)
def encontrar_ruta_nrrd(name,secuencia):
    for i in range(0,len(Rutas)):
        if name +'/' in Rutas[i]:
            if secuencia in Rutas[i]:
                return Rutas[i]


parametros='/ruta al archivo .yaml que indica las caractersticas a extraer y los parámetros/Params.yaml'

# EXTRAER CARACTERÍSTICAS Y GUARDARLAS EN features_2 CON TODA LA INFORMACIÓN DE LOS ROIS
encabezado=[]

for i in range(1,len(csv)):

    ruta_imagen = encontrar_ruta_nrrd(csv[i, 0], csv[i, 2])
    ruta_mascara='/Dirección a carpeta con estudios en nrrd/Estudios/' + csv[i,0] + '/' + 'Mascaras' + '/' + csv[i,0] + '' + csv[i,1] + '' + \
                 csv[i,2] + '.nrrd'
                 
    extractor = featureextractor.RadiomicsFeaturesExtractor(parametros)
    result = extractor.execute(ruta_imagen, ruta_mascara)

    columna = []
    entraono = 0

    for key, val in six.iteritems(result):
        
        if key=='original_firstorder_10Percentile':   # priemer orden
        #if key=='wavelet3-LLL_firstorder_10Percentile':  
        #if key=='log-sigma-2-0-mm-3D_firstorder_10Percentile':
        #if key=='original_glcm_Autocorrelation':        # Segundo orden GLCM
        #if key=='original_glrlm_GrayLevelNonUniformity': # Orden superior GLRLM
        #if key=='original_glszm_GrayLevelNonUniformity':  # Orden superior GLSZM
        #if key=='original_gldm_DependenceEntropy':    # Orden superior GLDM
            entraono=1
        if entraono == 1:
            columna.append(val)

        if entraono == 1 and i==1:
            encabezado.append(key)

    if i==1:
        features=np.zeros([len(csv)-1,len(columna)])

    features[i-1,:]=columna
    print(i)




encabezado=np.array(encabezado)
features=features.astype(str)
filas,columnas=features.shape[:2]
            
features_2=np.zeros([filas+1,columnas])
features_2=features_2.astype(str)

features_2[0,:]=encabezado
features_2[1:,:]=features
features_2=np.concatenate((csv,features_2),axis=-1)

np.savetxt('Ruta de guardado de csv con características/Nombre del archivo.csv',features_2,fmt='%s',delimiter=';')

