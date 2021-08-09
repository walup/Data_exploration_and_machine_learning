classdef DistanceCalculator
    methods
        function d = minkowski(obj,x1,x2, p)
            n = length(x1);
            d = 0;
            for i = 1:n
                d  = d + abs(x2(i)- x1(i))^p;
            end
            d = d^(1/p);
        end
        
        
        function d = getMetricDistance(obj, x1, x2, metric, param)
           
           if(metric == MetricType.EUCLIDEAN)
               d = obj.minkowski(x1,x2,2);
           elseif(metric == MetricType.MANHATTAN)
               d = obj.minkowski(x1, x2, 1);
           elseif(metric == MetricType.MINKOWSKI)
               if(~exist('param','var'))
                  param = 5; 
               end
               d = obj.minkowski(x1, x2, param);
           end
            
        end
    end
end