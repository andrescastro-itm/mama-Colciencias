
function DATA=lecturCSV(P,N)

% phad=direccion en la que se encuentran guardados los estudios y la carpeta que
% contenca los CSV, estos dos deben de estar las palabras Mri y CSV
% respectivamente.
%

%N = es el numero correspondiente a los estudios que se desea leer o
%recorte, este debe de tener una forma de vector en el que se especifican
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

TAB=readtable(P{3});%('C:\Users\itm\Google Drive\ROI_MRI.xlsx');
TAB = table2cell(TAB);%xlsread('C:\Users\itm\Google Drive\ROI_MRI.xlsx','slice 2d');

sFase = 'sFase';
series={};

L=length(folderPac);

exist w
if ans
    if w==1
        ban=1;
    end
else
    Wi=0;
end

if ((isempty(N))|(nargin<2))
    vect = 1:L;
else%if nargin==3
    %L = length(N)
    vect = N;
end

Roi_MRI=[];
Roi_Estudios=[];

No=1;

DATA{No,1}='Estudio';
DATA{No,2}='Nombre_ROI';
DATA{No,3}='Secuencia';
DATA{No,4}='Centro_x';
DATA{No,5}='Centro_y';
DATA{No,6}='Centro_z';
DATA{No,7}='Distancia_x';
DATA{No,8}='Distancia_y';
DATA{No,9}='N_Slice';
DATA{No,10}='Bi_Rads';
DATA{No,11}='Comentarios';
No=No+1;

for i = vect
   
   %i=12
   fas ='0';
   
   serie=[];
   dataEstu=[];
   List_Roi=[];
   data = [];
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
   
   %Dirname=[savepaht,'\Regiones\Roi_',folderPac(1).name(1:end-1),num2str(i)];
   pathful = FoldIn(1).folder;%([phad,'\',folderPac(i).name,'\',Foldout(3).name]);%FoldIn;%
   
   indt=1;%length(tipos); 
   
   % cargar los CSV
   name=[];
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
        tip = tip(2:end-1);
        
        if strncmp(tip,'DIN',3)%% 
            break %continue
        end
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
            if i>=99%40% seria 99 para separar in espacio de mas para los 3 digitos
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
%                subDir = [Dirname,'\',carp(indMx).name]
%                mkdir(subDir)

            elseif (strncmp([tip(1),upper(tip(2:end))],['s',upper('Fase')],5))%(strncmp(tip,'sFase',5))%((length(tip)==length('sFase'))&(tip == 'sFase'))
                fas = num2str(str2num(fas)+1)
                
                for n = 1:length(carp)
                    
                    parts = regexp(carp(n).name , '^(?<letters>\<.+)_(?<rest>.*?)$' , 'names')
                    sust = parts.letters(1:6) 
                    sust=[sust(1),upper(sust(2:end))];
                    SS=[tip(1),upper(tip(2:end)),fas]

                    if sust==SS%[tip,fas]
                        Cind=n;
                        Cname=carp(n).name;
                        FoldIm = dir([carp(n).folder,'\',carp(n).name,'\','*.dcm']);
                        
%                         subDir = [Dirname,'\',carp(n).name]
%                         mkdir(subDir)
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
%                subDir = [Dirname,'\',carp.name]
%                mkdir(subDir)
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

          g = 1;
%         for g = 1:numel(FoldIm)     
% 
             %imgSec = dicomread([FoldIm(g).folder,'\',FoldIm(g).name]);%dicomread([phad,'\',folderPac(i).name,'\',Foldout(3).name,'\',FoldIn(j).name,'\',FoldIm(g).name]);
             metainf=[];
             metainf = dicominfo([FoldIm(g).folder,'\',FoldIm(g).name]);
%         end
               
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
%          subDir2 = [Dirname,'\','ROI_',parts.Roi(2)]
%          mkdir(subDir2)
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
%                  if nargin == 4
%                      zindI = zindC-z; %r+1;
%                      zindF = zindC+z;
%                  else
%                      zindI = zindC;
%                      zindF = zindI;
%                  end
                 
                 x_dis=(abs(M{r,24}-M{r,24+10}));
                 y_dis=(abs(M{r,25}-M{r,25+10}));
                 x_centro = M{r,24} + (x_dis)/2;
                 y_centro = M{r,25} + (y_dis)/2;
                 
                 Volumen = (metainf.SliceThickness + metainf.SpacingBetweenSlices)/2;
                 
                 x_dismm = abs(M{r,26}-M{r,31});
                 z =round(x_dismm /Volumen);
%                  if mod(z,2)==0
%                      z = floor((z+1)/2);
%                  else
%                      z = floor(z/2);  
%                  end
                 
                esp=2;
                if i>9
                    esp = 1;
                elseif i>99
                    esp = 0;
                end
                
                mri=strncmp(TAB(:,1),upper(name(8:end)),length(name(7:end))+esp);%strncmp(TAB(:,1),upper([folderPac(1).name(7:10),]),length(folderPac(1).name(7:end))+esp);
                xt=find(mri)
                
                numRoi=str2num(parts.Roi(2));
                
                for hp = 1:length(xt)
                    if (strncmp(TAB{xt(hp),2},['ROI ',parts.Roi(2)],length(TAB{xt(hp),2})))
                        label_1=[];
                        label_1 = TAB{xt(hp),17};
                        label_2=[];
                        label_2 = TAB{xt(hp),18};
                        Bi_Rads=[];
                        Bi_Rads = str2num(TAB{xt(hp),15});
                        Comentario=[];
                        Comentario = TAB{xt(hp),14};
                        
                        break
                    end
                end
                
                if (isempty(Bi_Rads))
                    Bi_Rads='NA'
                end
                if (isempty(Comentario))
                    Comentario='NA'
                end
                
                DATA{No,1}=name;
                DATA{No,2}=parts.Roi;
                DATA{No,3}=parts.series;
                DATA{No,4}=x_centro;
                DATA{No,5}=y_centro;
                DATA{No,6}=zindC;
                DATA{No,7}=x_dis;
                DATA{No,8}=y_dis;
                DATA{No,9}=z;
                DATA{No,10}=Bi_Rads;
                DATA{No,11}=Comentario;
                No=No+1;
                 
             end
   
         end 

         %k=k+1;
         region=uint16([]); 
         reg=uint16([]);
         %histo = [];
         %close all;
        end
        serie=[];
        
        else
            indt=indt+1;
        end

        if indt>length(tipos) % punto
            %series = [series,fases];
            break
        end
        
    end
    
    imgSec=[];
    close all 
end