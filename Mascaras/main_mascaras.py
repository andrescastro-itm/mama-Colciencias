'''Este código toma los datos de los ROIS desde el csv (centro, numero de slices, etc) 
busca la ruta de los estudios guardados en .nrrd y genera las máscaras 2D o 3D '''

import numpy as np
import os
from Funcion_Mascara_F import mascara2d_3d



csv=np.loadtxt('Rita a archivo csv con los datos de cada estudio y sus ROIS/Data_3_slices.csv',
               delimiter=',',dtype='str',encoding='latin1')


Pat1='/ruta a todos estudios guardados en nrrd/Estudios'

ruta2='/Ruta de guardado/Mascaras/' 

Rutas=np.array([])

for directorio,_,subdirectorio in os.walk(Pat1):
    for archivo in subdirectorio:
        Rutas= np.append(Rutas, os.path.join(directorio, archivo))


def encontrar_ruta_nrrd(name,secuencia):
    for i in range(0,len(Rutas)):
        if name +'/' in Rutas[i]:
            if secuencia in Rutas[i]:
                return Rutas[i]

            
               

for i in range(1,len(csv)):
    ruta1=encontrar_ruta_nrrd(csv[i,0],csv[i,2]) # Ruta del estudio específico
    print(i)
    mascara2d_3d(ruta1,ruta2,csv[i],np.array([3,4,5]),np.array([8,8,9]))
    

    

    
