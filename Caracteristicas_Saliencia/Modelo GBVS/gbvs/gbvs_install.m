
%pathroot = pwd;
pathroot = 'C:\Disco D\Proyecto de RMI\toolbox\gbvs';
save -mat util/mypath.mat pathroot
addpath(genpath( pathroot ), '-begin');
savepath