% Agrega al PATH el Toolbos que este señalando en la direccion PATHROOT %
pathroot = '.\DirToolboxGBVS';
save -mat util/mypath.mat pathroot
addpath(genpath( pathroot ), '-begin');
savepath