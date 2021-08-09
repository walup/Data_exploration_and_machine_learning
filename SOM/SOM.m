classdef SOM 
    
    properties
        data;
        dimData;
        neurons;
        neuronsWidth;
        neuronsHeight;
    end
    
    
    methods
        function obj = SOM(data, neuronsWidth, neuronsHeight)
            obj.data = data;
            dimData = size(data, 2);
            %Inicializamos aleatoriamente las neuronas
            obj.neuronsWidth = neuronsWidth;
            obj.neuronsHeight = neuronsHeight;
            obj.neurons = rand(neuronsHeight, neuronsWidth, dimData);
            obj.dimData = dimData;
        end
        
        function obj = trainOnline(obj, eta, radius, epochs)
            neighborhoodCalculator = NeighborhoodCalculator();
            nData = size(obj.data, 1);
            f = waitbar(0,'Calculando SOM');
            for i = 1:epochs
                %Vamos a ir disminuyendo linealmente el radio y el factor
                %de aprendizaje
                sigma = round(radius*(1 - (i-1)/epochs));
                learningRate = eta*(1 - i/epochs);
                waitbar(i/epochs,f, "Calculando SOM radio "+string(sigma));
                %seleccionamos un dato aleatorio
                randVector = obj.data(randi([1,nData]), :)';
                
                %encontramos el vector w que mas se parezca a ese vector 
                ind1 = 0;
                ind2 = 0;
                minDistance = Inf;
                for row = 1:obj.neuronsHeight
                    for col = 1:obj.neuronsWidth
                        dist = norm(reshape(obj.neurons(row, col, :),[obj.dimData 1]) - randVector);
                        if(dist < minDistance)
                           ind1 = row;
                           ind2 = col;
                           minDistance = dist;
                       end
                    end
                end
                
                %Determinamos los vecinos a modificar
                indsToModify = neighborhoodCalculator.getInclusiveNeighborhoodIndices(ind1, ind2, obj.neuronsWidth, obj.neuronsHeight, sigma);
                bmuNeuron = reshape(obj.neurons(uint32(ind1), uint32(ind2), :),[obj.dimData, 1]);
                %Actualizamos el peso de dichas neuronas
                for j = 1:size(indsToModify, 1)
                    inds = indsToModify(j,:);              
                    neuron = reshape(obj.neurons(uint64(inds(1)), uint64(inds(2)),:),[obj.dimData, 1]);
                    neighborhoodDist = neighborhoodCalculator.getNeighborhoodDistance(bmuNeuron, neuron);
                    if(neighborhoodDist ~= 0)
                        bmuDist = exp(-((norm(neuron - bmuNeuron)^2)/(2*neighborhoodDist^2)));
                    else
                       bmuDist = 1; 
                    end
                    obj.neurons(inds(1), inds(2),:) = neuron - learningRate * bmuDist*(neuron - randVector);                    
                end
            end
            close(f);
        end
        
        
        function u = getUMatrix(obj)
            u = zeros(2*obj.neuronsHeight - 1, 2*obj.neuronsWidth - 1);
            neighborCalc = NeighborhoodCalculator();
            distCalc = DistanceCalculator();
            for i = 1:obj.neuronsHeight
               for j = 1:obj.neuronsWidth
                   neighbors = neighborCalc.getInclusiveNeighborhoodIndices(i,j,obj.neuronsWidth, obj.neuronsHeight, 1);
                   value = 0;
                   neuron = reshape(obj.neurons(i,j,:),[obj.dimData,1]);
                   for k = 1:size(neighbors, 1)
                       inds = neighbors(k,:);
                       dst = norm(neuron -reshape(obj.neurons(inds(1), inds(2),:),[obj.dimData,1]));
                       value = value + (1/size(neighbors,1))*dst;
                       if(inds(1) == i && inds(2) ~= j)
                           u(2*i-1,2*min(inds(2), j)) = dst;
                       elseif(inds(2) == j && inds(1)~= i)
                           u(2*min(inds(1), i), 2*j-1) = dst;
                       end
                       endf
                   u(uint64(2*i-1), uint64(2*j-1)) = value;
               end
            end
            %Hasta aquí, ya habremos llenado una buena parte de los valores
            %de U, pero faltarán por llenar algunos huecos
            uHeight = size(u,1);
            uWidth = size(u,2);
            for i = 1:uHeight
                for j = 1:uWidth
                   if(mod(i,2) == 0 && mod(j,2) == 0)
                       neighbors = neighborCalc.getInclusiveNeighborhoodIndices(i,j,uWidth, uHeight, 1);
                       s = 0;
                       for k = 1:size(neighbors, 1)
                          nInds = neighbors(k,:);
                          s = s + (1/size(neighbors,1))*u(nInds(1), nInds(2));
                       end
                       u(i,j) = s;
                   end
                end 
            end
        end
        
        function class = somClassify(obj, vector)
            class = 0;
            classCounter = 0;
            minDist = Inf;
            for i = 1:obj.neuronsHeight
               for j = 1:obj.neuronsWidth
                   d = norm(reshape(obj.neurons(i, j, :),[obj.dimData 1]) - vector');
                   if(d < minDist)
                      class = classCounter;
                      minDist = d;
                   end
                   classCounter = classCounter + 1;
               end
            end
        end
        
        
        
        
    end
    
    
    
    
    
    
end