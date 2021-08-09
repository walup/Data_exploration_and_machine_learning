classdef VariableType
    
   enumeration
       FORMATTED_DATE,
       SUMMARY,
       PRECIP_TYPE,
       TEMPERATURE,
       APPARENT_TEMPERATURE,
       HUMIDITY,
       WIND_SPEED,
       WIND_BEARING,
       VISIBILITY,
       LOUD_COVER,
       PRESSURE, 
       DAILY_SUMMARY
   end
   
   
   methods
       function s = getVariableName(obj)
           if(obj == VariableType.FORMATTED_DATE)
              s = "Fecha";
          elseif(obj == VariableType.SUMMARY)
              s = "Resumen";
          elseif(obj == VariableType.PRECIP_TYPE)
              s = "Tipo de precipitación";
          elseif(obj == VariableType.TEMPERATURE)
              s = "Temperatura";
          elseif(obj == VariableType.APPARENT_TEMPERATURE)
              s = "Temperatura Aparente";
          elseif(obj == VariableType.HUMIDITY)
              s = "Humedad";
          elseif(obj == VariableType.WIND_SPEED)
              s = "Velocidad del viento";
          elseif(obj == VariableType.WIND_BEARING)
              s = "Turbulencia del viento";
          elseif(obj == VariableType.VISIBILITY)
              s = "Visibilidad";
          elseif(obj == VariableType.LOUD_COVER)
              s = "Cobertura de nubes?";
          elseif(obj == VariableType.PRESSURE)
              s = "Presión";
          elseif(obj == VariableType.DAILY_SUMMARY)
              s = "Resumen diario";
          else
              disp("Variable inválida introducida");
              s = -1;
          end
           
           
           
       end
       
       
   end
    
    
end