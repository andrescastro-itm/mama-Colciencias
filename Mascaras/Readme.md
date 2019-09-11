# Generar Máscaras 
Para la generación de las máscaras de los ROIs en las diferentes secuencias de un estudio, es necesario tene para cada estudio una carpeta con las secuencias almacenadas en .nrrd, como se puede observar en la carpeta **Estudios**. 

La ejecución del código debe ser realizada desde **main_mascaras.py**, en el cuál es usado el archivo **Data_3_slices**, que contiene en cada fila los datos necesarios de cada ROI para generar la máscara.


| Estudio  | Nombre_ROI  | Secuencia  | Centro_x | Centro_y  | Centro_z  | Distancia_x  | ....  | Comentarios  |
| ------|-----|-----|-----|-----|-----|-----|-----|-----|
| MRI_#  	| R# 	| DIFUSION 	| 66.91  | 90.08  | 29  | 19.13  | ....  | ARTEFACTO  |


**main_mascaras.py** se encarga de búscar la ruta de cada secuencia (ADC, DIFUSION, Fase1) en cada estudio para generar las máscaras de todos los ROIS en cada una, utilizando la función **mascara2d_3d**, por lo cual, `los nombres con los que aparecen listados los estudios y secuencias en el archivo csv son los mismos con los que aparecen en la carpeta Estudios
`

Finalmente, en la función **mascara2d_3d** son ingresados los datos de ubicación y longitud de cada ROI en x,y,z para generar la máscara binaria.

## Librerías 
* Numpy
* os
* SimpleITK

