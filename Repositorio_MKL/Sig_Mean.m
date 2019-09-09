function Sig_M = Sig_Mean(X, Sig, Sup_Ind)

% Función que calcula el kernel Gaussiano con el escalamiento local
% propuesto en "Self-tuning spectral clustering" (Zelnik-Manor, 2004).
% Entradas: X   -->  matriz de datos de n x p, n muestras, p características.
%           Kth -->  k-ésimo vecino (en Zelnik igual a 7).
% Salidas:  Ker -->  Kernel usando escalamiento local.
%           Sig -->  Valores Sigma asociados a cada ejemplo.

No_sup = (1:length(Sig))';
No_sup(Sup_Ind) = [];

D = dist(X');
[~, ind] = sort(D(:,No_sup));

Sig_M = Sig;
Count = ones(size(Sig_M));

for i = 1:length(No_sup)
    j = 2;
    while isempty(find(Sup_Ind == ind(j,i),1))
        j = j+1;
    end
    Sig_M(ind(j,i)) = Sig_M(ind(j,i)) + Sig(No_sup(i));
    Count(ind(j,i)) = Count(ind(j,i)) + 1;
end

Sig_M = Sig_M(Sup_Ind)./Count(Sup_Ind);


