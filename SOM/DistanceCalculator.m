classdef DistanceCalculator
   methods
       function d = euclideanDistance(obj, x, y)
          if(length(x) == length(y))
             d = 0;
             for i = 1:length(x)
                 d = d + (x(i) - y(i))^2;
             end
             d = sqrt(d);
          else
              d = -1;
          end
       end
   end
    
    
    
end