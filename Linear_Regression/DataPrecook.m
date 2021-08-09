%Realiza tareas de preparación de datos, por ejemplo tareas
%de imputación, 

classdef DataPrecook
    
    methods
        %Divide los datos en conjuntos de entrenamiento y validación
        function [trainingSet, trainingSetResults, validationSet, validationSetResults] = splitData(obj,X,Y,validationPercentage)
            rowSize = size(X,2);
            newIndexes = randperm(rowSize);
            shuffledX = X(:, newIndexes);
            shuffledY = Y(:, newIndexes);
            
            cutIndex = floor((1-validationPercentage)*rowSize);
            trainingSet = X(:, 1:cutIndex);
            trainingSetResults = Y(:, 1:cutIndex);
            validationSet = X(:, cutIndex+1:end);
            validationSetResults = Y(:, cutIndex+1:end);
        end
        
        function M = imputateData(obj, imputationType, variable, flag, M)
            varColumn = M(:,variable);
            cleanedVar = [];
            n = length(varColumn);
            
            for i = 1:n
               if(varColumn(i) ~= flag)
                  cleanedVar = [cleanedVar,varColumn(i)]; 
               end
            end
            
            stats = Statistics();
            %Impuytación por media
            if(imputationType == ImputationType.MEAN)
                mean = stats.oneVariableMean(cleanedVar);
                for i = 1:n
                   if(varColumn(i) == flag)
                       M(i,variable) = mean;
                   end
                end
            
            %Imputación por mediana
            elseif(imputationType == ImputationType.MEDIAN)
                median = stats.getMedian(cleanedVar);
                for i = 1:n
                    if(varColumn(i) == flag)
                        M(i,variable) = median;
                    end
                end
            elseif(imputationType == ImputationType.MODE)
                mod = stats.getMode(cleanedVar);
                for i = 1:n
                   if(varColumn(i) == flag)
                      M(i,variable) = mod; 
                   end
                end
                
            elseif(imputationType == ImputationType.ELIMINATION)
                i = 1;
                while(true)
                   if(varColumn(i) == flag)
                      M(i,:) = [];
                   else
                       i = i+1;
                   end
                   
                   if(i > size(M,1))
                      break; 
                   end
                end
            end
            
        end
        
        function normalized = normalizeVariable(obj, x)
            stats = Statistics();
            mu = stats.oneVariableMean(x);
            sigma = stats.standardDeviation(x);
            normalized = (x-mu)/sigma;
        end
    end
    
    
end