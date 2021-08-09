classdef KernelCalculator
   
    methods 
        function K = getKernelMatrix(obj, data, kernelType, param)
            if(kernelType == KernelType.GAUSSIAN)
               n = size(data, 1);
               K = zeros(n,n);
               %En realidad aquí estamos repitiendo varias operaciones,
               %esperemos que no afecte demasiado en tiempo, de lo
               %contrario lo modificaré
               for i = 1:n
                   for j = 1:n
                       K(i,j) = exp(-param*norm(data(i,:)-data(j,:))^2);
                   end
               end
               
            elseif(kernelType == KernelType.POLYNOMIAL)
                n = size(data,1);
                K = zeros(n,n);
                for i = 1:n
                    for j = 1:n
                        K(i,j) = (1 + data(i,:)*data(j,:)')^param;
                    end
                end
            end 
        end
        
        function normK = computeNormalizedK(obj, data, kernelType, param)
           K =  obj.getKernelMatrix(data, kernelType, param);
           m = size(K,1);
           I = (1/m)*ones(m,m);
           normK = K - I*K -K*I + I*K*I;
        end
        
        
    end
    
    
    
end