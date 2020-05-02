# -*- coding: utf-8 -*-
"""
Created on Fri Sep  7 17:35:44 2018

@author: itm
"""

#https://stackoverflow.com/questions/7008608/scipy-io-loadmat-nested-structures-i-e-dictionaries
import scipy.io as spio

def loadmat(filename):
    '''
    this function should be called instead of direct spio.loadmat
    as it cures the problem of not properly recovering python dictionaries
    from mat files. It calls the function check keys to cure all entries
    which are still mat-objects
    '''
    data = spio.loadmat(filename, struct_as_record=False, squeeze_me=True)
    return _check_keys(data)

def _check_keys(dict):
    '''
    checks if entries in dictionary are mat-objects. If yes
    todict is called to change them to nested dictionaries
    '''
    for key in dict:
        if isinstance(dict[key], spio.matlab.mio5_params.mat_struct):
            dict[key] = _todict(dict[key])
    return dict        

def _todict(matobj):
    '''
    A recursive function which constructs from matobjects nested dictionaries
    '''
    dict = {}
    for strg in matobj._fieldnames:
        elem = matobj.__dict__[strg]
        if isinstance(elem, spio.matlab.mio5_params.mat_struct):
            dict[strg] = _todict(elem)
        else:
            dict[strg] = elem
    return dict

#matt2=loadmat('C:\Disco D\Proyecto de RMI\dimensiones\ROI_Estuidos.mat')#('C:\Disco D\Proyecto de RMI\Regiones_Rnormales\Regiones\ROI_Estuidos.mat')
matt=loadmat('E:\Extraidos_Duarte\Regiones\ROI_Estuidos_1.mat')
#type(matt)
#c=0
#for i in matt:
#    if 
#        c=c+1;
#        print (str(c))
        

#################################################################################################
est=matt['Roi_MRI']
b_r_0=0
b_r_1=0
b_r_2=0
b_r_3=0
b_r_4=0
b_r_5=0
b_r_6=0

eti_0=0
eti_1=0
eti_2=0

num_estudios=0
num_roi=0
for i in est:
    roi=est[i]#['Roi_Breast_Mri_'+str(1)]
    
    for j in roi:
        
        sec=roi[j]
        for k in sec:
            if k == 'Bi_Rads':
                if sec[k]==0:
                    b_r_0=b_r_0+1
                    print(['El estudio: ',i,'en el ',j,' Tiene Bi_Rads = 0'])
                elif sec[k]==1:
                    b_r_1=b_r_1+1
                elif sec[k]==2:
                    b_r_2=b_r_2+1
                elif sec[k]==3:
                    b_r_3=b_r_3+1
                elif sec[k]==4:
                    b_r_4=b_r_4+1
                elif sec[k]==5:
                    b_r_5=b_r_5+1
                elif sec[k]==6:
                    b_r_6=b_r_6+1
                else:
                    print(['El estudio: ',i,'en el ',j,'no tiene asignado el numero del Bi_Rads'])
          
            if k=='label_1':
                if sec[k]==0:
                    eti_0=eti_0+1
                elif sec[k]==1:
                    eti_1=eti_1+1
                elif sec[k]==2:
                    eti_2=eti_2+1
                else:
                    print(['El estudio: ',i,'en el ',j,'no tiene asignado el numero del Label_2'])

    num_estudios=num_estudios+1
    num_roi=num_roi+len(roi)
    
print(['El Numero de Estudios es: ',num_estudios,'Y Numeros de ROIs es:',num_roi])

##################################################################################################
                
#nroi=dir(eett)
#con=0
#nr=list()
#
#
#for i in roi:
#    
#    nr.append(i)#{con:str(i)}
#    print (str(i))
#    secu=(roi[i])
#    #.
    #.
    #.
    #con=con+1;
    
  
    

    
    
    
    
    
    