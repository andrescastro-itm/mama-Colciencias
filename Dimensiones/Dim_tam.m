

clc;clear all;close all;
%load('C:\Disco D\Proyecto de RMI\CDR_PACS\ROI_Estuidos.mat')

load('C:\Disco D\Proyecto de RMI\Regiones_Tnormales2\Regiones\ROI_Estuidos.mat')
%'C:\Disco D\Proyecto de RMI\Regiones_Tnormales'
paciente = fieldnames(Roi_MRI);
N=1;
excname='C:\Disco D\Proyecto de RMI\dimensiones\dim2.xlsx'; % Ruta donde quiere guardar el Excel Creado ej: 'C:\Disco D\Proyecto de RMI\dimensiones\dim.xlsx'
%xlswrite(excname,3,1,'A2');

chr=char([97:122]);
C=chr(1:8);

cart={'Estudio','ROI','Serie','BI-RADS','Comentario','N de Filas','N de Columnas','Area'};
xlswrite(excname,cart(1),1,'A1');%xlswrite(excname,paciente{i},1,'A2');
xlswrite(excname,cart(2),1,'B1');
xlswrite(excname,cart(3),1,'C1');
xlswrite(excname,cart(4),1,'D1');
xlswrite(excname,cart(5),1,'E1');
xlswrite(excname,cart(6),1,'F1');
xlswrite(excname,cart(7),1,'G1');
xlswrite(excname,cart(8),1,'H1');

dimension=[];
din =[];

for i=1:length(paciente)
    paciente{i}
    rois=getfield(Roi_MRI,paciente{i});
    NRoi=fieldnames(rois);
    for j=1:length(NRoi)
        NRoi{j}
        serie=getfield(rois,NRoi{j});
        
        if ((~strncmp(paciente{i},'Roi_Breast_Mri_4',17))|(~strncmp(NRoi{j},'Roi_N',5)))
            if ((~strncmp(paciente{i},'Roi_Breast_Mri_5',17))|(~strncmp(NRoi{j},'Roi_N',5)))
                if (~strncmp(paciente{i},'Roi_Breast_Mri_47',17))% temporal%(~strncmp(NRoi{j},'Roi_N',5))&&
                %if ~isempty(getfield(rois,'Roi_N'))
                    serie=rmfield(serie,'label_1'); %Quitar REg normal del Est.4%
                    serie=rmfield(serie,'label_2');
                    if isfield(serie,'Bi_Rads')
                    Bi_rads=getfield(serie,'Bi_Rads'); 
                    serie=rmfield(serie,'Bi_Rads');
                    end
                    if isfield(serie,'Comentario')
                    Comentario{1}=getfield(serie,'Comentario');
                    serie=rmfield(serie,'Comentario');
                    end
                                        
                %end
                end
            end
        end
        
%         if (~strncmp(paciente{i},'Roi_Breast_Mri_47',17))%NRoi{j}%(~strncmp(NRoi{j},'Roi_N',5))&&
%         Bi_rads=getfield(serie,'Bi_Rads');            
%         Comentario{1}=getfield(serie,'Comentario');
%         
%         serie=rmfield(serie,'Bi_Rads');
%         serie=rmfield(serie,'Comentario');
%         end
         
        Nserie=fieldnames(serie);
        
        for k=1:length(Nserie)
            Nserie{k};
            imag=getfield(serie,Nserie{k});
            f=[];
            c=[];
            area=[];
            %if (~strncmp(Nserie{k},'label_1',8))&&(~strncmp(Nserie{k},'label_2',8))&&(~strncmp(Nserie{k},'Bi_Rads',7))&&(~strncmp(Nserie{k},'Comentario',8))
            [f c]=size(imag);
            area=f*c;
            
            tama(N,1)=f;
            tama(N,2)=c;
            tama(N,3)=f*c;
            %end
        
            dimension(N).paciente{1}=paciente{i};
            din{N,1}=paciente{i};
            
            dimension(N).roi{1}=NRoi{j};
            din{N,2}=NRoi{j};
            
            dimension(N).serie{1}=Nserie{k};
            din{N,3}=Nserie{k};
            
            dimension(N).Bi_rads{1}=Bi_rads;
            din{N,4}=Bi_rads;
            
            dimension(N).Coment{1}=Comentario;
            din{N,5}=Comentario;
            
            dimension(N).fila{1}=f;
            din{N,6}=f;
            
            dimension(N).columna{1}=c;
            din{N,7}=c;
            
            dimension(N).area{1}=area;      
            din{N,8}=area;      
            
%             M=num2str(N+1)
%             xlswrite(excname,paciente(i),1,['A',M]);%xlswrite(excname,paciente{i},1,'A2');
%             xlswrite(excname,NRoi(j),1,['B',M]);
%             xlswrite(excname,Nserie(k),1,['C',M]);
%             if isempty(Bi_rads)
%                 %xlswrite(excname,Bi_rads,1,['D',M]);
%             else
%                 xlswrite(excname,Bi_rads,1,['D',M]);
%             end            
%             
%             if isempty(Comentario)
%                 %xlswrite(excname,Comentario,1,['D',M]);
%             else
%                 xlswrite(excname,Comentario,1,['E',M]);
%             end  
%             
%             xlswrite(excname,f,1,['F',M]);
%             xlswrite(excname,c,1,['G',M]);
%             xlswrite(excname,area,1,['H',M]);
            
            N=N+1;         
        end
        Comentario=[];
        Bi_rads=[];
        Comentario=[];
        Bi_rads=[];
    end
end
%%
load('C:\Disco D\Proyecto de RMI\dimensiones\DATA.mat')
excname='C:\Disco D\Proyecto de RMI\dimensiones\DATA.xlsx';
xlswrite(excname,DATA,1,'A1');
%%
indnum=find(tama(:,3));
Tam(:,1) = tama(indnum,1);
Tam(:,2) = tama(indnum,2);
Tam(:,3) = tama(indnum,3);

Min=min(Tam(:,3))
Max=max(Tam(:,3))
avarg=mean(Tam(:,3))
desvS=std(Tam(:,3))
% Area
mind=find(Tam(:,3)==min(Tam(:,3)))%find(Tam(:,3)==30)
Mind=find(Tam(:,3)==max(Tam(:,3)))

AreMin(:,:)=Tam(mind,:);
AreMax(:,:)=Tam(Mind,:);

% fila
Fmind=find(Tam(:,1)==min(Tam(:,1)))%find(Tam(:,3)==30)
FMind=find(Tam(:,1)==max(Tam(:,1)))

FMin(:,:)=Tam(Fmind,:);
FMax(:,:)=Tam(FMind,:);
Favarg=mean(Tam(:,1))
FdesvS=std(Tam(:,1))

% Columna
Cmind=find(Tam(:,2)==min(Tam(:,2)))%find(Tam(:,3)==30)
CMind=find(Tam(:,2)==max(Tam(:,2)))

CMin(:,:)=Tam(Cmind,:);
CMax(:,:)=Tam(CMind,:);

Cavarg=mean(Tam(:,2))
CdesvS=std(Tam(:,2))