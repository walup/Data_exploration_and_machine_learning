classdef NeighborhoodCalculator
    methods
        
        function inds = getInclusiveNeighborhoodIndices(obj,row,col, gridWidth, gridHeight, radius)
            inds = [];
            inds = [inds; [row, col]];
            for i = 1:radius
                for p = 1:size(inds,1)
                    pt = inds(p,:);
                    neighbors = [];
                    for j = -1:1
                       for s = -1:1
                           newInds = [pt(1) + j, pt(2) + s];
                           if(~(j == 0 && s == 0) && (j == 0 || s == 0) && newInds(1) >= 1 && newInds(1) <= gridHeight && newInds(2)>=1 && newInds(2)<=gridWidth)
                               neighbors = [neighbors; newInds];
                           end
                       end
                    end
                    for j = 1:size(neighbors, 1)
                        neighbor = neighbors(j,:);
                        if(~ismember(neighbor,inds, 'rows'))
                           inds = [inds; neighbor]; 
                        end
                    end
                end
            end
        end
        
        function dst = getNeighborhoodDistance(obj, x1, x2)
           dst = 0;
           if(length(x1) == length(x2))
               for i = 1:length(x1)
                   dst = dst + abs(x1(i) - x2(i));
               end
           else
               disp("Operación inválida");
           end
           
        end
        
    end
    
end