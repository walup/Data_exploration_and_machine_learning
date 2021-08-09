classdef DataPrecook
    
    methods
        %Divide los datos en conjuntos de entrenamiento y validación
        function [trainingSet, trainingSetResults, validationSet, validationSetResults] = splitData(obj,X,Y,validationPercentage)
            nData = size(X,1);
            newIndexes = randperm(nData);
            shuffledX = X(newIndexes, :);
            shuffledY = Y(newIndexes, :);
            cutIndex = floor((1-validationPercentage)*nData);
            trainingSet = shuffledX(1:cutIndex, :);
            trainingSetResults = shuffledY(1:cutIndex,:);
            validationSet = shuffledX(cutIndex+1:end, :);
            validationSetResults = shuffledY(cutIndex+1:end, :);
        end
        
        function y = normalize(obj,x) 
            n = length(x);
            y = zeros(n,1);
            %Obtenemos la media y desviación estandar
            mu = mean(x);
            sd = std(x);
            for i = 1:n
                y(i) = (x(i)-mu)/sd;
            end
        end
            
    end
    
    
end