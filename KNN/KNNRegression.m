classdef KNNRegression
    
   properties
       data;
       dataFuncVals;
       metric;
       distanceCalculator;
       k;
   end
   
   methods
       %El clasificador se inicializa con los datos "de entrenamiento", 
       %la clase a la que pertenece cada uno de los datos, el número de
       %vecinos que votaran y la metrica, que puede ser
       %MetricType.EUCLIDEAN, MetricType.MANHATTAN o MetricType.MINKOWSKI. 
       %El valor por default para el grado en la metrica Minkowski es p =
       %3
       function obj = KNNRegression(data, dataFuncVals, k, metric)
           obj.data = data;
           obj.k = k;
           obj.dataFuncVals = dataFuncVals;
           obj.metric = metric;
           obj.distanceCalculator = DistanceCalculator();
       end
       
       function value = regression(obj,x)
           %Primero calculamos la distancia a x, de cada uno de los datos
           %esto es O(nd) donde d es la dimensión de los vectores
           n = size(obj.data, 1);
           distances = zeros(n,  1);
           for i = 1:n
               distances(i) = obj.distanceCalculator.getMetricDistance(x,obj.data(i,:),obj.metric);
           end
           %Ahora vamos a encontrar los indices que corresponden a las k
           %menores distancias esto toma O(nk)
           
           minIndexes = zeros(obj.k,1);
           for i = 1:obj.k
              minDistance = Inf; 
              minIndex = -1;
              for j = 1:n
                  if(distances(j) ~= -1 && distances(j)<minDistance)
                     minDistance = distances(j);
                     minIndex = j;
                  end
              end
              minIndexes(i) = minIndex;
              %Ponemos una bandera para no tener que considerar mas la
              %distancia encontrada.
              distances(minIndex) = -1;
           end
           
           value = 0;
           for i = 1:obj.k
               value = value +(1/obj.k)*obj.dataFuncVals(minIndexes(i));
           end
       end
       
       
       
       
   end
    
end