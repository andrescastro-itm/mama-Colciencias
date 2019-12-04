
function [List_RoiD dataEstuD] = dinamiwork(imgSec,coord,subDirD,sh)
% Extraer las ROI de la secuencia Dinamico, fue un caso especial, debido a
% que en esta se encuentran embebidas 6 secuencias, por esta razón
% fue necesario generar un Script diferente.
%
% ENTRADAS
%   - imgSec  --> Dinamico embebido.
%   - coord   --> Coordenadas de la ROI. Se usaron las mismas que en la secuencia
%                 Fase1.
%   - subDirD --> Direccion donde se desee guardar las ROIs como DICOM.
%
% AUTORES:
%   - Henry Jhoán Areiza
%   - Carlos Andrés Duarte
%   - Andrés Eduardo Castro
%   - Gloria Mercedes Díaz


% lectura y separacion del dinamico     
    serieD =[];
    dataEstuD = [];
    List_RoiD=[];
     bj=0;
     bd=0;
     for ii = 1:round(length(imgSec)/6)
         for jj = 1:6
             if (mod(length(imgSec),6)~=0 & ii==round(length(imgSec)/6) & jj==6)
                break 
             end
             dinamicos{jj}{ii}=imgSec{jj+bj}; 
             
             if jj+bj == length(imgSec) % (length(imgSec)-(jj+bj))<6
                 break 
             end
         end
         bj=bj+jj;
     end

%serie=setfield(serie,[parts.Roi,'_',parts.series],region)
%     ---------------------------------- carca, muestra y recorta
     %los 6 dinamicos.
     
     for di = 1:length(dinamicos)
         
         cordin = coord(di-bd);
         bd=1;%bd+1;
         serieD = [];
        
        %Direccion del direcitorio donde quedara almacenada las variables o
        %imagenes en su defecto.
        dirDIn =[subDirD,'\','Dinamico',num2str(di)];
        mkdir(dirDIn);
         
        for ro =1:length(cordin.Roi)
         % Asignacion de Coordenadas
         
         x_anI = cordin.xaI(ro);%M{r,24}; %primer puntp (esquina superior izquierda)
         y_anI = cordin.yaI(ro);%M{r,25};

         x_posI = cordin.xpI(ro);%abs(M{r,24}-M{r,24+10});%M{r,24+10};%segunda puntp (esquina superior izquierda)
         y_posI = cordin.ypI(ro);%abs(M{r,25}-M{r,25+10});%M{r,25+10};
         
         roiI = cordin.Reg{ro};%[x_anI y_anI x_posI y_posI];

         zindI = cordin.zI(ro);%M{r,1}; %r+1;
         zindF = cordin.zF(ro);%zindI;
         
         x_centro = cordin.xCe(ro);%M{r,24} + (abs(M{r,24}-M{r,24+10}))/2;
         y_centro = cordin.yCe(ro);%M{r,25} + (abs(M{r,25}-M{r,25+10}))/2;
         
         %roiI = cordin.Reg{ro};
         
         ic=1;
         for z = zindI:zindF % punto
            imagenD = dinamicos{di}{1,z};%imgSec{z,1}; %dicomread(strcat('C:\Disco D\Proyecto de RMI\Imagenes RM\Nueva carpeta\Brest_Mri_2\Brest_Mri - 536763485\sFase3_5359\IM-0039-00',Z,'.dcm'));
            regD = imcrop(imagenD,roiI);
            regionD(:,:,ic)=regD;
            ic=ic+1;
            if sh==1
                figure(1)
                imshow(imagenD,[])
                hold on
                rectangle('Position',roiI,'EdgeColor','r')
                plot((x_centro),(y_centro),'+')
                pause(0.5)
            end
         end

         [X Y Z] = size(regionD);
         for it=1:Z
            if sh==1
                figure(2)
                imshow(regionD(:,:,it),[]) % punto en la 4
                hold on 
                plot((x_centro-x_anI),(y_centro-y_anI),'+')%punto de interes.
                hold off
                pause(0.5)
            end
            if Z>1
                % Redimencionar la imagen
%                 if Wi==1
%                     reOrg=uint16([]);
%                     re=uint16([]);
%                     reOrg=regionD;
%                     re= imresize(regionD(:,:,it),[128 128]);%imresize(A,[numrows numcols]);
%                     regionD=uint16([]);
%                     regionD=re;
%                 end
                dicomwrite(regionD(:,:,it),[dirDIn,'\',cordin.Roi,'_Dinamico_',num2str(di),'.dcm']);%%%%
            end

         end
        
        serieD=setfield(serieD,[cordin.Roi{ro},'_Dinamico',num2str(di)],regionD);
        List_RoiD=setfield(List_RoiD,['Roi_',cordin.Roi{ro}(2)],[cordin.Roi{ro},'_Dinamico',num2str(di)],regionD);
        
        serie=['_Dinamico',num2str(di)];
%         fprintf('Estudio : %s',name);
        fprintf(' - %s', serie);fprintf(' - %s',cordin.Roi{ro});fprintf('\n');  
        
        if nargin>2
        save([dirDIn,'\',cordin.Roi{ro},'_Dinamico',num2str(di),'.mat'],'regionD');
        dicomwrite(regionD,[dirDIn,'\',cordin.Roi{ro},'_Dinamico',num2str(di),'.dcm']);
        end
        
        regionD =uint16([]);
        regD =uint16([]);
        close all 
        end
       dataEstuD = setfield(dataEstuD,['Dinamico',num2str(di)],serieD);
     end
     
     
