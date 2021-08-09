classdef KNNClassifier
    
   properties
       data;
       dataClasses;
       nClasses;
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
       function obj = KNNClassifier(data, dataClasses, k, metric)
           obj.data = data;
           obj.k = k;
           obj.metric = metric;
           obj.distanceCalculator = DistanceCalculator();
           diffClasses = [];
           %Contamos el número de clases.
           for i = 1:length(dataClasses)
              if (~any(diffClasses == dataClasses(i)))
                 diffClasses  = [diffClasses, dataClasses(i)]; 
              end
           end
           obj.dataClasses = dataClasses;
           obj.nClasses = length(diffClasses);
       end
       
       function class = classify(obj,x)
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
           
           %Ahora que ya tenemos los indices de los k-vecinos mas cercanos
           %procedemos al voto, esto toma O(k).
           votes = zeros(obj.nClasses,1);
           maxVotes = 0;
           class = Inf;
           for i = 1:obj.k
               c = obj.dataClasses(minIndexes(i));
               votes(c) = votes(c)+1;
               if(votes(c)>maxVotes)
                  maxVotes = votes(c);
                  class = c;
               end
           end
       end
       
       
       
       
   end
    
end