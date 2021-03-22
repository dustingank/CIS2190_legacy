identification division.
program-id. WindChill.

environment division.

data division.
working-storage section.
01 airTemp   pic S99V9.
01 windS     pic S99V9.
01 windCF    pic S99V9999.
01 windCFo   pic --9.9999.

procedure division.
    display "Air temperature (Celsius): ".
    accept airTemp.
    display "Wind speed (km/hr): ".
    accept windS.

    if airTemp is <= 0.0 then
        if windS is >= 5.0 then
            compute windCF = 13.12 + (0.6215 * airTemp) - (11.37 * windS ** 0.16) 
                                   + (0.3965 * airTemp * windS ** 0.16)
        else if windS is > 0.0 and windS is < 5.0 then
                compute windCF = airTemp  + ((-1.59 + 0.1345 * airTemp) / 5.0) * windS 
            else
                display "There is no wind"
                stop run
            end-if
        end-if
        move windCF to windCFo
        display "The temperature feels like " windCFo " degrees Celsius"
    else
        display "Unable to calculate - the air temperature is too high"
    end-if.

stop run.
