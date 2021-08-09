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
                y(i) = (x(i)-mu)/sd;
            end
        end
    end
    
    
end