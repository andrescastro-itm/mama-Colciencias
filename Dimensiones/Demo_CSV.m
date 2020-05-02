clc;close all;clear all
%cd([matlabroot,'\bin'])
phad{1} = 'C:\Disco D\Proyecto de RMI\CDR_PACS';%Estudios
phad{2} = 'C:\Disco D\Proyecto de RMI\CSV_REGIONES_REMARCADAS';%Regiones
phad{3} = 'C:\Users\itm\Documents\ROI_MRI.xlsx';%% DIRECCION COMPLETA DEL EXCEL CON LOS LABEL


N=1:2%1:95;% vector con los numeros de los estudios que se desea analizar

DATA=lecturSV(phad,N);

excname='C:\Disco D\Proyecto de RMI\dimensiones\DATA_test.xlsx';
xlswrite(excname,DATA,1,'A1');