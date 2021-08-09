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
            trainingSet = shuffledX(:, 1:cutIndex);
            trainingSetResults = shuffledY(:, 1:cutIndex);
            validationSet = shuffledX(:, cutIndex+1:end);
            validationSetResults = shuffledY(:, cutIndex+1:end);
        end
        
        
        function classArray = enumerateClasses(obj,classes, array)
            n = length(array);
            classArray = zeros(n,1);
            for i = 1:n
                class = find(classes == array{i})-1;
                classArray(i) = class;
            end
        end
        
        function convertedData = convertUnits(obj,initialUnit, destinationUnit, data)
            n = length(data);
            convertedData = zeros(n,1);
            if(initialUnit == Unit.POUND && destinationUnit == Unit.KILOGRAM)
                for i = 1:n
                    convertedData(i) = data(i)*0.453592;
                end
            elseif(initialUnit == Unit.INCHES && destinationUnit == Unit.METERS)
                for i = 1:n
                   convertedData(i) = data(i)*0.0254; 
                end
            end
            
        end
    end
    
    
end