classdef DataPrecook
    
    properties
        
        
    end
    
    
    methods
        %Normalizamos los datos del vector x
        function y = normalize(obj,x) 
            n = length(x);
            y = zeros(n,1);
            %Obtenemos la media y desviación estandar
            mu = mean(x);
            sd = std(x);
            for i = 1:n
                if(sd ~= 0)
                    y(i) = (x(i)-mu)/sd;
                else
                    y(i) = x(i)-mu;
                end
            end
        end
        
        function y = deNormalize(obj,x, mu, std)
            n = length(x);
            y = zeros(n,1);
            for i = 1:n
               y(i) = std*x(i) + mu; 
            end
        end
        
        
    end
    
    
end