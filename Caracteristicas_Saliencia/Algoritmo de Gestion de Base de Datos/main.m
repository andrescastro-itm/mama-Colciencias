
clc
close all
clear all
cd([matlabroot,'\bin'])
phad = 'C:\Disco D\Proyecto de RMI\CDR_PACS';
savepaht = 'C:\Disco D\Proyecto de RMI\Regiones_Tnormales';
est=1:95;
N=est;%9;
w=64;
h=w;

[Roi_MRI Roi_Estudios] = lecturEstudio(phad,savepaht,N,w,h)
%savepaht3 = 'C:\Disco D\Proyecto de RMI\ensayo';
%[Roi_MRI4 Roi_Estudios4] = lecturEstudio(phad3,savepaht,N)

FeatEstudioT = featsaly3(Roi_MRI)

save([savepaht,'\Regiones','\','FeatureT2','.mat'],'FeatEstudioT2');