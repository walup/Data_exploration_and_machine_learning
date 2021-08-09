%Clase para guardar manejo de los datos del clima de Szeged

classdef WeatherData
    
    
   properties
       %Data path
       dataPath = "weatherHistory.xlsx";
       completeTable;
   end
   
   
   methods
       
       function obj = WeatherData(obj)
           T = readtable(obj.dataPath,'PreserveVariableNames',true);
           obj.completeTable = T;
       end
       
       %Obtiene la serie de tiempo de la variable que especifique 
       %el usuario.
       function col = getVariableData(obj,dataType)
          if(dataType == VariableType.FORMATTED_DATE)
              col = table2array(obj.completeTable{:,1});
          elseif(dataType == VariableType.SUMMARY)
              col = obj.completeTable{:,2};
          elseif(dataType == VariableType.PRECIP_TYPE)
              col = obj.completeTable{:,3};
          elseif(dataType == VariableType.TEMPERATURE)
              col = obj.completeTable{:,4};
          elseif(dataType == VariableType.APPARENT_TEMPERATURE)
              col = obj.completeTable{:,5};
          elseif(dataType == VariableType.HUMIDITY)
              col = obj.completeTable{:,6};
          elseif(dataType == VariableType.WIND_SPEED)
              col = obj.completeTable{:,7};
          elseif(dataType == VariableType.WIND_BEARING)
              col = obj.completeTable{:,8};
          elseif(dataType == VariableType.VISIBILITY)
              col = obj.completeTable{:,9};
          elseif(dataType == VariableType.LOUD_COVER)
              col = obj.completeTable{:,10};
          elseif(dataType == VariableType.PRESSURE)
              col = obj.completeTable{:,11};
          elseif(dataType == VariableType.DAILY_SUMMARY)
              col = obj.completeTable{:,12};
          else
              disp("Variable inválida introducida");
              col = -1;
          end
       end
       
       function y = plotTimeSeries(obj,varType)
           d = obj.getVariableData(varType);
           varName = varType.getVariableName();
           figure()
           hold on 
           title("S.tiempo de "+varName)
           plot(d, 'Color','#42c6ff')
           xlabel("N. de dato")
           ylabel(varName)
           hold off
       end
           
       
       
   end
end