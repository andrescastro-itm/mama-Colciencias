function Ker = kernel_Pred(X1, X2, Kth, Sig, Sig_Mean, Red)
% Esta función calcula el kernel Gaussiano con el escalamiento local
% para la función de predicción
% 
% REFERENCIAS:
%       - "Self-tuning spectral clustering" (Zelnik-Manor, 2004).
% 
% ENTRADAS: 
%       - X1 --> matriz de datos de m x p, m muestras, p características.
%       - X2 --> matriz de datos de n x p, n muestras, p características.
%       - Kth --> k-ésimo vecino (en Zelnik igual a 7).
% 
% SALIDAS:
%       - Ker --> Kernel usando escalamiento local.
% 
% AUTORES:
%     - Henry Jhoán Areiza
%     - Diana Marcela Marín
%     - Carlos Andrés Duarte
%     - Andrés Eduardo Castro
%     - Gloria Mercedes Díaz

D = squeeze(sqrt(sum(bsxfun(@minus,X1,reshape(X2',1,size(X2,2),size(X2,1))).^2,2)));

if Red==1
    [~, ind] = sort(D');
    Sig_X1 = Sig(ind(1,:));
elseif Red==2
    [~, ind] = sort(D');
    Sig_X1 = Sig_Mean(ind(1,:));
else
    dist_X1 = sort(D');
    Sig_X1(:,1) = dist_X1(Kth,:);
end
    
Ker = zeros(length(Sig_X1),length(Sig));
for i = 1:length(Sig_X1)
    for j = 1:length(Sig)
        Ker(i,j) = exp(-(sum((X1(i,:)-X2(j,:)).^2))/(Sig_X1(i)*Sig(j)));
    end
end
