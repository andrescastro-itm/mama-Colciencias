'''Este código extrae características usando pyradiomics, 
usando los estudios y máscaras guardadas en NRRD'''


import numpy as np
import os
from radiomics import featureextractor
import six
import SimpleITK as sitk
from matplotlib import pyplot as plt
import nrrd
#csv=np.loadtxt('/home/dianamarin/6.ROIS MRI/Generar_Mascaras/data_roi/DATA_f.csv',
#               delimiter=',',dtype='str',encoding='latin1')

#csv=np.loadtxt('/home/dianamarin/6.ROIS MRI/Generar_Mascaras/DATA_FINAL/DATA_FINAL_PUNTOS.csv',
#               delimiter=',',dtype='str',encoding='latin1')

csv=np.loadtxt('/home/dianamarin/6.ROIS MRI/Generar_Mascaras/DATA_FINAL/Data_3_slices.csv',
               delimiter=',',dtype='str',encoding='latin1')

Pat1='/home/dianamarin/6.ROIS MRI/CDR_PACS_NRRD/'  #Direccion de estudios en NRRD
Rutas=np.array([])

for directorio,_,subdirectorio in os.walk(Pat1):
    for archivo in subdirectorio:
        Rutas= np.append(Rutas, os.path.join(directorio, archivo))

def encontrar_ruta_nrrd(name,secuencia):
    for i in range(0,len(Rutas)):
        if name +'/' in Rutas[i]:
            if secuencia in Rutas[i]:
                #print('Ruta IMAGEN: ',Rutas[i])
                return Rutas[i]
#                a=Rutas[i]
#    return a


parametros='/home/dianamarin/6.ROIS MRI/Generar_Mascaras/Params_W.yaml'
encabezado=[]

for i in range(1,len(csv)): #495   (1,len(csv)) 1191   Mri_13R1T2

    ruta_imagen = encontrar_ruta_nrrd(csv[i, 0], csv[i, 2])
    #print('Ruta IMAGEN DOS: ', ruta_imagen)
    ruta_mascara='/home/dianamarin/6.ROIS MRI/CDR_PACS_NRRD/' + csv[i,0] + '/' + 'Mascaras_3S' + '/' + csv[i,0] + '' + csv[i,1] + '' + \
                 csv[i,2] + '.nrrd'
                 
    #print('RUTA MASCARA: ', ruta_mascara)                 
    #print('VA AL EXTRACTOR')
    extractor = featureextractor.RadiomicsFeaturesExtractor(parametros)
    result = extractor.execute(ruta_imagen, ruta_mascara)

#    im,_ = nrrd.read(ruta_imagen)
#    ms,_=nrrd.read(ruta_mascara)|1Q

    columna = []
    entraono = 0

    for key, val in six.iteritems(result):
        #print("\t%s: %s" % (key, val))
        if key=='wavelet3-LLL_firstorder_10Percentile':
        #if key=='original_firstorder_10Percentile':   # priemer orden
        #if key=='log-sigma-2-0-mm-3D_firstorder_10Percentile':
        #if key=='original_glcm_Autocorrelation':        # Segundo orden GLCM
        #if key=='original_glrlm_GrayLevelNonUniformity': # Orden superior GLRLM
        #if key=='original_glszm_GrayLevelNonUniformity':  # Orden superior GLSZM
        #if key=='original_gldm_DependenceEntropy':    # Orden superior GLDM
            entraono=1
        if entraono == 1:
            columna.append(val)
#    print('CONCATENANDO')
        ##Para el encabezado de las caracteristicas
        #if entraono == 1 and i==1:
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

np.savetxt('/home/dianamarin/6.ROIS MRI/Features_Pyradiomics/Features_3S/Features_Wavelet_3L_db4.csv',features_2,fmt='%s',delimiter=';')

#np.savetxt('/home/dianamarin/6.ROIS MRI/Features_Pyradiomics/Todos_1',df,fmt='%s',delimiter=',')




