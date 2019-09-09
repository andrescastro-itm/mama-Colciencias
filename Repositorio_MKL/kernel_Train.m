function [Ker, Sig] = kernel_Train(X, Kth)
% Estas función calcula el kernel Gaussiano con el escalamiento local
% 
% REFERENCIAS:
%       - "Self-tuning spectral clustering" (Zelnik-Manor, 2004).
% 
% ENTRADAS: 
%       - X   -->  matriz de datos de n x p, n muestras, p características.
%       - Kth -->  k-ésimo vecino (en Zelnik igual a 7).
% 
% SALIDAS:
%       - Ker -->  Kernel usando escalamiento local.
%       - Sig -->  Valores Sigma asociados a cada ejemplo.
% 
% AUTORES:
%     - Henry Jhoán Areiza
%     - Carlos Andrés Duarte
%     - Andrés Eduardo Castro
%     - Gloria Mercedes Díaz

D = dist(X');
distX = sort(D);
Kth = Kth + 1;

Sig(:,1) = distX(Kth,:);
Ker = exp(-(D.^2)./(Sig*Sig'));

