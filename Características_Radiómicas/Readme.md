# Extracción de características Radiómicas
Para la extracción de las característica radiómicas es necesario tener tanto las secuencias de cada estudio como las máscaras de los ROIs  en formato nrrd, como se ve en la carpeta **Estudios**. Ejecutando el archivo **Caracterizar_ROIS.py** se busca la ruta de cada secuencia en los estudios listados en **Data_3_slices.csv** y la máscara de cada uno de los ROIs en el estudio. 
Las características a extraer utilizando Pyradiomics son activadas en el archivo **Params.yaml**, definiendo los parámetros de cada tipo de característica, con el objetivo de establecerlas en la instrucción 
    **extractor = featureextractor.RadiomicsFeaturesExtractor(parametros)** y posteriormente obtener las características establecidas con la instrucción **result = extractor.execute(ruta_imagen, ruta_mascara)**

## Características disponibles en Pyradiomics

* First Order Statistics
* Shape-based (3D)
* Shape-based (2D)
* Gray Level Cooccurence Matrix
* Gray Level Run Length Matrix
* Gray Level Size Zone Matrix
* Neighbouring Gray Tone Difference Matrix
* Gray Level Dependence Matrix

## Librerías 

* Numpy
* os
* six
* SimpleITK
* matplotlib
* nrrd
* radiomics

## Referencias

* [Pyradiomics](https://pyradiomics.readthedocs.io/en/latest/installation.html)

