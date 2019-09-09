function [Opt, Acc, F1_Score, Med_geo, Sen, Esp, Relevance, Y_Pred] = K_Folds_Multi_LS(X, Y0, K, Kth, C, Eps, Tau, Pen, Red)
% Esta función ejecuta el método de evaluación por Validación Cruzada 
% 
% ENTRADAS:
%     - X   --> Celda con las características separadas por fuentes de información
%     - Y0  --> Vector de etiquetas
%     - K   --> Número de Folds para la validación cruzada
%     - Kth --> K-ésimo vecino para el método de escalamiento local
%     - C   --> Parámetro de regularización de la SVM
%     - Eps --> Parámetro de error del MKL (1e-3 por defecto)
%     - Tau --> Parámetro requerido por el algoritmo SMO
%     - Pen --> Tipo de penalización que será utilizada
%     - Red --> Algoritmo de reducción por Escalamiento Local que será usado
% 
% SALIDAS:
%     - Opt       --> Valor medio de la medida utilizada como función de costo
%     - Acc       --> Medidas de exactitud por cada Fold
%     - F1_Score  --> Medidas F1_Score por cada Fold
%     - Med_geo   --> Medidas de media geométrica por cada Fold
%     - Sen       --> Medidas de sensibilidad por cada Fold
%     - Esp       --> Medidas de especificidad por cada Fold
%     - Relevance --> Medidas de relevancia por cada Fold (valores ETA)
%     - Y_Pred    --> Etiquetas predichas para todos las muestras
% 
% AUTORES:
%     - Henry Jhoán Areiza
%     - Diana Marcela Marín
%     - Carlos Andrés Duarte
%     - Andrés Eduardo Castro
%     - Gloria Mercedes Díaz

m = size(Y0,1); % Número de ejemplos en la base de datos
n = numel(X); % Número de fuentes de información por cada ejemplo
div = floor(m/K); % Número de ejemplos que tendrá cada división para la validación

% Se inicializan las variables de salida
Y_Pred = zeros(m,1);
Relevance = zeros(K,n);
Acc = zeros(K,1);
F1_Score = Acc;
Med_geo = Acc;
Sen = Acc;
Esp = Acc;

[X, Y, Ord] = DesordenarUnbalanced(X, Y0, K); % Se desordenan las muestras

ind = (1:m)';
training_data = cell(1,n);
test_data = cell(1,n);
added = 1;
for k = 1:K
    for i = 1:n
        if(k ~= K) % Se Divide la base de datos en prueba y entrenamiento
            test_data{1,i}.X = X{1,i}(((k-1)*div+1):(k*div),:);
            test_y = Y(((k-1)*div+1):(k*div),:);
            
            training_data{1,i}.ind = ind;
            training_data{1,i}.X = X{1,i};
            training_data{1,i}.y = Y; 
            training_data{1,i}.ind(((k-1)*div+1):(k*div),:) = [];
            training_data{1,i}.X(((k-1)*div+1):(k*div),:) = [];
            training_data{1,i}.y(((k-1)*div+1):(k*div),:) = [];
            
            training_data{1,i}.ind = 1:numel(training_data{1,i}.y);
            
        else % Se divide la base de datos en prueba y entrenamiento para la última iteración
            test_data{1,i}.X = X{1,i}(((k-1)*div+1):end,:);
            test_y = Y(((k-1)*div+1):end,:);

            training_data{1,i}.X = X{1,i}(1:(k-1)*div,:);
            training_data{1,i}.y = Y(1:(k-1)*div,:);
        end
    end 
    
    Ker = round(Kth)*ones(1,n); % Parámetros para calcular los kernels
    
    % Se configuran los parámetros para el entrenamiento del modelo
    T = cell(1,n); T(:) = {'true'};
    F = cell(1,n); F(:) = {'false'};
    parameters = glmksvm_parameter();
    parameters.C = C; 
    parameters.eps = Eps;
    parameters.tau = Tau; 
    parameters.ker = Ker;
    parameters.nor.dat = T; % Normalización de los datos por Z-Score
    parameters.nor.ker = F; % Normalización de los kernels
    parameters.opt = 'libsvm'; 
    parameters.p = Pen;
    parameters.Red = Red;
    
    rng(0); % Semilla de procesos aleatorios (Garantiza reproducibilidad)
    model = glmksvm_train_LS(training_data, parameters); % Se entrena el modelo
    output = glmksvm_test_LS(test_data, model); % Se calculan las predicciones
    
    % Se calculan las medidas de evaluación
    Pr = sign(real(output.dis));
    Pr(Pr~=1 & Pr~=-1) = 1;
    acc = sum(Pr==test_y)/length(test_y);
    Acc(k,1) = acc;
    [~, Sent, Espt, ~, ~, Med_geot, F1_Scoret] = Med_Eval(test_y, Pr);
    F1_Score(k,1) = F1_Scoret(2);
    Med_geo(k,1) = Med_geot(2);
    Sen(k,1) = Sent(2);
    Esp(k,1) = Espt(2);

    % Se guardan las etiquetas predichas
    Y_Pred(added:added+length(test_y)-1) = sign(output.dis);
    
    % Se guardan las medidas de relevancia de las fuentes de información
    for i = 1:n
        Relevance(k,i) = model.sup{1,i}.eta;
    end
    
    added = added+length(test_y); % Contador de muestras procesadas
    
end

Y_Pred = Y_Pred(Ord); % Se reordenan las etiquetas predichas
Opt = -mean(Med_geo); % Se define la medida que se usará como función de costo
    
end

