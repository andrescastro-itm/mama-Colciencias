% Agrega al PATH el Toolbos que este señalando en la direccion PATHROOT %
% pathroot = ['C:\Disco D\Proyecto de RMI\mama-Colciencias\Caracteristicas_Saliencia\Modelo GBVS\gbvs'];
% save -mat util/mypath.mat pathroot
% addpath(genpath( pathroot ), '-begin');
% savepath
function gbvs_install(dir)
%pathroot = pwd;
    pathroot = dir;
    save([dir,'\util\mypath.mat'],'pathroot')
    rootfull = [matlabroot,'\bin\'];
    save([rootfull,'util\mypath.mat'],'pathroot') %save -mat util/mypath.mat pathroot
    addpath(genpath( pathroot ), '-begin');
    savepath
end