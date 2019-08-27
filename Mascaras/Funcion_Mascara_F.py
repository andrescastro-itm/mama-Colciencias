''' Esta función permite la generación de máscaras 2D o 3D para ROIs en una imágen,
    teniendo en cuenta su ubicación y longitud en x,y,z

    mascara(ruta,csv[i],[cx,cy,cz],[lx,ly,lz])
    
    Entradas: 
        - ruta1: Es la ruta en la que se encuentra la secuencia almacenada en .nrrd para el estudio deseado
        - ruta2: Es la ruta donde se desean guardar las máscaras
        - csv: Es la fila del csv que contiene los datos del ROI a extraer
        - coo: Es un vector con las posiciones del csv que contienen las coordenadas del centro de ROI [x, y, z]
        - lon: Es un vector con las posiciones del csv que contienen las longitudes del ROI a lo largo de los ejes [x,y,z]

   Salidas:
       Almacena en una carpeta llamada Mascaras en la ruta2 las máscaras de los ROIS en cada estudio para todas las secuencias,
       de acuerdo a la lista de ROIS que se ingresa en el csv
       
       
   Autor: Diana Marín       
       
 '''

import SimpleITK as sitk
import numpy as np
import os 

def mascara2d_3d(ruta1,ruta2,csv,coo,lon):

    im = sitk.ReadImage(ruta1)
    point = (int(float(csv[coo[0]])), int(float(csv[coo[1]])), int(float(csv[coo[2]])))  # fill in the index of your point here
    roi_size = (int(float(csv[lon[0]])), int(float(csv[lon[1]])), int(float(csv[lon[2]])))  # x, y, z; uneven to ensure the point is really the center of your ROI
        
    im_size = im.GetSize()[::-1]  # size in z, y, x, needed because the arrays obtained from the image are oriented in z, y, x
    
    ma_arr = np.zeros(im_size, dtype='uint8')
    
    # Compute lower and upper bound of the ROI
    L_x = point[0] - int((roi_size[0]) / 2)
    L_y = point[1] - int((roi_size[1]) / 2)
    L_z = point[2] - int((roi_size[2]) / 2)
    
    U_x = point[0] + int((roi_size[0]) / 2)
    U_y = point[1] + int((roi_size[1]) / 2)
    U_z = point[2] + int((roi_size[2]) / 2)
    
    # ensure the ROI stays within the image bounds
    L_x = max(0, L_x)
    L_y = max(0, L_y)
    L_z = max(0, L_z)
    
    U_x = min(im_size[2] - 1, U_x)
    U_y = min(im_size[1] - 1, U_y)
    U_z = min(im_size[0] - 1, U_z)
    
    # 'segment' the mask
    ma_arr[L_z:U_z + 1, L_y:U_y + 1, L_x:U_x+1] = 1  # Add + 1 to each slice, as slicing is done from lower bound to, but not including, upper bound. Because we do want to include our upper bound, add + 1
    
    ma = sitk.GetImageFromArray(ma_arr)
    ma.CopyInformation(im)  # This copies the geometric information, ensuring image and mask are aligned. This works, because image and mask have the same size of the pixel array
    
    try:
        sitk.WriteImage(ma, ruta2 +'/'+'Mascaras'+'/'+csv[0]+''+csv[1]+''+csv[2]+'.nrrd',True)
        
    except RuntimeError or FileNotFoundError:        
        os.mkdir(ruta2+'/'+'Mascaras')
        sitk.WriteImage(ma, ruta2 + '/' + 'Mascaras' + '/' + csv[0] + '' + csv[1] + ''+ csv[2] + '.nrrd',True)

