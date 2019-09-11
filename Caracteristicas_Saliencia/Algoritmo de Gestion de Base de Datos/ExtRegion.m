
function [Roi_MRI Roi_Estudios] = ExtRegion(P,savepaht,N,z,w,h)

% phad=direccion en la que se encuentran guardados los estudios y la carpeta que
% contenca los CSV, estos dos deben de estar las palabras Mri y CSV
% respectivamente.
%
%savepaht =  direccion en la que se desee almacenar las regiones recortadas
%de las imagenes.
%
%N = es el numero correspondiente a los estudios que se desea leer o
%recorte, este debe de estar en forma de vector, en el que se especifican
%los estuidos a trabajar. ej: [1 2 3 4 5 6 7 ...] 0 [1 3 7 9 11] etc.
% En el caso de que no se requiera especificar los estudios a leer, solo ingrese
% un vector vacio de la forma [].
%
%W y H es la mitad el ancho y del alto que va a tener la region a recortar,
%se deben especificar ambas, así estas sean iguales.

phad=P{1};
tipca='*Mri*';
tipcsv= '*CSV*';
folderPac = dir(fullfile(phad,tipca));
%folderROI = dir(fullfile(phad,tipcsv));
folderROI = dir(fullfile(P{2},tipca));%dir(fullfile([folderROI.folder,'\',folderROI.name],tipca));

TAB=readtable(P{3});%('C:\Users\itm\Documents\ROI_MRI.xlsx');%('C:\Users\itm\Google Drive\ROI_MRI.xlsx');
TAB = table2cell(TAB);%xlsread('C:\Users\itm\Google Drive\ROI_MRI.xlsx','slice 2d');

sFase = 'sFase';
series={};

L=length(folderPac);

% exist w
% if ans
%     if w==1
%         ban=1;
%     end
% else
%     Wi=0;
% end

if w~=1
     Wi=0;
end

if ((isempty(N))|(nargin<3))
    vect = 1:L;
else%if nargin==3
    %L = length(N)
    vect = N;
end

Roi_MRI=[];
Roi_Estudios=[];
 
for i = vect
   
   %i=12
   fas ='0';
   
   serie=[];
   dataEstu=[];
   List_Roi=[];
   din = [];
   Bi_Rads=[];
   Comen=[];
   
   Foldout = dir([phad,'\',folderPac(1).name(1:end-1),num2str(i)]);
   
   if (isempty(Foldout))
       disp(['El estudio Breast_Mri_',num2str(i),' no se Encuentra'])
       pause(0.9)
       continue
   end
   
   FoldIn = dir([Foldout(1).folder,'\',Foldout(3).name]);%dir([phad,'\',folderPac(i).name,'\',Foldout(3).name]);
   tipos={'*DIF*'};
   tipos = [tipos;'*MAPA*';'*T1*';'*T2*';'*ST_COR*';'*T2W_SPAIR*';'*T2_SP*';'*sFase*';'*DIN*'];
   
   Dirname=[savepaht,'\Regiones\Roi_',folderPac(1).name(1:end-1),num2str(i)];
   pathful = FoldIn(1).folder;%([phad,'\',folderPac(i).name,'\',Foldout(3).name]);%FoldIn;%
   
   indt=1;%length(tipos); 
   
   % cargar los CSV
   name=[folderPac(1).name(1:end-1),num2str(i)];
   estudio = split(name,'_')%split(folderPac(i).name,'_')
   FolcsvIn = dir([folderROI(1).folder,'\',[folderROI(3).name(1:10),'_',estudio{3}]]);
   
   if (isempty(FolcsvIn))
       disp(['El estudio Breast_Mri_',num2str(i),' no Cuenta con Archivo CSV, por lo que se Continua con el Estudio Siguiente'])
       pause(0.9)
       continue
   end
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for j = 1:length(FoldIn) % punto

    %pathful =([phad,'\',folderPac(i).name,'\',Foldout(3).name]);

        if ((fas == '0') |(fas == '5'))
            carp = dir(fullfile(pathful,tipos{indt}));
        else
            indt=nn;        
        end
        zx=1;

        tip = tipos{indt};
        tip = tip(2:end-1)
        

%-----------------------------Leer los estudios y los archivos csv.
        if (~isempty(carp)) % punto
            
%----------------------------- Condicion para Leer los CSV.
            csvname =tip;
            if (strncmp(tip,'MAPA',4))%((length(tip) == length('MAPA'))&(tip == 'MAPA'))

                csvname = 'ADC';

            elseif (strncmp(tip,'ST_COR',2)|strncmp(tip,'T2W_SPAIR',3)|strncmp(tip,'T2_SP',5))%(strncmp(tip,'ST_COR',2)|strncmp(tip,'eST_COR',3)|strncmp(tip,'sT2W_SPAIR',4)|strncmp(tip,'T2W_SPAIR',3))%((length(tip) == length('ST_COR'))&(tip == 'ST_COR'))|((tip == length('T2W_SPAIR'))&(tip == 'T2W_SPAIR'))

                csvname = 'ST';
                
            elseif (strncmp(tip,'sFase',5))
                csvname = 'FAS';

            end
            if i>=40% seria 99 para separar in espacio de mas para los 3 digitos
                dk=11;
            else
                dk=10;
            end
            csvname2 = [FolcsvIn(6).name(1:dk),num2str(i),'_'];%FolcsvIn(3).name(1:12); % punto

%-----------------------------------------------  Leer los estudios
            if ((length(carp)>1) & (tip~=sFase(1:length(tip))))
               max = 0;
               for n = 1:length(carp)
                   caprIm=[]
                   carpIm = dir([carp(n).folder,'\',carp(n).name,'\','*.dcm']); %dir([carp.folder,'\',carp(n).name,'\','*.dcm']); 
                   L = length(carpIm)
                   if L>max
                       max=length(carpIm);
                       indMx=n;
                   end
               end
               Cind=indMx;
               Cname=carp(indMx).name;
               FoldIm = dir([carp(indMx).folder,'\',carp(indMx).name,'\','*.dcm']);
               series{indt} = carp(indMx).name;
%-----------------------------Leer los CSV.
               pathempty = dir(fullfile([FolcsvIn(3).folder,'\',[csvname2,csvname,'.csv']]));
               M = readtable([FolcsvIn(3).folder,'\',[csvname2,csvname,'.csv']]);%readtable([csvfol.folder,'\',csvfol.name],'Delimiter',',','ReadVariableNames',true);
               M = table2cell(M);
               if (size(M,1)==0)
                    m = csvimport([FolcsvIn(3).folder,'\',[csvname2,csvname,'.csv']]);%,'uniformOutput',true,'outputAsChar',false %https://la.mathworks.com/matlabcentral/fileexchange/23573-csvimport
                    M = m;%(2,:);
                    for kl = 1:length(M)
                       M{kl}= str2num(M{kl});
                    end
                    M{8}=char(M{8});
               end
               subDir = [Dirname,'\',carp(indMx).name]
               mkdir(subDir)

            elseif (strncmp([tip(1),upper(tip(2:end))],['s',upper('Fase')],5))%(strncmp(tip,'sFase',5))%((length(tip)==length('sFase'))&(tip == 'sFase'))
                fas = num2str(str2num(fas)+1)
                M=[];
                for n = 1:length(carp)
                    
                    parts = regexp(carp(n).name , '^(?<letters>\<.+)_(?<rest>.*?)$' , 'names')
                    sust = parts.letters(1:6) 
                    sust=[sust(1),upper(sust(2:end))];
                    SS=[tip(1),upper(tip(2:end)),fas]

                    if sust==SS%[tip,fas]
                        Cind=n;
                        Cname=carp(n).name;
                        FoldIm = dir([carp(n).folder,'\',carp(n).name,'\','*.dcm']);
                        
                        subDir = [Dirname,'\',carp(n).name]
                        mkdir(subDir)
                        fases{str2num(fas)}=carp(n).name;
%----------------------------- Leer los CSV solo para las Fases.
                        pathempty = dir(fullfile([FolcsvIn(3).folder,'\',[csvname2,csvname,fas,'.csv']]));
                        M = readtable([FolcsvIn(3).folder,'\',[csvname2,csvname,fas,'.csv']]);%readtable([csvfol.folder,'\',csvfol.name],'Delimiter',',','ReadVariableNames',true);
                        M = table2cell(M);
                        if (size(M,1)==0)
                            m = csvimport([FolcsvIn(3).folder,'\',[csvname2,csvname,fas,'.csv']]);%,'uniformOutput',true,'outputAsChar',false %https://la.mathworks.com/matlabcentral/fileexchange/23573-csvimport
                            M = m;%(2,:);
                        for kl = 1:length(M)
                            M{kl}= str2num(M{kl});
                        end
                        M{8}=char(M{8});
                        end
                    end
                end
                nn=indt;
            else
               Cind=0;
               Cname=carp.name;
               FoldIm = dir([carp.folder,'\',carp.name,'\','*.dcm']);
               series{indt} = carp.name;
               subDir = [Dirname,'\',carp.name]
               mkdir(subDir)
%-----------------------------Leer los CSV.
               pathempty = dir(fullfile([FolcsvIn(3).folder,'\',[csvname2,csvname,'.csv']]));
               if (~isempty(pathempty))
                   M = readtable([FolcsvIn(3).folder,'\',[csvname2,csvname,'.csv']]);%readtable([csvfol.folder,'\',csvfol.name],'Delimiter',',','ReadVariableNames',true);
                   M = table2cell(M);
                   if (size(M,1)==0)
                    m = csvimport([FolcsvIn(3).folder,'\',[csvname2,csvname,'.csv']]);%,'uniformOutput',true,'outputAsChar',false %https://la.mathworks.com/matlabcentral/fileexchange/23573-csvimport
                    M = m;%m(2,:);
                    for kl = 1:length(M)
                       M{kl}= str2num(M{kl});
                    end
                    M{8}=char(M{8});
                   end
               end
            end
            
            indt=indt+1;

        for g = 1:numel(FoldIm)     

            imgSec{g,1}= dicomread([FoldIm(g).folder,'\',FoldIm(g).name]);%dicomread([phad,'\',folderPac(i).name,'\',Foldout(3).name,'\',FoldIn(j).name,'\',FoldIm(g).name]);

        end
               
        %%Coredenadas, Lectura del CSV
        %Rname = M(2:end,8); % M{r,8};
        for r = 1:size(M,1)%length(Rname)  % punto                           %%%%%%%%%% unicia el recorte de la imagen
         Rname = (M{r,8})%char(str2num(M{r,8}));     
         corte = split(Rname,'_')
         
         if (length(corte)==3)%(~isempty(partsII))
             parts.Roi = corte{1};
             parts.series = corte{2};
             parts.Partida = corte{3};
             parts.letters = [parts.Roi,'_',parts.series]
             
         elseif isempty(Rname)
             continue
         else
             fprintf('Error: Inicio o Fin del Volumen No especificado en CSV \n\n');
             %Temporal %%%%%%%%%%%%%%%%%%%%%%%
             parts.Roi = corte{1};
             parts.series = corte{2};
             parts.Partida = 'S';
             parts.letters = [parts.Roi,'_',parts.series]

         end
         % punto
         subDir2 = [Dirname,'\','ROI_',parts.Roi(2)]
         mkdir(subDir2)
         % Igualar las longitudes de el string o cadena.
         TIPO=tip; % se puede sacar del  for falta indicar el codiconal para el caso en el que sea T2W para serlo igual al STIR
         if ((length(tip) == length('ST_COT'))&(tip == 'ST_COT'))|((length(tip) == length('T2W_SPAIR'))&(tip == 'T2W_SPAIR')|strncmp(tip,'T2_SP',5))
            TIPO = 'ST' 
         elseif ((length(tip) == length('MAPA'))&(tip == 'MAPA'))
            TIPO = 'ADC';
         elseif ((length(tip) == length('sFase'))&(tip == 'sFase'))
             TIPO = ['FAS',fas];
         end
         
         S = parts.series;
         if length(TIPO)>length(parts.series)
             TIPO = tip(1:length(parts.series));
         elseif length(parts.series)>length(TIPO)
             S=parts.series(1:length(tip));
         end
 
         if ((TIPO == S)&(~isempty(pathempty)))%((isempty(busc)) & (tip == parts.secuencia(1:length(tip))))%tip == parts.secuencia
                      
             if parts.Partida=='C' % punto
                  
                 x_anI = M{r,24}; %primer puntp (esquina superior izquierda)
                 y_anI = M{r,25};
                 
                 x_posI = abs(M{r,24}-M{r,24+10});%M{r,24+10};%segunda puntp (esquina superior izquierda)
                 y_posI = abs(M{r,25}-M{r,25+10});%M{r,25+10};
                 roiI = [x_anI y_anI x_posI y_posI];
                 zindC = (M{r,1}+1);
                 if nargin >= 4
                     if z ~= 1
                        zindI = zindC-z; %r+1;
                        zindF = zindC+z;
                     end
                 else
                     zindI = zindC;
                     zindF = zindI;
                 end
                     
                 x_centro = M{r,24} + (abs(M{r,24}-M{r,24+10}))/2;
                 y_centro = M{r,25} + (abs(M{r,25}-M{r,25+10}))/2;
                 
                 reg=uint16([]);
                 reg = imcrop(imgSec{g,1},roiI);
                 [Xi Yi] = size(reg(:,:,1));
                 reg=uint16([]);
                 
                 if nargin==(5) && w==1 %%% 358 line
                     
                   media=42.6864952;
                   DST=20;
	
                    Wi=1;

                    Km = Xi;	
                    if Km<Yi
                        Km=Yi;
                    end

                    if Km>(media-(DST*2)) && Km<(media+(DST*2))

                        h=(Km+DST)/2
                        w=(Km+DST)/2
                    else
                        h=Km/2;%Km;
                        w=Km/2;%Km;
                    end
                 end
                 
                 if nargin==6 | Wi==1
                     
                     x_anI = x_centro-w;
                     y_anI = y_centro-h;
                     x_posI = w*2;
                     y_posI = h*2;
                    
                     if y_centro<h
                       dif = abs(y_centro-h);
                       y_anI = (y_centro-y_centro)+1%y_centro-y_centro;
                       y_posI = (h*2);
                     end
                     if x_centro<w
                       dif = abs(x_centro-w);
                       x_anI = (x_centro-x_centro)+1;%x_centro-x_centro;
                       x_posI = (w*2);
                     end
                     if (y_centro+h)>size(imgSec{1},1) %% verificar si se compora con respecto a las filas o columnas
                                                      % es size(imgSec{1},1) o size(imgSec{1},2)
                       y_anI = size(imgSec{1},1)-(h*2);%(y_centro-y_centro)+1;%y_centro-y_centro;
                       y_posI = (h*2);%size(imgSec{1},1);%
                     end
                     if (x_centro+w)>size(imgSec{1},2) %% verificar si se compora con respecto a las filas o columnas
                                                      % es size(imgSec{1},1) o size(imgSec{1},2)
                       x_anI = size(imgSec{1},2)-(w*2);%(y_centro-y_centro)+1;%y_centro-y_centro;
                       x_posI = (w*2);%size(imgSec{1},1);%
                     end  
                     
                     roiI = [x_anI y_anI x_posI y_posI];
                 end
                 
                 if strncmp(parts.series(1:end-1),'FAS',3)%((length(parts.series(1:end-1))==length('FAS'))&(parts.series(1:end-1) == 'FAS')) %strncmp(c1,c2,n) comopara los primero n elementos del sstring 
                    din(str2num(fas)).name = parts.series;
                    din(str2num(fas)).Roi{zx} = parts.Roi;
                    din(str2num(fas)).Reg{zx} = roiI;
                    
                    din(str2num(fas)).xaI(zx)=x_anI; %primer puntp (esquina superior izquierda)
                    din(str2num(fas)).yaI(zx)=y_anI;
                 
                    din(str2num(fas)).xpI(zx)=x_posI; 
                    din(str2num(fas)).ypI(zx)=y_posI;
                    
                    din(str2num(fas)).zI(zx)=zindI;
                    din(str2num(fas)).zF(zx)=zindF;
                    
                    din(str2num(fas)).xCe(zx)=x_centro;
                    din(str2num(fas)).yCe(zx)=y_centro;
                    
                     %coorFs{zx} = roiI;
                     %coorFs{zx,1}(1,1)
                     zx =zx+1;
                 end 
             end
             %%%%%%%%%% inicia el recorte de la imagen
             %%% calcular cual de los dos cuadros o regiones es mas grades
             %%% y que contega la otra...
             
                 ic=1;
                 for zz = zindI:zindF % punto
                    imagen = imgSec{zz,1}; %dicomread(strcat('C:\Disco D\Proyecto de RMI\Imagenes RM\Nueva carpeta\Brest_Mri_2\Brest_Mri - 536763485\sFase3_5359\IM-0039-00',Z,'.dcm'));
                    reg = imcrop(imagen(:,:,1),roiI);
                    region(:,:,ic)=reg;
                    ic=ic+1;
    % 
                    figure(1)
                    imshow(imagen,[])
                    hold on
                    rectangle('Position',roiI,'EdgeColor','r')
                    plot((x_centro),(y_centro),'+')
                    pause(0.9)
                 end

                 [X Y Z] = size(region);
                 for it=1:Z
    % 
                    figure(2)
                    imshow(region(:,:,it),[]) % punto en la 4
                    hold on 
                    plot((x_centro-x_anI),(y_centro-y_anI),'+')%punto de interes.
                    hold off
                    pause(0.9)
                    if Z>1
                        if Wi==1
                            reOrg=uint16([]);
                            re=uint16([]);
                            reOrg=region;
                            re= imresize(region(:,:,it),[128 128]);%imresize(A,[numrows numcols]);
                            region=uint16([]);
                            region=re;
                        end
                        dicomwrite(region(:,:,it),[subDir,'\',parts.Roi,'_',parts.series,'_',num2str(it),'.dcm'])%%%%
                    end
                 end
                 
            if Wi==1 %% 442 line
                reOrg=uint16([]);
                re=uint16([]);
                reOrg=region;
                re= imresize(region,[128 128]);%imresize(A,[numrows numcols]);
                region=uint16([]);
                region=re;
            end
            
            % Guardado por serie  
            save([subDir,'\',parts.Roi,'_',parts.series,'.mat'],'region');
            %save([subDir,'\',parts.Roi,'_',parts.series,'.mat'],'region');
            if Z==1
                dicomwrite(region,[subDir,'\',parts.Roi,'_',parts.series,'.dcm'])%%%%
            end
            % Guardado por ROI
            save([subDir2,'\',parts.Roi,'_',parts.series,'.mat'],'region');
            % save([subDir2,'\',parts.Roi,'_',parts.series,'.mat'],'region');
            if Z==1
                dicomwrite(region,[subDir2,'\',parts.Roi,'_',parts.series,'.dcm'])%%%%
            end

            serie = setfield(serie,[parts.Roi,'_',parts.series],region)
            
%             if (strncmp(parts.Roi(2),'N'))
%                 List_Roi = setfield(List_Roi,'Roi_N',[parts.Roi,'_',parts.series],region)
%             end
                        
            List_Roi = setfield(List_Roi,['Roi_',parts.Roi(2)],[parts.Roi,'_',parts.series],region)
  
%                  
%        %continua trabajando con la region extraida... 
         
         % ...
             
         fprintf(['Estudio : ',name],'\n')    
         end % punto

         %k=k+1;
         region=uint16([]); % punto
         reg=uint16([]);
         %histo = [];
         close all;
        end
        
        if strncmp(tip,'DIN',3)%(isempty(pathempty))%else%((length(tip)==length('DINA'))&(tip == 'DINA')) ---->%cuando este vacia significa que cargo la serie dinamic0
         % Separacion del Dinamico en & fases.
            [List_RoiD dataEstuD] = dinamiwork(imgSec,din,subDir,Wi)
        end
        
        if (~strncmp(tip,'DIN',3)&(~isempty(serie))) %(~isempty(pathempty))
            
            dataEstu = setfield(dataEstu,Cname,serie)
        
        elseif (strncmp(tip,'DIN',3))

            for DU=1:length(fieldnames(dataEstuD))
                dataEstu = setfield(dataEstu,['Dinamico',num2str(DU)],getfield(dataEstuD,['Dinamico',num2str(DU)]));
            end
            %
            band=0;
            if isfield(List_Roi,'Roi_N')
                band= 1
                dh=getfield(List_RoiD,'Roi_N');
                for DU=1:length(fieldnames(dataEstuD))
                List_Roi = setfield(List_Roi,'Roi_N',['RN_Dinamico',num2str(DU)],getfield(dh,['RN_Dinamico',num2str(DU)]));
                end
            end
             for put=1:length(din(1).Roi)-band
                dh=getfield(List_RoiD,['Roi_',num2str(put)]);
                for DU=1:length(fieldnames(dataEstuD))
                    List_Roi = setfield(List_Roi,['Roi_',num2str(put)],['R',num2str(put),'_Dinamico',num2str(DU)],getfield(dh,['R',num2str(put),'_Dinamico',num2str(DU)]));%setfield(List_Roi,['Roi_',parts.Roi(2)],[parts.Roi,'_',parts.series],region)
                end
            end
        end
        %Roi_Estudios=setfield(Roi_Estudios,[folderPac(1).name(1:end-1),num2str(i)],dataSer)%struct(Cname,serie)
        serie=[];
        
        else
            indt=indt+1;
        end

            if indt>length(tipos) % punto
                %series = [series,fases];
                break
            end
    end
    
    esp=2;
    if i>9
        esp = 1;
    elseif i>99
        esp = 0;
    end
    mri=strncmp(TAB(:,1),upper(name(8:end)),length(name(7:end))+esp);%strncmp(TAB(:,1),upper([folderPac(1).name(7:10),]),length(folderPac(1).name(7:end))+esp);
    xt=find(mri);
    
     for hp = 1:length(xt)
         
         if (strncmp(TAB{xt(hp),2},['ROI ',num2str(hp)],length(TAB{xt(hp),2})) && isfield(List_Roi,['Roi_',num2str(hp)]))
            List_Roi = setfield(List_Roi,['Roi_',num2str(hp)],'label_1',TAB{xt(hp),17})
            List_Roi = setfield(List_Roi,['Roi_',num2str(hp)],'label_2',TAB{xt(hp),18})
            List_Roi = setfield(List_Roi,['Roi_',num2str(hp)],'Bi_Rads',str2num(TAB{xt(hp),15}))
            List_Roi = setfield(List_Roi,['Roi_',num2str(hp)],'Comentario',TAB{xt(hp),14})
            
         elseif (strncmp(TAB{xt(hp),2},'ROI N',length(TAB{xt(hp),2})) && isfield(List_Roi,'Roi_N'))
             List_Roi = setfield(List_Roi,'Roi_N','label_1',TAB{xt(hp),17})
             List_Roi = setfield(List_Roi,'Roi_N','label_2',TAB{xt(hp),18})
             List_Roi = setfield(List_Roi,'Roi_N','Bi_Rads','NA')
             List_Roi = setfield(List_Roi,'Roi_N','Comentario','NA')
         end
     end
     
    
    Roi_Estudios=setfield(Roi_Estudios,name,dataEstu);%setfield(Roi_Estudios,[folderPac(1).name(1:end-1),num2str(i)],dataEstu)
    Roi_MRI = setfield(Roi_MRI,['Roi_',folderPac(1).name(1:end-1),num2str(i)],List_Roi)
    save([savepaht,'\Regiones','\','Reg_Estuidos','.mat'],'Roi_Estudios');%([Dirname,'\','Reg_Estuidos','.mat'],'Roi_Estudios');%Dirname
    save([savepaht,'\Regiones','\','ROI_Estuidos','.mat'],'Roi_MRI');%([Dirname,'\','ROI_Estuidos','.mat'],'Rois_Ser');phad
    imgSec=[];

    close all 
end