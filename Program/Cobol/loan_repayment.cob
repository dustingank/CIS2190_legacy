           identification division.
           program-id. LoanRepayment.

           environment division.
           data division.
           working-storage section.
           01 loanP pic 9(5)V99.
           01 iRate pic 9V99999999.
           01 term pic 999.
           01 monthlyP pic 999V999.
           01 tRate pic 9.

           procedure division.
               display "Principal amount of the loan: ".
               accept loanP.
               display "Intereset rate (%%): ".
               accept iRate.
               display "Loan term(months): ".
               accept term.
               display "(1) fixed or (2) floating interest rate: ".
               accept tRate.

               if tRate is equal to 1 then
                   add 5.0 to iRate
                   divide 100.0 into iRate
                   divide 12.0 into iRate
               else if tRate is equal to 2 then 
                       add 2.5 to iRate
                       divide 100.0 into iRate
                       divide 12.0 into iRate
                   end-if
               end-if.
               compute monthlyP = (iRate / (1.0 - (1 + iRate) ** -term)) * loanP.
               display "The monthy payment is: "monthlyP" ".
               stop run.
