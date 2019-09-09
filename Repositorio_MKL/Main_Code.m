%% Ejemplo de uso MKL + SVM + Local Scaling
% Este código principal se encarga de llamar las funciones necesarias
% para realizar una prueba utilizando el método de MKL sobre una
% SVM potenciado con la técnica de escalamiento local.
% 
% En este ejemplo se ejecutan dos pruebas, la primera de ellas hace uso
% únicamente de las fuentes correspondientes a las características
% perceptuales, la segunda hace uso de las características perceptuales
% y las características radiómicas al mismo tiempo.
% 
% REFERENCIAS: 
%     - Gönen, M., & Alpaydın, E. (2011). Multiple kernel learning
%       algorithms. Journal of machine learning research, 12(Jul),
%       2211-2268.
%     - "Self-tuning spectral clustering" (Zelnik-Manor, 2004). 
% 
% ARCHIVOS REQUERIDOS:
%     - Data_Cancer.mat
% 
% ARCHIVOS GENERADOS:
%     - Resul_saliencia
%     - Resul_completo
% 
% TOOLBOX REQUERIDOS:
%     - LIBSVM --> http://www.csie.ntu.edu.tw/~cjlin/libsvm/
%     - MKL    --> http://www.cmpe.boun.edu.tr/~gonen/mkl
% 
% AUTORES:
%     - Henry Jhoán Areiza
%     - Carlos Andrés Duarte
%     - Andrés Eduardo Castro
%     - Gloria Mercedes Díaz


clear ; close; clc; % Limpia el área de trabajo

Data = {'Data_Cancer', 'Data_Cancer'}; % Nombre de los datos que utilizará cada prueba
Resu = {'Resul_saliencia', 'Resul_completo'}; % Nombre de los archivos de resultados
Vars = 3 * ones(1, numel(Resu)); % Número de variables a optimizar
Fuen = {1:9, 1:18}; % Indices de las fuentes que usará cada prueba
Pen  = ones(1, numel(Resu)); % Tipos de penalización que se utilizarán (L1 en este caso)
Red  = [1, 1]; % Algoritmo de Local Scaling que se utilizará para cada prueba

for P = 1:numel(Resu)
    tic; % Se inicia el conteo de tiempo
    fprintf('\n\nCARGANDO LA PRUEBA %d...\n', P)
    load(['./',Data{P}]); % Se cargan los datos
    Y(~Y) = -1; % Se ajustan las etiquetas para la SVM

    Nvar = Vars(P); % Número de variables a optimizar en la prueba actual

    lb = [2;  0.005; 0.1]; % Límites inferiores de optimización
    ub = [20; 10;    10]; % Límites superiores de optimización
    c = 0.5 + log(2); % Coeficientes individuale y social para el PSO
    options = optimoptions('particleswarm','MaxIterations',2,'SwarmSize',2,'DisplayInterval',1,...
              'Display','iter','SelfAdjustmentWeight',c,'SocialAdjustmentWeight',c);
  
    % Se configura la función que será optimizada
    fun = @(Par) K_Folds_Multi_LS(X(Fuen{P}),  Y, 10, Par(1), Par(2), 1e-3, Par(3), Pen(P), Red(P));
    
    [Opt, ~, Exitflag] = particleswarm(fun, Nvar, lb, ub, options); % Se ejecuta el PSO

    Optim = [round(Opt(1)), Opt(2:end)]; % Se guardan los valores óptimos encontrados
    Flag = Exitflag; % Se guarda el resultado de convergencia del PSO

    % Se calcula el desempeño del método en validación cruzada con los óptimos encontrados
    [~, Acu, F1St, MedGt, Sent, Espt, Rel] = K_Folds_Multi_LS(X(Fuen{P}), Y, 10, Optim(1), Optim(2), 1e-3, Optim(3), Pen(P), Red(P));
    Acc = mean(Acu);
    F1S = mean(F1St);
    MedG = mean(MedGt);
    Sen = mean(Sent);
    Esp = mean(Espt);
    Relev = mean(Rel);
    
    % Los resultados son mostrados en pantalla
    fprintf('\n##########  Prueba: %s  ########## \n', Resu{P});
    fprintf('Cros:\tAcc = %.2f\xB1%.2f\tMed_Geo = %.2f\xB1%.2f\tSen = %.2f\xB1%.2f\tEsp = %.2f\xB1%.2f\tF1_Score = %.2f\xB1%.2f\n',...
            100*Acc,100*std(Acu), 100*MedG,100*std(MedGt), 100*Sen,100*std(Sent), 100*Esp,100*std(Espt), 100*F1S,100*std(F1St)); 
    fprintf('\n');
    fprintf('Relevancia:\n');
    [Ord_Rel, ind] = sort(Relev,'descend');
    for j=(ind); fprintf('%s\t',Names{j}); end
    fprintf('\n');
    fprintf('%.2f\t', 100*Ord_Rel); fprintf('\n');
    fprintf('Kth = %d\tC = %.6f\tTau = %.6f', Optim);
    fprintf('\n\n');
    
    Time = toc; % Se detiene el conteo de tiempo
    save (['./',Resu{P}]); % Se guardan todos los resultados obtenidos
end
