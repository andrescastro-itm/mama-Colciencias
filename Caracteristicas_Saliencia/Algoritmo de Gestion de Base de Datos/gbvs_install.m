% Agrega al PATH el Toolbos que este se�alando en la direccion PATHROOT %
pathroot = '.\DirToolboxGBVS';
save -mat util/mypath.mat pathroot
addpath(genpath( pathroot ), '-begin');
savepath