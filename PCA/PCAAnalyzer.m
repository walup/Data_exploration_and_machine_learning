classdef PCAAnalyzer
   methods
      
       function covarianceMatrix = getCovarianceMatrix(obj, X)
          meanRows = mean(X,1);
          nData = size(X,1);
          nFeatures = size(X,2);
          covarianceMatrix = zeros(nFeatures, nFeatures);
          for i = 1:nData
              xi = X(i,:);
              covarianceMatrix = covarianceMatrix + (1/(nData - 1))*(xi - meanRows)'*(xi - meanRows);
          end
       end
       
       function [eigValues, eigVectors] = getComponents(obj, covarianceMatrix)
           eigValues = eig(covarianceMatrix);
           [eigVectors, ~] = eig(covarianceMatrix);
           
           %Vamos a normalizar los eigen-vectores.
           for i = 1:size(eigVectors,2)
              vec = eigVectors(:,i);
              eigVectors(:,i) = vec/norm(vec); 
           end
           
           %Vamos a ordenarlos de mayor a menor acorde a su eigenvalores
           [eigValues,idx] = sort(real(eigValues));
           orderedEigVectors = zeros(size(eigVectors,1), size(eigVectors,2));
           eigValues = fliplr(eigValues')';
           idx = fliplr(idx')';
           for i = 1:length(idx)
              orderedEigVectors(:,i) = eigVectors(:,idx(i)); 
           end
           eigVectors = orderedEigVectors;
           
           probDist = eigValues/sum(eigValues);
           figure()
           sgtitle("Pesos de las componentes")
           bar(probDist, 'FaceColor', '#42c8e3')
           
       end
       %Al usar esta función los eigen vectores deben venir ordenados
       function projectedData = projectData(obj,data, nComponents, eigVectors)
          nData = size(data,1);
          projectedData = zeros(nData, nComponents);
          projectionMatrix = eigVectors(:,1:nComponents)';
          
          for i = 1:nData
             projectedData(i,:) = projectionMatrix * data(i,:)'; 
          end
       end
       
       
       
       
   end
    
end