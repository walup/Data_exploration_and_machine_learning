classdef AccuracyCalculator
   properties
       
       
   end
   
   
   methods
       function acc = calculateAccuracy(obj, tp, fp, tn, fn)
           acc = (tp + tn)/(tp + tn + fp + fn);
       end
   end
    
    
    
end