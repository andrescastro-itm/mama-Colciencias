function out = glmksvm_test_LS(tes, mod)
% Esta función realiza la prediccción sobre los datos de prueba
% utilizando el modelo de MKL con SVM modificado a partir del
% métdodo de escalamiento local.
% 
% REFERENCIAS: 
%     - Gönen, M., & Alpaydın, E. (2011). Multiple kernel learning
%       algorithms. Journal of machine learning research, 12(Jul),
%       2211-2268.
% 
% ENTRADAS:
%     - tes --> Datos de prueba
%     - mod --> Modelo entrenado
% 
% SALIDAS:
%     - out --> Predicciones calculadas
% 
% AUTORES:
%     - Henry Jhoán Areiza
%     - Carlos Andrés Duarte
%     - Andrés Eduardo Castro
%     - Gloria Mercedes Díaz

    P = length(tes);
    for m = 1:P
        tes{m}.X = normalize_data(tes{m}.X, mod.nor.dat{m});
    end
    out.dis = mod.b * ones(size(tes{1}.X, 1), 1);
    for m = 1:P
        if mod.sup{m}.eta ~= 0
            if mod.par.Red==1
                K = kernel_Pred(tes{m}.X, mod.sup{m}.X, [], mod.sup{m}.Sig, [], mod.par.Red);
            elseif mod.par.Red==2
                K = kernel_Pred(tes{m}.X, mod.sup{m}.X, [], mod.sup{m}.Sig, mod.sup{m}.Sig_Mean, mod.par.Red);
            else
                K = kernel_Pred(tes{m}.X, mod.sup{m}.X, mod.par.ker(m), mod.sup{m}.Sig, [], mod.par.Red);
                K = K(:,mod.sup{m}.ind);
            end
            out.dis = out.dis + K * (mod.sup{m}.eta * mod.sup{m}.alp .* mod.sup{m}.y);
        end
    end
end
