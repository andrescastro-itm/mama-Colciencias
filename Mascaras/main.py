'''Este código toma los datos de los ROIS desde el csv (centro, número de slices, etc) 
y genera las máscaras '''

import numpy as np
import os
from Funcion_mascara import mascara


csv=np.loadtxt('/ruta_del_archivo/Archivo.csv',
               delimiter=',',dtype='str',encoding='latin1') # Cargar el archivo Data_3_slices.csv 


Pat1='/ruta/Estudios_NRRD'   # Path a estudios guardados en formato nrrd 
Rutas=np.array([])

for directorio,_,subdirectorio in os.walk(Pat1):
    for archivo in subdirectorio:
        Rutas= np.append(Rutas, os.path.join(directorio, archivo))


def encontrar_ruta_nrrd(name,secuencia):
    for i in range(0,len(Rutas)):
        if name +'/' in Rutas[i]:
            if secuencia in Rutas[i]:
                return Rutas[i]
#                a=Rutas[i]
#               
#    return a
               

for i in range(1,len(csv))
    ruta='WARNING'
    ruta=encontrar_ruta_nrrd(csv[i,0],csv[i,2])
    print(i)
    #print('ESTUDIO',csv[i,0])
#    print('SECUENCIA',csv[i,2])
    mascara(ruta,csv[i])
#    print(csv[i])
    
