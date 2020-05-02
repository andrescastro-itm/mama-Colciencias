%este script usa la variable de "FeatEstudioT" o "FeatureR.mat"
% load('H:\Marcados_Duarte\105_regiones_extr\Regiones\FeatureR.mat');
estudio=fieldnames(FeatEstudioT);
% roi_total={};
DIF=[];ADC=[];T1=[];T2=[];FAS1=[];FAS2=[];FAS3=[];FAS4=[];FAS5=[];
label_total=[];
len_sec = 0;
for i =1:length(estudio)
    
    rois=getfield(FeatEstudioT,estudio{i});
    roi_Num=fieldnames(rois);
    
    for j = 1:length(roi_Num)
        
        if strncmp(roi_Num{j}, 'Roi_N', 5)
            continue
        end
        
        roi_data = getfield(rois,roi_Num{j});
        mapas = roi_data.Mapas;
        mapas_name = fieldnames(mapas);
        
        %seguencias = mapas.name;
        %trabaja sobre un roi
        for k = 1:length(mapas)
            for z3 = 2:length(mapas_name)-1% -1 porque no se toma Saliency
                
                z = z3-1;
                %imagenes = getfield(mapas(k),mapas_name{z3});
                % x = filas, Y=columnas, z=mapas
                concat(:,:,z)=  getfield(mapas(k),mapas_name{z3});
                
            end
            % x = filas, Y=columnas, z=mapas, k = secuencia
            roi_serie(:,:,:,k)= concat;
            concat=[];
        end
        % len_sec = length(DIF);
        % x = filas, Y=columnas, z=mapas, 4d = total-roi
        
        DIF(:,:,:,len_sec+1) = roi_serie(:,:,:,1);%DIF{len_sec+1}
        ADC(:,:,:,len_sec+1) = roi_serie(:,:,:,2);
        T1(:,:,:,len_sec+1) = roi_serie(:,:,:,3);
        T2(:,:,:,len_sec+1) = roi_serie(:,:,:,4);
        FAS1(:,:,:,len_sec+1) = roi_serie(:,:,:,5);
        FAS2(:,:,:,len_sec+1) = roi_serie(:,:,:,6);
        FAS3(:,:,:,len_sec+1) = roi_serie(:,:,:,7);
        FAS4(:,:,:,len_sec+1) = roi_serie(:,:,:,8);
        FAS5(:,:,:,len_sec+1) = roi_serie(:,:,:,9);
        
        len_sec = size(DIF,4);
        roi_serie=[];
        
        len_label = length(label_total);
        label_total(len_label+1,1) = roi_data.Label_1;
%         label_total(len_label+1,2) = roi_data.Label_2;
        
        fprintf('%s',estudio{i});fprintf(' - %s', roi_Num{j});;fprintf('\n');
        
    end
    
end
mkdir('File-Roi');
save('File-Roi\DIF.mat','DIF');
save('File-Roi\ADC.mat','ADC');
save('File-Roi\T1.mat','T1');
save('File-Roi\T2.mat','T2');
save('File-Roi\FAS1.mat','FAS1');
save('File-Roi\FAS2.mat','FAS2');
save('File-Roi\FAS3.mat','FAS3');
save('File-Roi\FAS4.mat','FAS4');
save('File-Roi\FAS5.mat','FAS5');    
save('File-Roi\label.mat','label_total');