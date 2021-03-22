           identification division.
           program-id. TimeValueofMoney.
           
           environment division.

           data division.
           working-storage section.
           01 presentValue pic 9(8)V9(3).
           01 futureValue  pic 9(8)V9(3).
           01 futurePay    pic 9(8)V9(3).
           01 futureVal_out    pic $ZZ,ZZZ,ZZZ.99.
           01 diffVal      pic 9(8)V9(3).
           01 diffVal_out      pic $ZZ,ZZZ,ZZZ.99.
           01 intRate      pic 999V99.
           01 numP         pic 99.

           procedure division.
               display "Present value amount($): ".
               accept presentValue.
               display "Interest rate (0-100%): ".
               accept intRate.
               display "Number of years: ".
               accept numP.

               if intRate < 0 or intRate > 100 then
                   display "Interest rate not between 0-100"
                   stop run
               end-if.

               compute futureValue = presentValue * ((1 + (intRate / 100.0)) ** numP).
               move futureValue to futureVal_out.

               display "Amount recevied in " numP " years: ".
               accept futurePay.
               compute diffVal = futureValue - futurePay.
               move diffVal to diffVal_out.

               display futureValue.
               display "The future value of investment is " futureVal_out.
               display "The difference in value is        " diffVal_out.

           stop run.
