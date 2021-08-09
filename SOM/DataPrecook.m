classdef DataPrecook
    
    properties
        
        
    end
    
    
    methods
        %Normalizamos los datos del vector x
        function y = normalize(obj,x) 
            n = length(x);
            y = zeros(n,1);
            %Obtenemos la media y desviación estandar
            mu = mean(x);
            sd = std(x);
            for i = 1:n
                if(sd ~= 0)
                    y(i) = (x(i)-mu)/sd;
                else
                    y(i) = x(i)-mu;
                end
            end
        end
        
        function y = deNormalize(obj,x, mu, std)
            n = length(x);
            y = zeros(n,1);
            for i = 1:n
               y(i) = std*x(i) + mu; 
            end
        end
        
        function [trainingSet, trainingSetResults, validationSet, validationSetResults] = splitData(obj,X,Y,validationPercentage)
            colSize = size(X,1);
            newIndexes = randperm(colSize);
            shuffledX = X(newIndexes,:);
            shuffledY = Y(newIndexes,:);
            
            cutIndex = floor((1-validationPercentage)*colSize);
            trainingSet = shuffledX(1:cutIndex,:);
            trainingSetResults = shuffledY(1:cutIndex,:);
            validationSet = shuffledX(cutIndex+1:end,:);
            validationSetResults = shuffledY(cutIndex+1:end,:);
        end
        
        
    end
    
    
end