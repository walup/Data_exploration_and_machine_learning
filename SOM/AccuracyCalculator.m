classdef AccuracyCalculator
   methods
       
       function acc = getAccuracy(obj, truePositives, trueNegatives, falsePositives, falseNegatives)
           acc = (truePositives + trueNegatives)/(truePositives + trueNegatives + falsePositives + falseNegatives);
       end 
   end
   
end