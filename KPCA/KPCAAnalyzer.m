classdef KPCAAnalyzer
    
    properties
        K;
        eigVectors;
        eigValues;
    end
    
    
    
    methods
    
        function obj = KPCAAnalyzer(K)
           obj.K = K; 
        end
        function obj = computeComponents(obj)
           eigValues = real(eig(obj.K));
           [eigVectors, ~] = eig(obj.K);
           
           %Vamos a normalizar los eigen-vectores.
           for i = 1:size(eigVectors,2)
              vec = eigVectors(:,i);
              eigVectors(:,i) = vec/norm(vec); 
           end
           
           %Vamos a ordenarlos de mayor a menor acorde a su eigenvalores
           [eigValues,idx] = sort(eigValues);
           orderedEigVectors = zeros(size(eigVectors,1), size(eigVectors,2));
           eigValues = fliplr(eigValues')';
           idx = fliplr(idx')';
           for i = 1:length(idx)
              orderedEigVectors(:,i) = eigVectors(:,idx(i)); 
           end
           eigVectors = orderedEigVectors;
           obj.eigVectors = eigVectors;
           obj.eigValues = eigValues;
           
           probDist = eigValues/sum(eigValues);
           disp("Primeras dos componentes "+string(sum(probDist(1:2))));
           figure()
           sgtitle("Pesos de las componentes")
           bar(probDist, 'FaceColor', '#42c8e3')
           
    end
       
    
    function projected = projectOriginalData(obj, data, nComponents)
        m = size(data,1);
        projected = zeros(m,nComponents);
        for i = 1:m
           vector =  data(i,:);
           projectedVector = zeros(1,nComponents);
           KVec = obj.K(i,:);
           for j = 1:nComponents
               aCoeffs = obj.eigVectors(:,j);
               projectedVector(j) = sum(aCoeffs.*KVec');
           end
           projected(i,:) = projectedVector;
        end
    end
       
   end
    
end