classdef LogisticRegressionFit
   properties
       beta;
       trainingData;
       trainingDataResults;
       validationData;
       validationDataResults; 
       nFeatures;
       nTrainingData;
       nValidationData;
       validationPerformance;
   end
   
   methods
      
       function obj = LogisticRegressionFit(trainingData, trainingDataResults, validationData, validationDataResults)
           obj.trainingDataResults = trainingDataResults;
           obj.validationDataResults = validationDataResults;
           
           obj.nFeatures = size(trainingData,1)+1;
           obj.nTrainingData = size(trainingData, 2);
           obj.nValidationData = size(validationData,2);
           obj.trainingData = [ones(1,obj.nTrainingData); trainingData];
           obj.validationData = [ones(1,obj.nValidationData); validationData];
           
           %Inicializamos los parámetros del modelo 
           obj.beta = ones(1,obj.nFeatures);
       end
       
       function obj = trainByGradientDescent(obj, epochs, learningRate)
           
           %Inicializamos los desempeños de entrenamiento
           obj.validationPerformance = [];
           bar = waitbar(0,strcat("Ajustando por gradiente "));
           %Para cada epoca
           for i = 1:epochs
               waitbar(i/epochs,bar)
               %Calculamos el gradiente
               gradient = zeros(1,obj.nFeatures);
               for j = 1:obj.nTrainingData
                   xVec = obj.trainingData(:,j);
                   yVec = obj.trainingDataResults(:,j);
                   gradient = gradient + (1/obj.nTrainingData)*((1/(1+exp(-obj.beta*xVec)))-yVec)*xVec';
               end
               %Actualizamos
               obj.beta = obj.beta - learningRate*gradient;
               
               %Ahora vamos a calcular los desempeños
               
               errorValidation = 0;
               for j = 1:obj.nValidationData
                  errorValidation = errorValidation + (1/obj.nValidationData)*obj.computeLossFunction(obj.validationData(:,j), obj.validationDataResults(:,j));
               end
               
               obj.validationPerformance = [obj.validationPerformance, errorValidation]; 
           end
           close(bar);
       end
       
       function obj = trainByStochasticGradientDescent(obj, epochs, learningRate)
           
           %Inicializamos los desempeños de entrenamiento
           obj.validationPerformance = [];
           bar = waitbar(0,strcat("Ajustando por gradiente estocástico"));
           %Para cada epoca
           for i = 1:epochs
               waitbar(i/epochs,bar)
               %Calculamos el gradiente estocasticamente
               randomIndex = randi(obj.nTrainingData);
               xVec = obj.trainingData(:,randomIndex);
               yVec = obj.trainingDataResults(:,randomIndex);
               gradient = ((1/(1+exp(-obj.beta*xVec)))-yVec)*xVec';
               
               %Actualizamos
               obj.beta = obj.beta - learningRate*gradient;
               
               %Ahora vamos a calcular los desempeños
               
               errorValidation = 0;
               for j = 1:obj.nValidationData
                  errorValidation = errorValidation + (1/obj.nValidationData)*obj.computeLossFunction(obj.validationData(:,j), obj.validationDataResults(:,j));
               end
               
               obj.validationPerformance = [obj.validationPerformance, errorValidation]; 
           end
           close(bar);
       end
       
       
       function obj = trainByMinibatch(obj, epochs, learningRate, batches)
           %Primero vamos a hacer un shuffle como el que haciamos al
           %dividir en datos de entrenamiento.
           newIndexes = randperm(obj.nTrainingData);
           shuffledTrainingData = obj.trainingData(:,newIndexes);
           shuffledTrainingDataResults = obj.trainingDataResults(:,newIndexes);
           batchSize = round(obj.nTrainingData/batches);
           %Inicializamos los desempeños de entrenamiento
           obj.validationPerformance = [];
           bar = waitbar(0,strcat("Ajustando por Mini batch"));
           %Para cada epoca
           batch = 0;
           for i = 1:epochs
               waitbar(i/epochs,bar)
               %disp(batch*batchSize +1)
               %disp((batch+1)*batchSize +1)
               batchData = shuffledTrainingData(:,batch*batchSize +1: (batch+1)*batchSize);
               batchResults = shuffledTrainingDataResults(:,batch*batchSize +1: (batch+1)*batchSize);
               gradient = zeros(1,obj.nFeatures);
               for j = 1:batchSize
                   xVec = batchData(:,j);
                   yVec = batchResults(:,j);
                   gradient = gradient +(1/batchSize)*((1/(1+exp(-obj.beta*xVec)))-yVec)*xVec';
               end
               obj.beta = obj.beta -learningRate*gradient;
               if(batch +1 >= batches)
                   batch = 0;
               else 
                   batch = batch +1;
               end
               errorValidation = 0;
               for j = 1:obj.nValidationData
                  errorValidation = errorValidation + (1/obj.nValidationData)*obj.computeLossFunction(obj.validationData(:,j), obj.validationDataResults(:,j));
               end
               
               obj.validationPerformance = [obj.validationPerformance, errorValidation]; 
           end
           close(bar);
       end
       
       function L = computeLossFunction(obj,x, y)
            L = (y*log(1/(1+exp(-(obj.beta*x)))) + (1-y)*log((exp(-obj.beta*x))/(1+exp(-obj.beta*x))));            
       end
       
       function yPred = predict(obj,x)
           if(x(1)~=1)
            x = [1;x];
           end
           probability = 1/(1+exp(-(obj.beta*x)));
           
           if(probability > 0.5)
               yPred = 1;
           else 
               yPred = 0;
           end 
       end
       
       function t = getContingencyTable(obj)
           truePositives = 0;
           falsePositives = 0;
           falseNegatives = 0;
           trueNegatives = 0;
           
           for i = 1:obj.nValidationData
              xVal = obj.validationData(:,i);
              yPred =  obj.predict(xVal);
              yReal = obj.validationDataResults(:,i);
              
              if(yPred == 1 && yReal == 1)
                 truePositives = truePositives +1;
              elseif(yPred == 1 && yReal == 0)
                 falsePositives = falsePositives +1;
              elseif(yPred == 0 && yReal == 1)
                 falseNegatives = falseNegatives + 1;
              elseif(yPred == 0 && yReal == 0)
                  trueNegatives = trueNegatives + 1;
              end
           end
           sensitivity = truePositives/(truePositives + falseNegatives);
           specificity = trueNegatives/(trueNegatives + falsePositives);
           accuracy  = (truePositives + trueNegatives)/(truePositives + trueNegatives + falseNegatives + falsePositives);
           t = table(truePositives, falsePositives, falseNegatives, trueNegatives, sensitivity, specificity, accuracy,'VariableNames',{'VP','FP', 'FN', 'VN','sensibilidad','Especificidad','Accuracy'});
       end
        
    
       
       
       
       
   end
    
    
    
end