function FeatEstudio = featsaly3(Roi_MRI, rootGVBS, Rsize)

% ENTRADAS
%   - Roi_MRI     --> Regiones extraídas, ordenadas por el numero del ROI en el estudio.
% SALIDAS
%   - FeatEstudio --> Características de Saliencia y medidas estadísticas de primer orden
%                     ordenadas por el numero del ROI en el estudio.
% FUNCIONES USADAS
%   - gbvs               --> genera las características de Saliencia basadas en
%                            GBVS.
%   - GetSkewAndKurtosis --> Calcula las medidas estadísticas de primer
%                            orden con base al hitograma.
% AUTORES:
%   - Henry Jhoán Areiza
%   - Carlos Andrés Duarte
%   - Andrés Eduardo Castro
%   - Gloria Mercedes Díaz

% Especifique en la funcion "gbvs_install" la direccion donde se encuentre
% almacenado el Toolbox GBVS.
gbvs_install(rootGVBS);%


%for i=1:length(fieldnames(Roi_MRI))
% length(fieldnames(dataEstuD))  getfield(dataEstuD,['Dinamico',num2str(DU)])
%con caracterisiticas de DIO

paciente = fieldnames(Roi_MRI);


FeatEstudio = [];

for i=1:length(paciente)%1:length(fieldnames(getfield(Roi_MRI,['Roi_Brest_Mri_',num2str(1)])))
    
    rois=getfield(Roi_MRI,paciente{i});
    NRoi=fieldnames(rois);
    Feature = [];
    
    for j=1:length(NRoi)
        
        Serie = getfield(rois,NRoi{j});
        label_1=getfield(Serie,'label_1');
        label_2=getfield(Serie,'label_2');
        Serie=rmfield(Serie,'label_1');
        Serie=rmfield(Serie,'label_2');
        Serie=rmfield(Serie,'Bi_Rads');
                
        if isfield(Serie,'Comentario')
             Serie=rmfield(Serie,'Comentario');
        end
        nameSerie = fieldnames(Serie);
        
        for x=1:length(nameSerie)
            img=[];
            img = getfield(Serie,nameSerie{x});
            if ( strcmp(class(img),'double') == 1 ) img = uint16(img*65535); end %double(img)/((2^16)-1);
            
            imgR = [];
            if Rsize ~= 0
              imgR = imresize(img,[Rsize Rsize]);
            else
                imgR = img;
            end
            map=[];
            map = gbvs(imgR);
            
            sal(x).name=nameSerie{x};

            intensity = map.Conspicuity_maps_resized{1,1};
            intensity = uint16(intensity*65535);
            %sal.intensity{x}=intensity;
            sal(x).intensity=intensity;

            motion = map.Conspicuity_maps_resized{1,2};
            motion = uint16(motion*65535);
            %sal.motion{x}=motion;
            sal(x).motion=motion;
            
            orientation = map.Conspicuity_maps_resized{1,3};
            orientation = uint16(orientation*65535);
            %sal.orientation{x}=orientation;
            sal(x).orientation=orientation;

            Saliency = map.master_map_resized;
            Saliency = uint16(Saliency*65535);
            %sal.Saliency{x}=Saliency;
            sal(x).Saliency=Saliency;
            
            % histogramas.%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %histo.name{x}=nameSerie{x};
            histo(x).name=nameSerie{x};
           
            % region original
            [hisIn(:,1) hisIn(:,2)] = imhist(img,65535);
            %histo.intensity{x}=hisIn;
            histo(x).region=hisIn;
            hisIn=[];


            [hisIn(:,1) hisIn(:,2)] = imhist(intensity,65535);
            %histo.intensity{x}=hisIn;
            histo(x).intensity=hisIn;
            hisIn=[];
            
            [hisIn(:,1) hisIn(:,2)] = imhist(motion,65535);
            %histo.motion{x}=hisIn;
            histo(x).motion=hisIn;
            hisIn=[];
            
            [hisIn(:,1) hisIn(:,2)] = imhist(orientation,65535);
            %histo.orientation{x}=hisIn;
            histo(x).orientation=hisIn;
            hisIn=[];
            
            [hisIn(:,1) hisIn(:,2)] = imhist(Saliency,65535);
            %histo.Saliency{x}=hisIn;
            histo(x).Saliency=hisIn;
            hisIn=[];
            
        %end
        
        Feature=setfield(Feature,NRoi{j},'Mapas',sal);
        Feature=setfield(Feature,NRoi{j},'Histograma',histo);
        
        %for z=1:length(histo) % 6 es el numero de momentos, o caracteristicas.
        
        %file:///C:/Users/itm/Desktop/3267-11464-1-PB.pdf
            moments(x).name=histo(x).name;%nameSerie{x};
            
            I=histo(x).region(:,2);
            hi=histo(x).region(:,1);
            hiN= (hi-min(hi))/(max(hi)-min(hi));%hiN ./ numel(hiN);%
            [meanGL varianceGL skew sd kurtosis] = GetSkewAndKurtosis(I, hi);%(GLs, pixelCounts)
            % Imagen Original
            %Media - momento 1 
            moments(x).region{1} = meanGL;            %Desviacion Estandar - momento 2
            moments(x).region{2} = varianceGL;
            %Skewness - momento 3
            moments(x).region{3} = skew;
            %Kurtosis - momento 4
            moments(x).region{4} = kurtosis;
            %Varianza - momento 5
            moments(x).region{5} = sd;
            % Energia - 6
            ty=find(hiN);
            %hiN=hiN(ty);
            moments(x).region{6} = -sum(hiN(ty).*log2(hiN(ty))); %entropy(hi)
            I=[];
            hi=[];
            hiN=[];
            ty=[];
            %Media - momento 1 
            %moments(x).intensity{1} = sum(histo(x).intensity(:,1).*histo(x).intensity(:,2));% mean(histo.intensity{1,t}(:,1));
            
            I=histo(x).intensity(:,2);
            hi=histo(x).intensity(:,1);
            hiN= (hi-min(hi))/(max(hi)-min(hi));
            [meanGL varianceGL skew sd kurtosis] = GetSkewAndKurtosis(I, hi);
            % Imagen Original
            %Media - momento 1 
            moments(x).intensity{1} = meanGL;
            %Desviacion Estandar - momento 2
            moments(x).intensity{2} = varianceGL;
            %Skewness - momento 3
            moments(x).intensity{3} = skew;
            %Kurtosis - momento 4
            moments(x).intensity{4} = kurtosis;
            %Varianza - momento 5
            moments(x).intensity{5} = sd;
            % Energia - 6
            ty=find(hiN);
            moments(x).intensity{6} = -sum(hiN(ty).*log2(hiN(ty)));%entropy(hi)
            I=[];
            hi=[];
            hiN=[];
            ty=[];
            %Entropia - momento 6
            %moments(z).intensity{6} = -sum(histo(z).intensity(:,1).*log2(histo(z).intensity(:,1)));

            %Media - momento 1 
            %moments(x).motion{1} = sum(histo(x).motion(:,1).*histo(x).motion(:,2));% mean(histo.intensity{1,t}(:,1));
            
            I=histo(x).motion(:,2);
            hi=histo(x).motion(:,1);
            hiN= (hi-min(hi))/(max(hi)-min(hi));
            [meanGL varianceGL skew sd kurtosis] = GetSkewAndKurtosis(I, hi);
            % Imagen Original
            %Media - momento 1 
            moments(x).motion{1} = meanGL;
            %Desviacion Estandar - momento 2
            moments(x).motion{2} = varianceGL;
            %Skewness - momento 3
            moments(x).motion{3} = skew;
            %Kurtosis - momento 4
            moments(x).motion{4} = kurtosis;
            %Varianza - momento 5
            moments(x).motion{5} = sd;   
            % Etropia - 6
            ty=find(hiN);
            moments(x).motion{6} = -sum(hiN(ty).*log2(hiN(ty))); %entropy(hi)
            I=[];
            hi=[];
            hiN=[];
            ty=[];
            %Entropia - momento 6
            %moments(z).motion{6} = -sum(histo(z).motion(:,1).*log2(histo(z).motion(:,1)));

            %Media - momento 1 
            %moments(x).orientation{1} = sum(histo(x).orientation(:,1).*histo(x).orientation(:,2));% mean(histo.intensity{1,t}(:,1));
            
            I=histo(x).orientation(:,2);
            hi=histo(x).orientation(:,1);
            hiN= (hi-min(hi))/(max(hi)-min(hi));
            [meanGL varianceGL skew sd kurtosis] = GetSkewAndKurtosis(I, hi);
            % Imagen Original
            %Media - momento 1 
            moments(x).orientation{1} = meanGL;
            %Desviacion Estandar - momento 2
            moments(x).orientation{2} = varianceGL;
            %Skewness - momento 3
            moments(x).orientation{3} = skew;
            %Kurtosis - momento 4
            moments(x).orientation{4} = kurtosis;
            %Varianza - momento 5
            moments(x).orientation{5} =sd;
            % Etropia - 6
            ty=find(hiN);
            moments(x).orientation{6} = -sum(hiN(ty).*log2(hiN(ty)));
            I=[];
            hi=[];
            hiN=[];
            ty=[];
            %Entropia - momento 6
            %moments(z).orientation{6} = -sum(histo(z).orientation(:,1).*log2(histo(z).orientation(:,1)));
            
            %Media - momento 1 
            %moments(x).Saliency{1} = sum(histo(x).Saliency(:,1).*histo(x).Saliency(:,2));% mean(histo.intensity{1,t}(:,1));
            
            I=histo(x).Saliency(:,2);
            hi=histo(x).Saliency(:,1);
            hiN= (hi-min(hi))/(max(hi)-min(hi));
            [meanGL varianceGL skew sd kurtosis] = GetSkewAndKurtosis(I, hi);          
            % Imagen Original
            %Media - momento 1 
            moments(x).Saliency{1} = meanGL;
            %Desviacion Estandar - momento 2
            moments(x).Saliency{2} = varianceGL;
            %Skewness - momento 3
            moments(x).Saliency{3} = skew;
            %Kurtosis - momento 4
            moments(x).Saliency{4} = kurtosis;
            %Varianza - momento 5
            moments(x).Saliency{5} = sd;
            % Etropia - 6
            ty=find(hiN);
            moments(x).Saliency{6} = -sum(hiN(ty).*log2(hiN(ty)));
            I=[];
            hi=[];
            hiN=[];
            ty=[];
            %Entropia - momento 6
            %moments(z).Saliency{6} = -sum(histo(z).Saliency(:,1).*log2(histo(z).Saliency(:,1)));
            %moments(z).label=label;
            fprintf('characterization - %s',paciente{i});fprintf(' - %s', NRoi{j});fprintf(' - %s', nameSerie{x});fprintf('\n');
            
        end
        
        Feature=setfield(Feature,NRoi{j},'Momentos',moments);
        Feature=setfield(Feature,NRoi{j},'Label_1',label_1);
        Feature=setfield(Feature,NRoi{j},'Label_2',label_2);
        
    end
    
    FeatEstudio = setfield(FeatEstudio,paciente{i},Feature);

end
end
