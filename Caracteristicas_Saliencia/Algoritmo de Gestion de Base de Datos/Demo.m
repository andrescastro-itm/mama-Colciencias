clc;close all;clear all;
%cd([matlabroot,'\bin'])
phad{1} = 'G:\Marcados_Duarte\ESTUDIOS';%'C:\Disco D\Proyecto de RMI\CDR_PACS';%'/media/dianamarin/ADATA HD650/CDR_PACS/Estudios';%
phad{2} = 'G:\Marcados_Duarte\CSV_REGIONES_REMARCADAS';%'C:\Disco D\Proyecto de RMI\CSV_REGIONES_REMARCADAS';%'/media/dianamarin/ADATA HD650/CDR_PACS/Estudios';%
phad{3} = 'G:\Marcados_Duarte\ROI_MRI.xlsx';
%phad2 = 'C:\Disco D\Proyecto de RMI\CDR_PACS2';

% savepaht = 'C:\Disco D\Proyecto de RMI\Regiones_Tnormales';%C:\Disco D\Proyecto de RMI\Regiones_Vnormales
% savepahtR = 'C:\Disco D\Proyecto de RMI\Regiones_Rnormales';
savepaht = 'E:\Marcados_Duarte\105_regiones_extr';%'C:\Disco D\Proyecto de RMI\mama-Colciencias\test_img';
%savepahtV = 'C:\Disco D\Proyecto de RMI\Regiones_Vnormales';
est=1:169;
N=est;%9;
w=0;
h=w;
z=1;
zv=1;

sh=0; %muestra las imagenes y el recorte
warn = warning ('off','all');
[Roi_MRI Roi_Estudios] = lecturEstudio_1(phad,savepaht,est,z,w,h,sh);
warning(warn);

Rsize = 224;
rootGVBS = 'C:\Disco D\Proyecto de RMI\mama-Colciencias\Caracteristicas_Saliencia\Modelo GBVS\gbvs';
FeatEstudioT = featsaly3(Roi_MRI, rootGVBS, Rsize);
save([savepaht,'\Regiones','\','FeatureR','.mat'],'FeatEstudioT');
