           identification division.
           program-id.ruleof72.

           environment division.

           data division.
           working-storage section.
           01 intRate      pic 999V99.
           01 timeDouble   pic ZZZ.99.

           procedure division.
               display "Interest Rate(0 - 100%): ".
               accept intRate.

               compute timeDouble = (72 + (intRate - 8) / 3) / intRate.

               display "The time to double is " timeDouble" years: ".
           
           stop run.
           