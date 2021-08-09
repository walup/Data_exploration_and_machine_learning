%En esta clase voy a implementar algunos métodos de estadística que 
%vamos a ocupar


classdef Statistics 
    
   methods
      
       function y = multivariateMean(obj,x)
          n = size(x,2);
          m = size(x,1);
          y  = zeros(m,1);
          for i = 1:n
              y = y+(1/n)*(x(:,i));
          end
       end
       
       
       function y = oneVariableMean(obj, x)
          n = length(x);
          y = 0;
          for i = 1:n
              if(~isnan(x(i)))
                y = y + (1/n)*x(i);
              end
          end
       end
       
       function y = standardDeviation(obj,x)
          n = length(x);
          m = obj.oneVariableMean(x);
          y = 0;
          for i = 1:n
              if(~isnan(x(i)))
                 y = y + (1/n)*(x(i) - m)^2; 
              end
          end
          y = sqrt(y);
       end
       
       function pearson  = getPearsonCorrelation(obj, x, y)
           muX = obj.oneVariableMean(x);
           muY = obj.oneVariableMean(y);
           stdX = obj.standardDeviation(x);
           stdY = obj.standardDeviation(y);
           n = length(x);
           i = 0;
           pearson = 0;
           
           for i = 1:n
               pearson = pearson + (1/n)*(x(i) - muX)*(y(i)-muY);
           end
           
           pearson = pearson/(stdX*stdY);
       end
       
       function med = getMedian(obj,x)
           x = sort(x);
           n = length(x);
           if(mod(n,2) == 0)
               midIndex = (n/2);
               med = (x(midIndex) + x(midIndex +1))/2;
           else
               midIndex = (n+1)/2;
               med = x(midIndex);
           end
       end
       
       function mod = getMode(obj,x)
          %En este caso si será mas fácil usar la función de matlab
          mod = mode(x); 
       end
       

       
   end
    
    
    
end