function [X_desord, Y_desord, Ord] = DesordenarUnbalanced(X, Y, folds)
% Esta función desordena la base de datos garantizando que cada división
% del K-Fold tenga el mismo PORCENTAJE de ejemplos por cada clase
% 
% ENTRADAS:
%     - X     --> Celda con las características separadas por fuentes de información
%     - Y     --> Vector de etiquetas
%     - folds --> Número de Folds para la validación cruzada
% 
% SALIDAS:
%     - X_desord --> Celda de características desordenada
%     - Y_desord --> Vector de etiquetas desordenado
%     - Ord      --> Vector de posiciones originales de las muestras
% 
% AUTORES:
%     - Henry Jhoán Areiza
%     - Diana Marcela Marín
%     - Carlos Andrés Duarte
%     - Andrés Eduardo Castro
%     - Gloria Mercedes Díaz

rng(0); % Semilla de procesos aleatorios
porc = 1/folds; % Se calcula el porcentaje de ejemplos por cada 'fold'
Labels = unique(Y); % Se encuentran las clases diferentes en el vector "Y"
ord = 1:length(Y); % Se crea el vector inicial para retonar el orden original de los datos

Ys = cell(length(Labels),1); % Se inicializa la celda de indices de las etiquetas 
for i = 1:length(Labels)
    Ys{i,1} = find(Y==Labels(i)); % Se extraen los índices de los ejemplos para cada etiqueta
    r = randperm(length(Ys{i,1})); % Se crea el vector de permutaciones
    Ys{i,1} = Ys{i,1}(r,:); % Permuta los ejemplos pertenecientes a cada etiqueta
end

X_desord = cell(size(X)); % Se inicializa la nueva celda X
Y_desord = zeros(size(Y)); % Se inicializa el nuevo vector Y
Ord = zeros(length(ord),1); % Se inicializa el vector de orden original

for c = 1:numel(X)
    added = 1; % Contador de ejemplos movidos
    for i = 1:folds
        for j = 1:length(Labels)
            ini = floor((i-1)*porc*length(Ys{j,1}) + 1); % Se calcula la posición inicial de los datos que se moverán
            fin = floor(i*porc*length(Ys{j,1})); % Se calcula la posición final de los datos que se moverán
            X_desord{1,c}(added:added+fin-ini,:) = X{1,c}(Ys{j,1}(ini:fin),:); % Se Guardan los ejemplos desordenados
            Y_desord(added:added+fin-ini) = Y(Ys{j,1}(ini:fin)); % Se Guardan las etiquetas desordenadas
            Ord(added:added+fin-ini) = ord(Ys{j,1}(ini:fin)); % Se Guardan los indices de los datos movidos
            added = added+fin-ini+1;     
        end
    end
end

[~,Ord] = sort(Ord); % Se obtienen los indices de los datos desordenados respecto a su posisción original

end

function [Matriz, Sen, Esp, Pre, Acc, Med_geo, F1_Score] = Med_Eval(Y_real, Y_pred)
% Esta función evalúa el desempeño de un determinado algoritmo de
% clasificación basándose en sus predicciones.
% 
% ENTRADAS:
%     - Y_real --> Etiquetas originales
%     - Y_pred --> Etiquetas predichas
% 
% SALIDAS:
%     - Matriz    --> Matriz de confusión de las predicciones
%     - Sen       --> Medidas de sensibilidad por cada clase
%     - Esp       --> Medidas de especificidad por cada clase
%     - Pre       --> Medidas de precisión por cada clase
%     - Acc       --> Medidas de exactitud por cada clase
%     - Med_geo   --> Medidas de media geométrica por cada clase
%     - F1_Score  --> Medidas F1_Score por cada clase

Clases = unique(Y_real); % Se encuentran las diferentes etiquetas en "Y_real"
C = length(Clases); % Se calcula el número total de clases

% Se guardan las etiquetas originales
Y_real_Old = Y_real;
Y_pred_Old = Y_pred;

% Se redefinen las etiquetas
for i = 1:length(Clases)
    Y_real(Y_real_Old==Clases(i)) = i;
    Y_pred(Y_pred_Old==Clases(i)) = i;    
end

Matriz = zeros(C,C); % Se inicializa la matriz de confusión
for i = 1:length(Y_real) % Se llena la matriz de confusión
    Matriz(Y_real(i), Y_pred(i)) = Matriz(Y_real(i), Y_pred(i))+1;
end

Sen = zeros(C,1); % Se inicializa el vector para la sensibilidad
Esp = zeros(C,1); % Se inicializa el vector para la especificidad
Pre = zeros(C,1); % Se inicializa el vector para la precision
for i = 1:C
    Sen(i) = Matriz(i,i)/sum(Matriz(i,:)); % Se calcula la sensibilidad para cada clase
    Esp(i) = (sum(Matriz(:))-sum(Matriz(i,:))-sum(Matriz(:,i))+Matriz(i,i))/(sum(Matriz(:))-sum(Matriz(i,:))); % Se calcula la especificidad para cada clase
    Pre(i) = Matriz(i,i)/sum(Matriz(:,i)); % Se calcula la precision para cada clase
end

Acc = sum(diag(Matriz))/sum(Matriz(:)); % Se calcula la excatitud total de las predicciones
Med_geo = sqrt(Sen.*Esp); % Calculamos la media geométrica para cada clase

F1_Score = 2*((Pre.*Sen)./(Pre+Sen)); % Calculamos la medida de F1_Score para cada clase
try
    ~F1_Score;
catch
    F1_Score = zeros(C,1);
end

end
