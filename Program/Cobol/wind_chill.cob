           identification division.
           program-id. windChill.
           
           environment division.

           data division.
           working-storage section.
           01 temperature pic S999V99.
           01 windSpeed pic S999V99.
           01 windChill pic S99V9999.
           01 windCFo   pic --9.9999.

           procedure division.
               display "Enter the Air Temperature(Celsius): ".
               accept temperature.
               display "Enter the Wind Speed(km/hr): ".
               accept windSpeed.

               if temperature is <= 0.0 then 
                   if windSpeed is >= 5.0 then
                       compute windChill = 13.12 + (0.6215 * temperature) - (11.37 * windSpeed ** 0.16) 
                                                 + (0.3965 * temperature * windSpeed ** 0.16)
                   else if windSpeed is > 0.0 and windSpeed is < 5.0 then
                       compute windChill = temperature + ((-1.59 + 0.1345 * temperature) / 5.0) * windSpeed
                       else
                           display "there is no wind"
                           stop run
                       end-if
                   end-if
                   move windChill to windCFo
                   display "The temperature feels like "windCFo" degrees Celsius"
               else 
                   display "Unablie to calcualte - the air temperature is too high"
               end-if.
           
           stop run.
