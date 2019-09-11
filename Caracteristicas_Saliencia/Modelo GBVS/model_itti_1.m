clc;
clear all;
close all;

gbvs_install;

img = dicomread('C:\Disco D\Proyecto de RMI\Imagenes RM\IM-0013-0002.dcm');

%img = region(:,:,4);
gbvs_install;
figure(3)
imshow(img,[])
%To compute a GBVS map:

%con caracterisiticas de DIO
map = gbvs(img); % map.master_map contains the actual saliency map 



figure(3)
imshow(map.master_map_filtrado_resized,[])

figure(4)
imshow(map.master_map_resized,[])

%To compute an Itti-Koch-Niebur map:
%map_itti = ittikochmap(img); % map_itti.master_map contains the actual saliency map 

%And you can visualize the saliency map on top of your image as follows:
 figure(5)
 show_imgnmap( img , map ); 

 %figure(2)
 %show_imgnmap( img ,map_itti ); 

%  figure(3)
%  params.channels = 'RIO';
%  map2 = gbvs(img);
%  show_imgnmap( img , map2 );
