'''Este código toma los datos de los ROIS desde el csv (centro, numero de slices, etc) 
y genera las máscaras '''

import numpy as np
import os
#import Funcion_mascara
from Funcion_mascara import mascara


#csv=np.loadtxt('/home/dianamarin/6.ROIS MRI/Generar_Mascaras/data_roi/DATA_f_1.csv',
#               delimiter=',',dtype='str',encoding='latin1')  # Cargar el csv con la información de los ROIS


#csv=np.loadtxt('/home/dianamarin/6.ROIS MRI/Generar_Mascaras/DATA_FINAL/DATA_FINAL_PUNTOS.csv',
#               delimiter=',',dtype='str',encoding='latin1')

csv=np.loadtxt('/home/dianamarin/6.ROIS MRI/Generar_Mascaras/DATA_FINAL/Data_3_slices.csv',
               delimiter=',',dtype='str',encoding='latin1')


Pat1='/home/dianamarin/6.ROIS MRI/CDR_PACS_NRRD'   # Path a estudios guardados en nrrd 
Rutas=np.array([])

for directorio,_,subdirectorio in os.walk(Pat1):
    for archivo in subdirectorio:
        Rutas= np.append(Rutas, os.path.join(directorio, archivo))


def encontrar_ruta_nrrd(name,secuencia):
    for i in range(0,len(Rutas)):
        if name +'/' in Rutas[i]:
            if secuencia in Rutas[i]:
#                print('POSICION',i)
                return Rutas[i]
#                a=Rutas[i]
#               
#    return a
               

for i in range(400,600):#(1,len(csv))   (515,516)
    ruta='WARNING'
    ruta=encontrar_ruta_nrrd(csv[i,0],csv[i,2])
    print(i)
    #print('ESTUDIO',csv[i,0])
#    print('SECUENCIA',csv[i,2])
    mascara(ruta,csv[i])
#    print(csv[i])
    
