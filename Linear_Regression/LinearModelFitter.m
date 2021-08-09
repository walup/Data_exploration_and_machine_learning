classdef LinearModelFitter
    
    methods
        %En principio esto es general, así que se puede usar
        %para hacer regresión multivariada
        function [beta, rSquared, MSE] = fitByLeastSquares(obj,trainingSet,resultsTrainingSet, validationSet, resultsValidationSet)
            n = size(trainingSet,2);
            m = size(validationSet, 2);
            %Añadimos unos en la primera fila
            trainingSet = [ones(1,n);trainingSet];
            validationSet = [ones(1,m); validationSet];
            
            %Ajustamos el modelo a partir del conjunto de datos
            %para entrenar usando el método de minimos cuadrados
            beta = resultsTrainingSet*trainingSet'*inv(trainingSet*trainingSet');
            %Calculemos ahora el coeficiente de determinación
            stat = Statistics();
            muY = stat.multivariateMean(resultsTrainingSet);
            resSum = 0;
            totalSum = 0;
            nTraining = size(trainingSet,2);
            for i = 1:nTraining
                resSum = resSum +norm(beta*trainingSet(:,i)-resultsTrainingSet(:,i))^2;
                totalSum = totalSum +norm(resultsTrainingSet(:,i)-muY)^2;
            end
            
            rSquared = 1 - (resSum/totalSum);
            %Calculamos el error cuadrático medio (desempeño)
            %usando los datos de validación
            MSE = 0;
            nValidation = size(validationSet,2);
            for i = 1:nValidation
               MSE = MSE +(1/nValidation)*norm(beta*validationSet(:,i)- resultsValidationSet(:,i))^2; 
            end    
        end
        
        function [beta, performanceTraining, performanceValidation, rSquared] = fitByGradientDescent(obj, epochs, learningRate, trainingSet, trainingSetResults, validationSet, validationSetResults)
            %Tamaño de los arreglos
            nFeatures = size(trainingSet,1)+1;
            nTrainingData = size(trainingSetResults,2);
            nVariables = size(trainingSetResults,1);
            nValidationData = size(validationSet, 2);
            
            trainingSet = [ones(1, nTrainingData); trainingSet];
            validationSet = [ones(1,nValidationData); validationSet];
            
            %Inicializamos la matriz de parámetros
            beta = rand(nVariables,nFeatures);
            performanceTraining = [];
            performanceValidation = [];
            %Barra de progreso
            bar = waitbar(0,strcat("Ajustando por gradiente "));
            
            for i = 1:epochs
                %Actualizamos la barra de progreso
                waitbar(i/epochs,bar)
                %Calculamos el gradiente y actualizamos los parámetros
                grad = (2/nTrainingData)*(beta*trainingSet - trainingSetResults)*trainingSet'; 
                beta = beta - learningRate*grad;
                %Obtenemos el error con los datos de entrenamiento
                errorTraining = 0;
                predictions = beta*trainingSet;
                for j = 1:nTrainingData
                    errorTraining = errorTraining+ (1/nTrainingData)*norm(trainingSetResults(:,j)-predictions(:,j))^2;
                end
                performanceTraining = [performanceTraining, errorTraining];
                
                %Obtenemos el error con los datos de validación 
                predictions = beta*validationSet;
                errorValidation = 0;
                for j = 1:nValidationData
                    errorValidation = errorValidation +(1/nValidationData)*norm(validationSetResults(:,j)-predictions(:,j))^2;
                end
                
                performanceValidation = [performanceValidation, errorValidation];
            end
            %Obtenemos r cuadrada
            stat = Statistics();
            muY = stat.multivariateMean(trainingSetResults);
            resSum = 0;
            totalSum = 0;
            for i = 1:nTrainingData
                resSum = resSum +norm(beta*trainingSet(:,i)-trainingSetResults(:,i))^2;
                totalSum = totalSum +norm(trainingSetResults(:,i)-muY)^2;
            end
            rSquared = 1 - resSum/totalSum;
            close(bar);
        end
        
        
        %Grafico del ajuste entre dos variables, una como función de la
        %otra.
        function h = plotModel2D(obj,x,y,modelParams, rSquared, varName1, varName2)
            h = figure();
            b = modelParams(1);
            m = modelParams(2);
            model = @(x) m*x + b;
            yModel = model(x);
            xMin = min(x);
            xMax = max(x);
            xMiddle = (xMin + xMax)/2;
            yMax = max(y);
            
            hold on 
            title(strcat(varName1, " vs ", varName2))
            plot(x,y, 'Marker', 'o','Color','#42c6ff','LineStyle','None')
            plot(x,yModel, 'Color','#ffc917','LineWidth',2)
            xlabel(varName1)
            ylabel(varName2)
            text(xMiddle, yMax - 0.1*yMax, strcat("y = ", string(m),"x + ",string(b),"    r^2 = ", string(rSquared)))
            hold off
        end
        
        %Grafico del ajuste entre una variable en terminos de otras dos. 
        function h = plotModel3D(obj,x,y,z,modelParams, rSquared, varName1, varName2, varName3)
            
           h = figure();
           c = modelParams(1);
           a = modelParams(2);
           b = modelParams(3);
           
           minX = min(x);
           maxX = max(x);
           xMiddle = (minX + maxX)/2;
           
           minY = min(y);
           maxY  = max(y);
           yMiddle = (minY + maxY)/2;
           
           xInterval = linspace(minX, maxX, 100);
           yInterval = linspace(minY, maxY, 100);
           [X,Y] = meshgrid(xInterval, yInterval);
           Z = a*X +b*Y +c;
           zMin = min(z);
           hold on 
           title(strcat(varName3,"(",varName1, ",", varName2,")"))
           plot3(x,y,z,'o','Color','#42c6ff','LineStyle','None')
           surf(X,Y,Z);
           text(minX, minY, zMin, strcat("z = ", string(a),"x + ",string(b),"y + ",string(c),"    r^2 = ", string(rSquared)))
           xlabel(varName1)
           ylabel(varName2)
           zlabel(varName3)
           view([44.73 7.36])
           hold off
            
        end
        
    end
    
    
    
    
end
       