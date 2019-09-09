function mod = glmksvm_train_LS(tra, par)
% Esta función entrena el modelo de MKL con SVM modificado a partir del
% métdodo de escalamiento local.
% 
% REFERENCIAS: 
%     - Gönen, M., & Alpaydın, E. (2011). Multiple kernel learning
%       algorithms. Journal of machine learning research, 12(Jul),
%       2211-2268.
% 
% ENTRADAS:
%     - tra --> Datos de entrenamiento
%     - par --> Configuracion del entrenamiento
% 
% SALIDAS:
%     - mod --> Modelo entrenado
% 
% AUTORES:
%     - Henry Jhoán Areiza
%     - Diana Marcela Marín
%     - Carlos Andrés Duarte
%     - Andrés Eduardo Castro
%     - Gloria Mercedes Díaz

    P = length(tra);
    for m = 1:P
        mod.nor.dat{m} = mean_and_std(tra{m}.X, par.nor.dat{m});
        tra{m}.X = normalize_data(tra{m}.X, mod.nor.dat{m});
    end
    
    N = size(tra{1}.X, 1);
    yyKm = zeros(N, N, P);
    
    for m = 1:P
        [Ker, mod.sup{m}.Sig] = kernel_Train(tra{m}.X, par.ker(m));
        yyKm(:, :, m) = (tra{m}.y * tra{m}.y') .* Ker;
    end
    
    eta = ones(1, P) / P;
    yyKeta = kernel_eta_sum(yyKm, eta);
    alp = zeros(N, 1);
    [alp, obj] = solve_svm(tra{1}, par, yyKeta, alp);
    mod.obj = obj;
    mod.sol = 1;
    
    cont  = 0;
    while 1 && P > 1
        oldObj = obj;
        [alp, eta, mod, obj, yyKeta] = learn_eta(tra, par, yyKm, alp, eta, mod);
        mod.obj = [mod.obj, obj];
        if (abs(obj - oldObj) <= par.eps * abs(oldObj)) || (cont >= 200)
            break;
        end
        cont = cont+1;
    end
    
    for m = 1:P
        sup = find(alp .* eta(m) ~= 0);
        if isempty(sup) == 0
            mod.sup{m}.ind = tra{m}.ind(sup);
            if par.Red == 1
                mod.sup{m}.X = tra{m}.X(sup, :);
                mod.sup{m}.Sig = mod.sup{m}.Sig(sup);
            elseif par.Red == 2
                mod.sup{m}.X = tra{m}.X(sup, :);
                mod.sup{m}.Sig_Mean = Sig_Mean(tra{m}.X, mod.sup{m}.Sig, sup);
                mod.sup{m}.Sig = mod.sup{m}.Sig(sup);
            else
                mod.sup{m}.X = tra{m}.X;
            end
            mod.sup{m}.y = tra{m}.y(sup);
            mod.sup{m}.alp = alp(sup);
        end
        mod.sup{m}.eta = eta(m);
    end
    
    sup = find(alp ~= 0);
    act = find(alp ~= 0 & alp < par.C);
    if isempty(act) == 0
        mod.b = mean(tra{1}.y(act) .* (1 - yyKeta(act, sup) * alp(sup)));
    else
        mod.b = 0;
    end
    
    mod.par = par;

end

function [alp, eta, mod, obj, yyKeta] = learn_eta(tra, par, yyKm, alp, eta, mod)
    sup = find(alp ~= 0);
    P = length(tra);
    nor = zeros(1, P);
    for m = 1:P
        nor(m) = eta(m) * sqrt(alp(sup)' *  yyKm(sup, sup, m) * alp(sup));
    end
    eta = nor.^(2 / (1 + par.p)) ./ (sum(nor.^(2 * par.p / (1 + par.p))))^(1 / par.p);    
    eta = eta ./ norm(eta, par.p);
    eta(eta < par.eps / P) = 0;
    eta = eta ./ norm(eta, par.p);
    yyKeta = kernel_eta_sum(yyKm, eta);
    [alp, obj] = solve_svm(tra{1}, par, yyKeta, alp);
    mod.sol = mod.sol + 1;
end
