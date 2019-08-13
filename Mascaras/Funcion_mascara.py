import SimpleITK as sitk
import numpy as np
import os 

def mascara(ruta,csv):
#   im = sitk.ReadImage(r'/home/dianamarin/6.ROIS MRI/Estudios_MRI/Breast_Mri_1/402 eT1_AX.nrrd')
    im = sitk.ReadImage(ruta)
    point = (int(float(csv[3])), int(float(csv[4])), int(float(csv[5])))  # fill in the index of your point here
    roi_size = (int(float(csv[8])), int(float(csv[8])), int(float(csv[9])))  # x, y, z; uneven to ensure the point is really the center of your ROI
    
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
        sitk.WriteImage(ma, '/home/dianamarin/6.ROIS MRI/CDR_PACS_NRRD/'
                        +csv[0]+'/'+'Mascaras_3S'+'/'+csv[0]+''+csv[1]+''+csv[2]+'.nrrd',True)
        
    except RuntimeError or FileNotFoundError:
        
        os.mkdir('/home/dianamarin/6.ROIS MRI/CDR_PACS_NRRD/'+csv[0]+'/'+'Mascaras_3S')
        sitk.WriteImage(ma, '/home/dianamarin/6.ROIS MRI/CDR_PACS_NRRD/' + csv[0] + '/' + 'Mascaras_3S' + '/' + csv[0] + '' + csv[1] + ''+ csv[2] + '.nrrd',True)
#
#### CARGAR LA IMAGEN 

#import nrrd
#from matplotlib import pyplot as plt
#IM,mask=nrrd.read('/home/dianamarin/6.ROIS MRI/mask_S1_ROI2_T1_2.nrrd')
#for i in range(77,95):
#    plt.imshow(IM[:,:,i],'gray') #77-95
#    plt.show()

# space origin=ImagePositionPatient
# space directions= space directions'